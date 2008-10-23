class User < ActiveRecord::Base
  validates_presence_of  :openid_identity
  validates_presence_of  :nickname
  validates_format_of    :openid_identity, :allow_blank => true,
                         :with => /.+:.+/
  validates_format_of    :nickname,        :allow_blank => true,
                         :with => /\A[a-z0-9_\-~!@_+=:,\.]+\Z/
  validates_inclusion_of :timezone, :in => ActiveSupport::TimeZone.all.map(&:name),
                         :allow_nil => true, :allow_blank => true
  validates_uniqueness_of :openid_identity
  validates_uniqueness_of :nickname

  before_validation_on_create :generate_nickname, :downcase_nickname
  before_validation_on_update :downcase_nickname

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

  def downcase_nickname
    self.nickname = self.nickname.downcase
  end
end
