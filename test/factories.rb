Factory.sequence(:openid_identity) { |n| "http://oid#{n}.example.com/" }
Factory.sequence(:nickname) { |n| "mike-#{n}" }

Factory.define :user do |u|
  u.openid_identity { Factory.next(:openid_identity) }
  u.nickname        { Factory.next(:nickname) }
end
