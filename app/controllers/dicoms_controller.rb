# encoding: utf-8
require 'httparty'
require 'rqrcode_png'  

class DicomsController < ApplicationController
skip_before_action :verify_authenticity_token


  def create
	path = 'http://117.34.78.199/orthanc'+params[:Path]
	response = HTTParty.get(path)
	pc_url = response["ParentSeries"]
	@user = current_user
    	respond_to do |f|
      	f.js do
	if !pc_url.nil? 
		user_id = current_user.id
		Dicom.create!(:name=>params[:ID],:pc_url=>pc_url,:mobile=>params[:Path],:instance_create=>response["MainDicomTags"]["InstanceCreationDate"],:user_id=>user_id   )
	
	end
      	end
    	end
  end

  def destroy
    	dicom = Dicom.find(params[:id])
	path = 'http://117.34.78.199/orthanc/instances/'+dicom.name
	response = HTTParty.delete(path)
	if !response.nil? 
		dicom.destroy
	end
	@user = current_user
	render layout: false
  end

  def show
	dicom = Dicom.find(params[:id])
      	path = 'http://117.34.78.199/orthanc/dwv-plugin/dwv/viewers/mobile/index.html?input=http://117.34.78.199/orthanc/'+dicom.mobile+'/file&dwvReplaceMode=void'
    	respond_to do |f|
      	f.js do
	@qr = RQRCode::QRCode.new(path).to_img.resize(200, 200).to_data_url
	end
      	end
  end


end
