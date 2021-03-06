class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :micropost

  acts_as_nested_set :scope => [:commentable_id, :commentable_type]
  acts_as_votable
  acts_as_commentable
  acts_as_taggable_on :hashtags
  
  attr_accessible :body
  validates :body, :presence => true, :length => { :maximum => 140 }
  validates :user_id, :presence => true

  def to_param
      "#{id}-#{body.parameterize}"
  end

  def self.search(search)
    if search
      where('body LIKE ?', "%#{search}%")
    else
      scoped
    end
  end
  
  # Helper class method that allows you to build a comment
  # by passing a commentable object, a user_id, and comment text
  # example in readme
  def self.build_from(obj, user_id, comment)
    c = self.new
    c.commentable_id = obj.id 
    c.commentable_type = obj.class.name 
    c.body = comment 
    c.user_id = user_id
    c 
  end
  
  #helper method to check if a comment has children
  def has_children?
    self.children.size > 0 
  end
  
  # Helper class method to lookup all comments assigned
  # to all commentable types for a given user.
  scope :find_comments_by_user, lambda { |user|
    where(:user_id => user.id).order('created_at DESC')
  }

  # Helper class method to look up all comments for 
  # commentable class name and commentable id.
  scope :find_comments_for_commentable, lambda { |commentable_str, commentable_id|
    where(:commentable_type => commentable_str.to_s, :commentable_id => commentable_id).order('created_at DESC')
  }

  # Helper class method to look up a commentable object
  # given the commentable class name and id 
  def self.find_commentable(commentable_str, commentable_id)
    commentable_str.constantize.find(commentable_id)
  end
end
