Factory.define :user do |user|
  user.openid_identity 'http://example.com/'
  user.nickname        'Mike'
end
