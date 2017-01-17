local clock = os.clock
local getinfo = debug.getinfo
local sethook = debug.sethook
local sort = table.sort
local format = string.format

local profile = {}

-- filter non-hooked functions
local _filter = nil
-- user-hooked functions
local _hooked = {}
-- function labels
local _labeled = {}
-- function definitions
local _defined = {}
-- time of last call
local _tcalled = {}
-- total execution time
local _telapsed = {}
-- number of calls
local _ncalls = {}
-- list of internal profiler functions
local _internal = {}

-- we use a stack so that we don't have to
-- call "getinfo" when the function returns
local _stack = {}
local _size = 0

local function _hooker(event)
  local info
  if event == "call" then
    -- push on the stack
    info = getinfo(2, 'nfS')
    _size = _size + 1
    _stack[_size] = info
  else
    -- pop off the stack
    info = _stack[_size]
    _stack[_size] = nil
    -- empty?
    if info == nil then
      return
    end
    _size = _size - 1
  end
  -- function address
  local f = info.func
  -- ignore if not hooked
  if _filter then
    if _filter == "hooked" then
      if not _hooked[f] then
        return
      end
    elseif _filter == "internal" then
      if not _internal[f] then
        return
      end
    elseif _filter ~= info.what then
      return
    end
  end
  -- ignore if explicitly unhooked
  if _hooked[f] == false then
    return
  end
  -- grab the function name and line definition
  if not _labeled[f] then
    --local info = getinfo(2, 'nfS')
    _labeled[f] = info.name
    if not _defined[f] then
      _defined[f] = format("%s:%s", info.short_src, info.linedefined)
      _ncalls[f] = 0
      _telapsed[f] = 0
    end
  end
  -- count the number of calls and execution time
  if event == "call" then
    _tcalled[f] = clock()
    _ncalls[f] = (_ncalls[f] or 0) + 1
  elseif event == "return" then
    _telapsed[f] = (_telapsed[f] or 0) + clock() - _tcalled[f]
  end
end

local _i, _i2 = 0, 0
local _f = {}
local function _iterator()
  if _i == _i2 then
    return
  end
  local f = _f[_i]
  _i = _i - 1
  return _labeled[f] or _defined[f], _ncalls[f] or 0, _telapsed[f] or 0, _defined[f]
  --return tostring(f), _ncalls[f] or 0, _telapsed[f] or 0, _defined[f]
end

local _fs, _fs2 = nil, nil
local function _comp(a, b)
  if _fs[a] == _fs[b] then
    return _fs2[a] < _fs2[b]
  end
  return _fs[a] < _fs[b]
end

--- Sets a clock function to be used by the profiler.
-- @param f Clock function that returns a number
function profile.setclock(f)
  assert(type(f) == "function", "clock must be a function")
  clock = f
end

--- Starts collecting data.
function profile.start()
  sethook(_hooker, "cr")
end

--- Stops collecting data.
function profile.stop()
  sethook()
  _stack = {}
  _size = 0
end

--- Resets all collected data.
function profile.reset()
  for k, v in pairs(_ncalls) do
    _ncalls[k] = 0
  end
  for k, v in pairs(_tcalled) do
    _tcalled[k] = 0
  end
  for k, v in pairs(_telapsed) do
    _telapsed[k] = 0
  end
end

--- Collects data for a given function.
-- @param f Function
-- @param fn Function name or label
function profile.hook(f, fn)
  assert(type(f) == "function", "cannot hook a non-function")
  assert(fn == nil or type(fn) == "string", "function label must be a string")
  local info = getinfo(f, 'nS')
  _hooked[f] = true
  _labeled[f] = fn or info.name
  if not _defined[f] then
    _defined[f] = format("%s:%s", info.short_src, info.linedefined)
    _ncalls[f] = 0
    _telapsed[f] = 0
  end
  fn = info.name
  _filter = "hooked"
end

--- Ignores data for a given function.
-- @param f Function
function profile.unhook(f)
  assert(type(f) == "function", "cannot unhook a non-function")
  _hooked[f] = false
  _labeled[f] = nil
end

--- Collects data for functions of a given type.
-- @param what Type of functions to profile, could be "Lua", "C", "hooked" or "internal" (optional)
function profile.hookall(what)
  _filter = what
  if what == "internal" then
    for f in pairs(_internal) do
      profile.hook(f)
    end
  end
end

--- Iterates all functions that have been called since the profile was started.
-- @param s Type of sorting, could be by "call" or "time" (optional)
-- @param n Number of results (optional)
function profile.query(s, n)
  _fs, _fs2 = _ncalls, _telapsed
  if s == "time" then
    _fs, _fs2 = _fs2, _fs
  end
  for i = #_f, 1, -1 do
    _f[i] = nil
  end
  for f in pairs(_ncalls) do
    _f[#_f + 1] = f
  end
  sort(_f, _comp)
  _i = #_f
  _i2 = 0
  if n and _i > n then
    _i2 = _i - n
  end
  -- todo: check for nested queries
  return _iterator
end

function profile.report(s, n)
  local sz = "Profiling report\n================\n"
  local i = 1
  for f, c, t, d in profile.query(s, n) do
    sz = sz .. format("%d.'%s'x%d time:%s (%s)\n", i, f, c, t, d)
    i = i + 1
  end
  return sz
end

-- store all internal profiler functions
for k, v in pairs(profile) do
  if type(v) == "function" then
    _internal[v] = true
  end
end
_internal[_iterator] = true
_internal[_comp] = true
_internal[sethook] = true
_internal[getinfo] = true

-- don't remove unless you want to profile the profiler
for f in pairs(_internal) do
  profile.unhook(f)
end

return profile
