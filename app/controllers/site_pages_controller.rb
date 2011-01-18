class SitePagesController < ApplicationController
  def home
    if signed_in?
      redirect_to comments_path
    end
      set_meta_tags :title => 'Home',
      :description => 'Micropost is a twitter-client website with voting, commments, blogs, photos, videos, news, email, sms',
      :keywords => 'Micropost, Microblog, Vote, Comment, Photos, Videos, Blog, News, Email, SMS'
  end

  def contact
  end

  def about
  end

  def help
  end
end
