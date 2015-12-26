class Dicom < ActiveRecord::Base
  attr_accessible :user_id, :pc_url, :mobile, :instance_create, :name, :operation_id
  belongs_to :user
  belongs_to :operation
end
