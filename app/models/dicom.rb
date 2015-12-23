class Dicom < ActiveRecord::Base
  attr_accessible :user_id, :pc_url, :mobile, :instance_create, :name
  belongs_to :user
end
