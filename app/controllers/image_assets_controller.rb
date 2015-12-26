class ImageAssetsController < ApplicationController
  def create
    respond_to do |f|
      f.js do
        @image_asset = ImageAsset.new
        @image_asset.asset = params[:key]
        @image_asset.size = params[:fsize]
        @image_asset.filename = params[:fname]
        @image_asset.content_type = params[:mimeType]
        @image_asset.operation_id = params[:custom_fields][:operation_id] 
        @image_asset.save
        #track_activity @image_asset, @image_asset.sick_case.id
      end
    end
  end
end
