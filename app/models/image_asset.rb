class ImageAsset < ActiveRecord::Base
  attr_accessible :operation_id, :filename, :asset
  
  belongs_to :operation

end
