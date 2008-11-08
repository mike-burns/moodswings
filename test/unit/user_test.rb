require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context "stubbing out #generate_nickname" do
    setup do
      User.any_instance.expects(:downcase_nickname)
      User.any_instance.expects(:generate_nickname)
    end

    should_require_attributes :openid_identity, :nickname

    should_allow_values_for :openid_identity, 'http://me.example.com/'
    should_allow_values_for :nickname, '0m.i~k!e-b@u=r:n,s_0'
    should_allow_values_for :timezone, 'Central Time (US & Canada)',
      'Hawaii', 'Brasilia'

    should_not_allow_values_for :openid_identity, 'example.com'
    should_not_allow_values_for :nickname, 'm e', 'm&e', 'm%e',
      'm?e', 'm>e', 'm<e', 'm/e', 'm"e', 'm`e', 'm\e', 'm#e', 'm$e',
      'm^e', 'm*e', 'm(e', 'm)e', 'm[e', 'm]e', 'm{e', 'm}e', 'm|e',
      'm;e', 'm\'e', 'Me'
    should_not_allow_values_for :timezone, 'jklasd',
      :message => /is not included in the list/
  end

  context "a User" do
    setup do
      @user = Factory(:user)
    end

    should_have_db_column :new_openid_identity, :type => 'string'
    should_require_unique_attributes :openid_identity, :nickname
    should_have_many :moods
  end


  context "on save" do
    should "set the default nickname to a gsub of the OpenID" do
      user = Factory.build(:user, :nickname => nil)
      user.save!
      dashed = user.openid_identity.gsub(/\W/,'-')
      assert_equal dashed, user.nickname
    end

    should "lowercase the nickname" do
      nickname = Factory.next(:nickname).upcase
      user = Factory.build(:user, :nickname => nickname)
      user.save!
      assert_equal nickname.downcase, user.nickname
    end

    [:openid_identity, :nickname].each do |field|
      should "only give one error for blank #{field}" do
        user = Factory.build(:user, field => '')
        user.expects(:downcase_nickname)
        user.expects(:generate_nickname)
        user.valid?
        assert_kind_of String, user.errors[field]
      end
    end
  end

  context "on update" do
    setup do
      @user = Factory(:user)
    end

    should "lowercase the nickname" do
      nickname = Factory.next(:nickname).upcase
      @user.update_attributes!(:nickname => nickname)
      assert_equal nickname.downcase, @user.reload.nickname
    end
  end

  context "sent .openid_registration" do
    setup do
      @openid_identity = Factory.next(:openid_identity)
    end

    context "for an existing user" do
      setup do
        @user = Factory(:user, :openid_identity => @openid_identity)
      end

      context "" do
        setup do
          @result = User.openid_registration(@openid_identity, {})
        end

        should "find the correct user" do
          assert_equal @user, @result
        end

        should_not_change 'User.count'
      end
    end

    context "for a new user" do
      setup do
        User.delete_all({:openid_identity => @openid_identity})
      end

      context "with a nickname" do
        setup do
          @registration = {
            'nickname' => Factory.next(:nickname),
            'timezone' => 'Hawaii',
            'postcode' => '02108'
          }
          @result = User.openid_registration(@openid_identity, @registration)
        end

        should_not_change 'User.count'

        context "should produce a user which" do
          setup do
            assert_not_nil @result
          end

          should "have the specified openid_identity" do
            assert_equal @openid_identity, @result.openid_identity
          end

          should "have the specified nickname" do
            assert_match %r{^#{@registration['nickname']}$}i, @result.nickname
          end

          should "have the specified timezone" do
            assert_equal @registration['timezone'], @result.timezone
          end

          should "have the specified location" do
            assert_equal @registration['postcode'], @result.location
          end
        end
      end

      context "without a nickname" do
        setup do
          @registration = {}
          @result = User.openid_registration(@openid_identity, @registration)
        end

        should_not_change 'User.count'

        context "should produce a user which" do
          setup do
            assert_not_nil @result
          end

          should "have the specified openid_identity" do
            assert_equal @openid_identity, @result.openid_identity
          end

          should "have a nil nickname" do
            assert_nil @result.nickname
          end

          should "have the specified timezone" do
            assert_equal @registration['timezone'], @result.timezone
          end

          should "have the specified location" do
            assert_equal @registration['postcode'], @result.location
          end
        end
      end
    end
  end
end
