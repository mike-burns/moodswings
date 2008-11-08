class Mood < ActiveRecord::Base
  validates_presence_of :name, :user_id

  belongs_to :user

  before_validation :set_name_from_coordinate

  attr_writer :x, :y

  private

  def set_name_from_coordinate
    self.name = 'bittersweet' unless @x.nil?
  end
end
