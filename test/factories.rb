Factory.sequence(:openid_identity) { |n| "http://oid#{n}.example.com/" }
Factory.sequence(:nickname) { |n| "mike-#{n}" }

Factory.define :user do |u|
  u.openid_identity { Factory.next(:openid_identity) }
  u.nickname        { Factory.next(:nickname) }
end

Factory.define :mood do |m|
  m.red 200
  m.green 200
  m.blue 200
  m.association :user
end
