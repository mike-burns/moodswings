class Mood < ActiveRecord::Base
  validates_presence_of :red, :green, :blue, :user_id

  belongs_to :user
end
