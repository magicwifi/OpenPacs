class Operation < ActiveRecord::Base
  attr_accessible :user_id, :title, :position, :sick_date, :desc, :edited

  belongs_to :user, :touch => true
  
  has_many :image_assets
  has_many :dicoms
  
  acts_as_list scope: :user 

end
