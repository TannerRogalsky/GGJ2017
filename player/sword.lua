local Sword = class('Sword', Base)

function Sword:initialize(body, fixture, joint)
  Base.initialize(self)

  self.body = body
  self.fixture = fixture
  self.fixture:setUserData(self)
  self.joint = joint

  self.swinging = false
  self.damage = 1
end

return Sword
