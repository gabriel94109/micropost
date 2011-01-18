class User < ActiveRecord::Base
  has_many :comments
  has_many :microblogs
  acts_as_voter
  acts_as_tagger

  def self.create_with_omniauth(auth)  
    create! do |user|  
      user.provider = auth["provider"]  
      user.uid = auth["uid"]  
      # should i create this as a seperate profile object
      user.birthname = auth["user_info"]["name"]  
      user.location = auth["user_info"]["location"]  
      user.website = auth["user_info"]["urls"]["Website"]  
      user.name = auth["user_info"]["nickname"]  
      user.bio = auth["user_info"]["description"]  
      user.image = auth["user_info"]["image"]  

      # also this could be a stats object
      #user.microposts_count
      #user.microblogs_count
    end  
  end 

  def update_user_info(auth)
      self.birthname = auth["user_info"]["name"]  
      self.location = auth["user_info"]["location"]  
      self.website = auth["user_info"]["urls"]["Website"]  
      self.name = auth["user_info"]["nickname"]  
      self.bio = auth["user_info"]["description"]  
      self.image = auth["user_info"]["image"]  
      self.save
  end

  def self.search(search)
    if search
      find(:all, :conditions => ['name LIKE ?', "%#{search}%"])
    else
      find(:all)
    end
  end
end
