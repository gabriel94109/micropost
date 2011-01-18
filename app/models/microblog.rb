class Microblog < ActiveRecord::Base
  belongs_to :user
  acts_as_commentable
  acts_as_taggable_on :hashtags

  attr_accessible :title, :keywords, :content, :markdown
  validates :title, :presence => true, :length => { :maximum => 60 }
  validates :keywords, :length => { :maximum => 30 }

  def to_param
      "#{id}-#{title.parameterize}"
  end
end
