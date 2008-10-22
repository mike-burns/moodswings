require 'test_helper'

class UserTest < ActiveSupport::TestCase
  context "stubbing out #generate_nickname" do
    setup do
      User.any_instance.expects(:generate_nickname)
    end

    should_require_attributes :openid_identity, :nickname
  end

  should_allow_values_for :openid_identity, 'http://example.com/'
  should_allow_values_for :nickname, '0mike-burns_0'

  should_not_allow_values_for :openid_identity, 'example.com'
  should_not_allow_values_for :nickname, 'm e', 'm&e', 'm%e'

  should "set the default nickname to a gsub of the OpenID" do
    user = Factory.build(:user,
                         :nickname => nil,
                         :openid_identity => 'http://example.com/')
    user.save!
    dashed = user.openid_identity.gsub(/\W/,'-')
    assert_equal dashed, user.nickname
  end

  context "sent .openid_registration" do
    setup do
      @openid_identity = 'http://example.com/'
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
            'nickname' => 'Joe',
            'timezone' => 'America/Los_Angeles',
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
            assert_equal @registration['nickname'], @result.nickname
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
