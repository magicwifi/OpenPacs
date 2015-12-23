# encoding:utf-8
class User < ActiveRecord::Base
  has_many :activities
  has_many :comments
  has_many :basic_cases
  has_many :posts
  has_one  :basic_info
  has_one  :hypertension
  has_one  :hyperlipidemia
  has_one  :diabetes
  has_many :courses
  has_many :dicoms
  has_many :sicknesses, -> { order :position }, :dependent => :destroy
  has_many :operations, -> { order :position }, :dependent => :destroy
  has_many :sick_cases
  has_many :sick_hists
  has_many :messages
  has_many :orders
  has_many :notifications, :dependent => :destroy
  has_many :watchings, :dependent => :destroy
  has_many :watched_courses, :through => :watchings, :source => :course

  attr_accessible :name, :email, :avatar, :phonenum, :password, :password_confirmation

  has_many :follower_relationships, :class_name => "Relationship",
           :foreign_key => "followed_user_id", :dependent => :destroy

  has_many :followers, :through => :follower_relationships

  has_many :followed_relationships, :class_name => "Relationship",
           :foreign_key => "follower_id", :dependent => :destroy

  has_many :followed_users, :through => :followed_relationships

  has_many :collaboratings, :dependent => :destroy
  has_many :collaborated_courses, :through => :collaboratings, :source => :course

  mount_uploader :avatar, AvatarUploader

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  BLACK_LIST = %w(write_blog create_login_seesion account blog explore signup login about)

  validates :name,  presence: true, uniqueness: { case_sensitive: false}, 
                    exclusion: { in: BLACK_LIST, message: I18n.t("is_reserved_word") }, 
                    format: { without: /(\-| |\.|\/|\\)/, message: "不能包含横线, 斜线, 句点或空格" }
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false, message: "已经注册了一个用户，请重新选择" },
                    format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }
  validates :phonenum, presence: true, 
                    uniqueness: { case_sensitive: false, message: "已经注册了一个用户，请重新选择" },
                    format: { with: /\d{11}/  }
  has_secure_password

  before_create { generate_token(:token) }

  after_update :reprocess_avatar, :if => :cropping?

  # this method will be called during standard assignment in your controller
  # (like `update_attributes`)
  def image_data=(data)
    regex = /data:(.*);(.*),/
    realdata = regex.match(data).post_match

    # decode data and create stream on them
    io = CarrierStringIO.new(Base64.decode64(realdata))

    # this will do the thing (avatar is mounted carrierwave uploader)
    self.avatar = io
  end

  def reprocess_avatar
    avatar.recreate_versions!
  end

  def cropping?
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?
  end

  def paid_courses
    courses = []
    for order in self.orders
      courses.push order.course if order.trade_status == "TRADE_FINISHED" && order.course.present?
      # some courses maybe deleted
    end
    courses.uniq
  end

  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!
    UserMailer.password_reset(self).deliver
  end

  def has_avatar?
    self.read_attribute(:avatar).present?
  end

  def use_avatar?
    has_avatar? && !use_gravatar?
  end

  def gravatar_url
    gravatar_id = Digest::MD5.hexdigest(self.email.downcase)
    "http://gravatar.com/avatar/#{gravatar_id}.png?s=512&d=retro"
  end

  def final_avatar_url
    self.use_avatar? ? self.avatar_url : self.gravatar_url
  end

  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end

  def follow!(user)
    self.followed_relationships.create!(followed_user_id: user.id)
  end

  def unfollow!(user)
    self.followed_relationships.find_by_followed_user_id(user.id).delete
  end

  def following?(user)
    self.followed_relationships.find_by_followed_user_id(user.id)
  end

  def follower_count
    @follower_count ||= self.follower_relationships.count
  end

  def followed_user_count
    @followed_user_count ||= self.followed_relationships.count
  end


  def self.show_basic_info(params)	
    user = User.find_by_id(params[:user_id])
    basic_case = BasicCase.find_by_id(params[:basic_case_id])
    if user.nil? or basic_case.nil?
        {:check=>false, :code=>400,:msg=>"Not Find User",}
    else
	basic_info = user.basic_info
	if !basic_info.edited or !basic_case.public 
		{:check=>false, :code=>400,:msg=>"Not Open",}
	else
		hyperlipidemia = user.hyperlipidemia
		diabetes = user.diabetes
		hypertension = user.hypertension
		operations = user.operations
		sicknesses = user.sicknesses				
		sick_hists = user.sick_hists			
		{:check=>true, :code=>200,:basic_info => basic_info,  :hyperlipidemia=>hyperlipidemia, :diabetes=>diabetes, :hypertension=>hypertension,  :operation=>operations, :sicknesses=>sicknesses,:sick_hists=> sick_hists}
	end	

    end

  end
end
