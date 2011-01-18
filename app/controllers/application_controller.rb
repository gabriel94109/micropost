class ApplicationController < ActionController::Base
  include SessionsHelper
  protect_from_forgery
  helper_method :filter_by, :sort_by, :client  

  add_crumb 'Home', '/'

  private

# need to re-read stackoverflow.com posts about coding style 
  # blank nil empty 

  def sort_by
    unless params[:sort].blank?
      params[:sort]  if params[:sort] == 'created_at' || 'vote_score' || 'replies'
    else
      'created_at'
    end
  end
  
  def client
    Twitter.configure do |config|
      config.consumer_key = 'mOkbQlNDpniwKTvx4WuaqA'
      config.consumer_secret = 'tirig1eg8BJVjFY87O5PyBriYMpp6pEkf5iXC5Q2E'
      config.oauth_token = session['access_token']
      config.oauth_token_secret = session['access_secret']
    end
    @client ||= Twitter::Client.new
  end
end

