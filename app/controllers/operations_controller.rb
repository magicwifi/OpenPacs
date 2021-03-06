class OperationsController < ApplicationController
  def create
    respond_to do |f|
      f.js do
        @operation = Operation.new
        @operation.user_id = current_user.id
      	if params[:etag].present?
        @operation.asset = params[:key]
        @operation.size = params[:fsize]
        @operation.filename = params[:fname]
        @operation.content_type = params[:mimeType]
        @operation.title = params[:custom_fields][:title] 
        @operation.desc = params[:custom_fields][:desc] 
        @operation.sick_date = params[:custom_fields][:sick_date] 
	else
        @operation.title = params[:operation][:title] 
        @operation.desc = params[:operation][:desc] 
        @operation.sick_date = params[:operation][:sick_date] 
	end
        @operation.save
        #track_activity @operation, @operation.sick_case.id
      end
    end
  end

  def update
    @operation = Operation.find(params[:id])
    @user =  current_user
    @operation.update_attributes(params[:operation])
    @operation.edited =  true;
    @operation.save;
    respond_to do |f|
        f.js do
    		@operations = @user.operations.where(:edited=>true)
        end
    end
  end

  def sort
    params[:operation].each_with_index do |id, index|
      Operation.update_all({position: index + 1}, {id: id})
    end
    render nothing: true
  end

  def destroy
    operation = Operation.find(params[:id])
    #track_activity operation, operation.sick_case.id
    destroy_notifications operation
    operation.destroy
    redirect_to "/editmyoper"
  end

  def download
    operation_path = "http://#{Settings.qiniu.bucket_domain}/#{params[:asset]}"
    redirect_to operation_path
  end
end
