# encoding: utf-8
require 'httparty'

class ApiController < ApplicationController
skip_before_action :verify_authenticity_token


  def back_code(code,msg)
    respond_to do |format|
      format.html {render text: "Error#{code.to_s}-#{msg}"}
      format.json {render :json => {:status => {:code=>code.to_s, :message=>msg}}}
    end
  end

  def dicom
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

  def delete
	path = 'http://117.34.78.199/orthanc/instances/'+params[:name]
	response = HTTParty.delete(path)
	if !response.nil? 
		dicom = Dicom.find_by_name(params[:name])
		dicom.destroy
	end
    	respond_to do |f|
      	f.js do
	@user = current_user
	end
      	end
  end

  def money
   respond_to do |f|
    f.json {
      result = []

      orders = Order.where('total_fee  IS  NOT NULL')
      orders.each do |order|
        result << {
          :total_fee => order.total_fee,
          :date => order.created_at.strftime(t('date.formats.default'))
        }
      end
      # Workaround for https://github.com/rails/rails/issues/15081
      # TODO When the bug above is fixed we should just be able to replace the block below with
      # render :json => result, :callback => params[:callback]
      if params[:callback]
        render :json => result, callback: params[:callback], content_type: "application/javascript"
      else
        render :json => result
      end
    }
    end
  end

  	def show_basic_cases
		check = Doctor.show_basic_list(params)
		if check[:check]
			render :json => {:code=>'200',:result =>check[:result],:free=>check[:free] }
		else
			back_code(check[:code],check[:msg])
		end
	end  

  	def show_basic_info
		check = User.show_basic_info(params)
		if check[:check]
			render :json => {:code=>'200',:basic_info =>check[:basic_info], :hyperlipidemia=>check[:hyperlipidemia],:diabetes=>check[:diabetes],:hypertension=>check[:hypertension],:operation=>check[:operation],:sicknesses =>check[:sicknesses], :sick_hists => check[:sick_hists] }
		else
			back_code(check[:code],check[:msg])
		end
	end  

  	def show_basic_case
		check = BasicCase.show_basic_case(params)
		if check[:check]
			render :json => {:code=>'200',:basic_case =>check[:basic_case], :body_sign=>check[:body_sign],:sick_assets=>check[:sick_assets] }
		else
			back_code(check[:code],check[:msg])
		end
	end  

end
