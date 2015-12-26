class BasicInfosController < ApplicationController
  before_filter :check_login
  skip_before_filter :verify_authenticity_token, :only => [:check_my_doctor]

  def edit
    @user = current_user
    @basic_info = @user.basic_info
  end

  def dicomupload
	render layout: false
  end

  def dicom
	path = '/orthanc'+params[:Path]
	response = HTTParty.get(path)
	pc_url = response[:ParentSeries]
	if !pc_url.nil? 
		user_id = current_user.id
		Dicom.create!( :pc_url=>pc_url,:mobile_url=>path,:instance_create=>response[:InstanceCreationDate],:user_id=>user_id   )
		render :text=>'dicom success'
	else
		render :text=>'dicom fail'
	
	end
  end

  def asked 
     @user = current_user
     basic_cases = @user.basic_cases;
     @doctor_groups = []
     @basic_groups = []
     basic_cases.each do |basic_case|
     	if !basic_case.doctor.nil? and @doctor_groups.exclude?(basic_case.doctor)
		@doctor_groups << basic_case.doctor
		@basic_groups << basic_case
	end
     end
  end

  def check_my_doctor
    @user = current_user
    commit = params[:commit] 
    process = params[:process] 
    @doctor = Doctor.find_by_doctor_id(params[:doctor])	
    @basic_case = @user.basic_cases.where(:process=>nil,:doctor_id=>nil).where.not(:main_desc=>nil).last
    if process == "commit" && !@basic_case.nil?  
    	@basic_cases = @user.basic_cases.where(:process=>nil,:doctor_id=>nil).where.not(:main_desc=>nil)
	@commit_status = commit
	reservation = @doctor.reservations.where(:price_type=>commit).first
	if !reservation.nil?
		@price = reservation.price
		render "new_order"
	else	
		flash[:notice] = t('not_support_this_type')
		redirect_to "/doctors"
	end	
	
    else
	if @basic_case.nil?
    		@basic_case = BasicCase.create!(:user_id =>@user.id,:public=>true)
    		body_sign =   BodySign.create!(:basic_case_id=>@basic_case.id,:swelling=>"",:status_name=>"")
    		@basic_case.body_sign = body_sign
    		@basic_case.save
	else
		body_sign = @basic_case.body_sign
	end
	
	@commit_status = commit
    	@status_names = body_sign.status_name.split  
	render "commit_doctor"
    end
  end

  def new_order
  end

  def commit_doctor
  end

  def new_doctor
    @user = current_user
    @doctor = Doctor.find_by_name(params[:doctor_name])	
    @basic_case = BasicCase.find(params[:basic_case_id])
    @basic_case.save 
    @commit_status = params[:commit_status]
    @basic_cases = @user.basic_cases.where(:process=>nil,:doctor_id=>nil).where.not(:main_desc=>nil)
    reservation = @doctor.reservations.where(:price_type=>@commit_status).first
    if !reservation.nil?
	@price = reservation.price
	render "new_order"
    else	
	flash[:notice] = t('not_support_this_type')
	redirect_to "/doctors"
    end	
  end

  def checkout
    @user = current_user
    basic_case = BasicCase.find(params[:basic_case_id])
    doctor = Doctor.find(params[:doctor_id])  	
    basic_case.doctor_id = doctor.id
    basic_case.public = params[:basic_case_public]
    basic_case.process = params[:commit_status]
	
    basic_case.save
    respond_to do |format|
        format.html { redirect_to member_path(@user.name), :success => 'commit successfully .' }
    end
  end

  def checkfree
    @user = current_user
    basic_case = BasicCase.find(params[:basic_case_process])
    basic_case.process = "love"
    doctor = Doctor.find(params[:doctor_id])  	
    basic_case.doctor_id = doctor.id
    basic_case.public = params[:basic_case_public]
    basic_case.save
    respond_to do |format|
        format.html { redirect_to member_path(@user.name), :success => 'commit successfully .' }
    end
  end


  def show
    @user = current_user
    @basic_case = @user.basic_cases.where(:process=>nil,:doctor_id=>nil).last
    if @basic_case.nil?
    	@basic_case = BasicCase.create!(:user_id =>@user.id,:public=>true)
    end
    	body_sign = @basic_case.body_sign
    if body_sign.nil?
      body_sign =   BodySign.create!(:basic_case_id=>@basic_case.id,:swelling=>"",:status_name=>"")
     @basic_case.body_sign = body_sign
     @basic_case.save
    end
    @status_names =body_sign.status_name.split  
  end

  def show_case
    @user = current_user
    @basic_case = BasicCase.find(params[:basic_case_id].to_i)
    body_sign = @basic_case.body_sign
    @status_names =body_sign.status_name.split  
  end

  def show_commit_case
    @user = current_user
    @basic_case = BasicCase.find(params[:basic_case_id].to_i)
    body_sign = @basic_case.body_sign
    @status_names =body_sign.status_name.split  
    @msg = "返回付款页面"
  end

  def show_doctor_case
    @user = current_user
    @basic_case = BasicCase.find(params[:basic_case_id].to_i)
    body_sign = @basic_case.body_sign
    @status_names =body_sign.status_name.split  
    @msg = "返回我的经治医生"
    render :action => 'show_commit_case'
  end

  def edit_case
    @user = current_user
    @basic_case = BasicCase.find(params[:basic_case_id].to_i)
    body_sign = @basic_case.body_sign
    @status_names =body_sign.status_name.split  
  end

  def clonecase
    @user = current_user
    old_basic_case = BasicCase.find(params[:basic_case_id].to_i)
    @basic_case = BasicCase.create!({:main_desc=>old_basic_case.main_desc,:detail_desc=>old_basic_case.detail_desc,:now_desc=>old_basic_case.now_desc,:treat_desc=>old_basic_case.treat_desc,:user_id =>@user.id,:public=>true,:edited=>false})
    old_body_sign = old_basic_case.body_sign
    body_sign = BodySign.create!({:basic_case_id=>@basic_case.id,:swelling=>old_body_sign.swelling,:status_name=>old_body_sign.status_name,:pulse=>old_body_sign.pulse,:high_pressure=>old_body_sign.high_pressure,:low_pressure=>old_body_sign.low_pressure,:temperature=>old_body_sign.temperature})
    @status_names =body_sign.status_name.split  
    render "edit_case"
  end

  def add_sickness
    @user = current_user
    respond_to do |format|
      format.js
    end
  end

  def add_sick_asset
    @basic_case = BasicCase.find(params[:basic_case_id].to_i)
    respond_to do |format|
      format.js
    end
  end

  def add_operation
    @user = current_user
    @operation = @user.operations.where(:edited=>false).last
    if @operation.nil?
    	@operation = Operation.create!(:user_id =>@user.id,:edited=>false)
    end
    respond_to do |format|
      format.js
    end
  end

  def add_sick_hist
    @user = current_user
    respond_to do |format|
      format.js
    end
  end

  def hyper
    @user = current_user
    @hypertension = @user.hypertension
  end

  def diabetes
    @user = current_user
    @diabetes = @user.diabetes
  end

  def hyperlipidemia
    @user = current_user
    @hyperlipidemia = @user.hyperlipidemia
  end

  def explore_doctor
    @user = current_user
  end

  def update_hyperlipidemia
    @user = current_user
    @hyperlipidemia = Hyperlipidemia.find(params[:hyperlipidemia][:id])
    @hyperlipidemia.update_attributes(params[:hyperlipidemia])
    respond_to do |format|
      if @hyperlipidemia.save
        format.html { redirect_to '/showmyhyperlipidemia', :success => '高脂血史更新成功' }
      else
      	flash[:notice] = @hyperlipidemia.errors.full_messages.first
        format.html { render :action => "hyperlipidemia" }
      end
    end
  end

  def update_diabetes
    @user = current_user
    @diabetes = Diabetes.find(params[:diabetes][:id])
    @diabetes.update_attributes(params[:diabetes])
    respond_to do |format|
      if @diabetes.save
        format.html { redirect_to '/showmydiabetes', :success => '糖尿病史更新成功' }
      else
      	flash[:notice] = @diabetes.errors.full_messages.first
        format.html { render :action => "diabetes" }
      end
    end
  end

  def update_hyper
    @user = current_user
    @hypertension = Hypertension.find(params[:hypertension][:id])
    @hypertension.update_attributes(params[:hypertension])
    respond_to do |format|
      if @hypertension.save
        format.html { redirect_to '/showmyhyper', :success => '高血压史更新成功' }
      else
      	flash[:notice] = @hypertension.errors.full_messages.first
        format.html { render :action => "hyper" }
      end
    end
  end

  def update_faq
    main_desc = params[:basic_case][:main_desc]
    detail_desc = params[:basic_case][:detail_desc]
    if main_desc.nil? or main_desc.blank? or detail_desc.nil? or detail_desc.blank?
    	redirect_to "/createmyfaq",:flash => { :success => 'main_desc not null .'}
 	return
    end
    @user = current_user
    @basic_case = BasicCase.find(params[:basic_case][:id])
    @basic_case.update_attributes(params[:basic_case])
    #@basic_case.edited = true
    respond_to do |format|
        @basic_case.save
      	format.js
    end
  end

  def commit_ready
    respond_to do |format|
      	format.js
    end
  end

  def update_bodysign
    @user = current_user
    @body_sign = BodySign.find(params[:body_sign][:id])
    @body_sign.update_attributes(params[:body_sign])
    @body_sign.status_name = ""
    
    status_names = params[:status_sign_ids]    
    if !status_names.nil?
    	status_names.each do |ss|
    		@body_sign.status_name += ss+" "
    	end
    end

    respond_to do |format|
      @body_sign.save
        #format.html { redirect_to member_path(@user.name), :success => 'basiccase was successfully updated.' }
	  @basic_case = @body_sign.basic_case
      	  format.js
    end
  end

  def update
    @user = current_user
    @basic_info = BasicInfo.find(params[:basic_info][:id])
    @basic_info.update_attributes(params[:basic_info])
    @basic_info.edited = true;
    respond_to do |format|
      if @basic_info.save
        format.html { redirect_to '/showmyinfo', :success => '个人信息更新成功' }
      else
      	flash[:notice] = @basic_info.errors.full_messages.first
        format.html { render :action => "edit" }
      end
    end
  end


  def edit_sick
    @user = current_user
    session[:return_to] = request.url
  end
  
  def edit_oper
    @user = current_user
    @operation = @user.operations.where(:edited=>false).last
    if @operation.nil?
    	@operation = Operation.create!(:user_id =>@user.id,:edited=>false)
    end
    @operations = @user.operations.where(:edited=>true)
    session[:return_to] = request.url
  end

  def edit_dicom
    @user = current_user
    session[:return_to] = request.url
  end

  def edit_hist
    @user = current_user
    session[:return_to] = request.url
  end

  def edit_sickness
    @sickness = Sickness.where(:user_id => current_user.id, :position => params[:position]).first
    respond_to do |format|
      format.js
    end
  end

  def edit_operation
    @operation = Operation.where(:user_id => current_user.id, :position => params[:position]).first
    respond_to do |format|
      format.js
    end
  end

  def edit_sick_hist
    @sick_hist = SickHist.where(:user_id => current_user.id, :position => params[:position]).first
    respond_to do |format|
      format.js
    end
  end

  def edit_sick_asset
    @sick_asset = SickAsset.where(:basic_case_id => params[:basic_case_id] , :position => params[:position]).first
    respond_to do |format|
      format.js
    end
  end

  def free_commit
    @basic_case = BasicCase.find(params[:basic_case_id])
    @basic_case.process = "free"
    #@basic_case.edited = true
    @basic_case.save    
    @user = current_user
    respond_to do |format|
    	format.html { redirect_to member_path(@user.name), :success => 'faq was successfully updated.' }
    end
  end

  def edit_sickness
    @sickness = Sickness.where(:user_id => current_user.id, :position => params[:position]).first
    respond_to do |format|
      format.js
    end
  end

  def edit_operation
    @operation = Operation.where(:user_id => current_user.id, :position => params[:position]).first
    respond_to do |format|
      format.js
    end
  end

  def edit_sick_hist
    @sick_hist = SickHist.where(:user_id => current_user.id, :position => params[:position]).first
    respond_to do |format|
      format.js
    end
  end

  def edit_sick_asset
    @sick_asset = SickAsset.where(:basic_case_id => params[:basic_case_id] , :position => params[:position]).first
    respond_to do |format|
      format.js
    end
  end

  def free_commit
    @basic_case = BasicCase.find(params[:basic_case_id])
    @basic_case.process = "free"
    #@basic_case.edited = true
    @basic_case.save    
    @user = current_user
    respond_to do |format|
    	format.html { redirect_to member_path(@user.name), :success => 'faq was successfully updated.' }
    end
  end

  def case_commit
    @basic_case = BasicCase.find(params[:basic_case_id])
    #@basic_case.process = "free"
    #@basic_case.edited = true
    @basic_case.save    
    @user = current_user
    respond_to do |format|
    	format.html { redirect_to "/explore_doctor", :success => 'faq was successfully updated.' }
    end
  end

  def edited_all_case
    @user = current_user
    raise ActiveRecord::RecordNotFound if @user.nil?
    @basic_cases = @user == current_user ? @user.basic_cases.where(:edited=>true) : @user.basic_cases.where(:edited=>true)
    session[:return_to] = request.url
  end

  def change_all_case
    @user = current_user
    raise ActiveRecord::RecordNotFound if @user.nil?
    @basic_cases = @user == current_user ? @user.basic_cases.where(:edited=>false) : @user.basic_cases.where(:edited=>false)
    session[:return_to] = request.url
  end
end
