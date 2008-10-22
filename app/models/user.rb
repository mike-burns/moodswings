class User < ActiveRecord::Base
  validates_presence_of :openid_identity
  validates_presence_of :nickname
  validates_format_of   :openid_identity, :with => /.+:.+/
  validates_format_of   :nickname, :with => /^[a-zA-Z_-`~!@\#$^*\(\)_+-=\[\]{}|;':",\.\/<>?]+$/

  before_validation_on_create :generate_nickname

  def self.openid_registration(openid_identity, registration)
    find_by_openid_identity(openid_identity) ||
      new(:openid_identity => openid_identity,
          :nickname => registration['nickname'],
          :location => registration['postcode'],
          :timezone => registration['timezone'])
  end

  private

  def generate_nickname
    self.nickname ||= self.openid_identity.gsub(/\W/,'-')
  end
end
