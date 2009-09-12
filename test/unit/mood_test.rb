require 'test_helper'

class MoodTest < ActiveSupport::TestCase
  context "a Mood" do
    setup do
      @mood = Factory(:mood)
    end

    should_have_db_column :name, :type => 'string'
    should_have_db_column :user_id, :type => 'integer'

    should_belong_to :user
    should_validate_presence_of :name, :user_id
  end

  # the plan here is to have x= and y=, then on save set the name
  context "when x and y are set, on save" do
    setup do
      @mood = Factory.build(:mood, :name => nil)
      @mood.x = 10
      @mood.y = 10
      @mood.save
    end

    should "set the name" do
      assert_not_nil @mood.name
    end

    should "nail this down"
  end
end
