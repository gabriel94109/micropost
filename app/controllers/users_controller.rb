class UsersController < ApplicationController
  before_filter :authenticate, :only => [:edit, :update]
  before_filter :correct_user, :only => [:edit, :update]
  before_filter :admin_user,   :only => [:destroy]

  def index
    @sort = sort_by
    @users = User.search(params[:search]).paginate(:page => params[:page], :per_page => 10)
    @active_users = User.order('microposts_count DESC').paginate(:page => params[:page], :per_page => 10)
  end

  def show
    if(params[:name])
      @user = User.find_by_name(params[:name])
    else
      @user = User.find(params[:id])
    end
    @sort = sort_by
    @microposts = @user.comments.order(@sort + ' DESC').paginate(:page => params[:page], :per_page => 5)
    # got a 503 service unavailabe error, ?
    #@twitter_user = client.user(@user.name)
    set_meta_tags :title => @user.name,
      :description => "User profile page for #{@user.name}",
      :keywords => "twitter-client microposting microblogging webapp texts photos"

    respond_to do |format|
      format.html
      format.rss {render :layout => false }
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(params[:user])
      flash[:notice] = "Profile updated."
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:notice] = "User destroyed."
    redirect_to users_path
  end
end
