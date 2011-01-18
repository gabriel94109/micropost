class CommentsController < ApplicationController
  before_filter :authenticate, :only => [ :create, :destroy ]

  def index
    # how do i only get comments which are a certain commentable_type
    
    @sort = sort_by
    @microposts = Comment.search(params[:search]).order(@sort + ' DESC').paginate(:page => params[:page], :per_page => 10)
    @mp_new = Comment.new
    @users = User.order('microposts_count DESC').limit(5).paginate(:page => params[:page], :per_page => 5)
    @hashtags = Comment.tag_counts_on(:hashtags, :limit => 10, :order => 'count desc')

    set_meta_tags :title => 'Search All Microposts',
      :description => 'Micropost is a twitter-client website with voting, commments, blogs, photos, videos, news, email, sms',
      :keywords => 'Micropost, Microblog, Vote, Comment, Photos, Videos, Blog, News, Email, SMS'
    respond_to do |format|
      format.html
      format.rss {render :layout => false }
    end
  end

  def reply
    @micropost = Comment.find(params[:id])
    @reply = Comment.build_from(@micropost, current_user.id, params[:comment][:body])
    @reply.save

    keywords = @reply.body.split.grep(/^#\w+$/)
    current_user.tag(@reply, :with => keywords, :on => :hashtags)

    @micropost.replies = @micropost.root_comments.count
    @micropost.save

    current_user.microposts_count += 1
    current_user.save

    redirect_to comment_path
  end

  def create
    @micropost = current_user.comments.build(params[:comment]) #why did i put build
    if @micropost.save
      keywords = @micropost.body.split.grep(/^#\w+$/)
      current_user.tag(@micropost, :with => keywords, :on => :hashtags)

      current_user.microposts_count += 1
      current_user.save
      flash[:notice] = 'Micropost created!'
      redirect_to comments_path
    else
      render 'site_pages/home'
    end
  end

  def show
    @sort = sort_by
    @reply = Comment.new
    @micropost = Comment.find(params[:id])
    @microposts = @micropost.root_comments.order(@sort + ' DESC').paginate(:page => params[:page], :per_page => 10)

    #add breadcrumbs for comments
    m = @micropost
    m_array = Array.new
    while (m.commentable_id > 0 && m.commentable_type == 'Comment')
      parent = Comment.find(m.commentable_id)
      m_array << parent
      m = parent
    end
    m_array.reverse.each do |m|
#      if m.commentable_type == 'Comment'
        add_crumb m.body[0..49], m.to_param
#      else
#        add_crumb m.title[0..49], m.to_param
#      end
    end 
    add_crumb @micropost.body[0..49]
    
    set_meta_tags :title => @micropost.body,
      :description => @micropost.body,
      :keywords => @micropost.body

    #need rss link in sidebar
    respond_to do |format|
      format.html
      format.rss {render :layout => false }
    end
  end

  def vote
    unless signed_in?
      redirect_to signin_path
    else
      @micropost = Comment.find(params[:id])
      @micropost.vote :voter => current_user, :vote => params[:vote]
      @micropost.vote_score = @micropost.upvotes - @micropost.downvotes
      @micropost.save
      redirect_to comment_path
    end
  end
end
