class MicroblogsController < ApplicationController
  before_filter :authenticate, :except => [:show, :index, :read]
  before_filter :correct_user, :only => [:edit, :update]
  
  def index
    @sort = sort_by
    @microposts = Comment.where(:commentable_type =>'Microblog').search(params[:search]).order(@sort + ' DESC').paginate(:page => params[:page], :per_page => 10)
    @users = User.order('microblogs_count DESC').paginate(:page => params[:page], :per_page => 10)
    @hashtags = Microblog.tag_counts_on(:hashtags, :limit => 10, :order => 'count desc')

    add_crumb 'Microblogs', microblogs_path
    set_meta_tags :title => 'Microblog Index Page',
      :description => 'Micropost micro-blogging twitter client web-app',
      :keywords => 'Micropost micro-blogging twitter client web-app' 

    respond_to do |format|
      format.html
      format.rss {
        @microblogs = Microblog.order('created_at DESC').limit(5)
        render :layout => false
      }
    end
  end
  
  def read
    # need to fix width, then pagination screwups

    @microblogs = Microblog.order('created_at desc').paginate(:page => params[:page], :per_page => 4)

    set_meta_tags :title => 'Microblog Read Page',
      :description => 'Micropost micro-blogging twitter client web-app',
      :keywords => 'Micropost micro-blogging twitter client web-app' 

    respond_to do |format|
      format.html
      format.rss {
        @microblogs = Microblog.order('created_at DESC').limit(5)
        render :layout => false 
      }
    end
  end

  def show
    @sort = sort_by
    @microblog = Microblog.find(params[:id])
    #root_comments returns a relation, how to just get first element
    @microposts = @microblog.root_comments.paginate(:page => params[:page], :per_page => 1)

    add_crumb 'Microblogs', microblogs_path
    add_crumb @microblog.title

    set_meta_tags :title => @microblog.title,
      :description => @microblog.title,
      :keywords => @microblog.keywords
  end
  
  def new
    @microblog = Microblog.new 
    add_crumb('Microblogs', microblogs_path)
  end
  
  def create
    @microblog = current_user.microblogs.build(params[:microblog])
    @microblog.content = BlueCloth.new(@microblog.markdown).to_html

    #need a length 
    @microblog.keywords.tr!('#', '')
    @microblog.keywords.tr!(',', ' ')
    @microblog.keywords = @microblog.keywords.split.map{|s| '#' + s}.join(', ')

    if @microblog.save
      content = @microblog.title + ' ' + microblog_url(@microblog.id) + ' ' + @microblog.keywords  
      @comment = Comment.build_from(@microblog, current_user.id, content) 
      @comment.save

      current_user.tag(@microblog, :with => @microblog.keywords, :on => :hashtags)
      current_user.tag(@comment, :with => @microblog.keywords, :on => :hashtags)

      current_user.microblogs_count += 1
      current_user.microposts_count += 1
      current_user.save

      flash[:notice] = "Successfully created new microblog page."
      redirect_to @microblog
    else
      render :action => 'new'
    end
  end
  
  def edit
    @microblog = Microblog.find(params[:id])
  end
  
  def update
    @microblog = Microblog.find(params[:id])
    params[:microblog][:content] = BlueCloth.new(params[:microblog][:markdown]).to_html
    # this is wrong, change it to only edit certain fields, remove accessibility model
    if @microblog.update_attributes(params[:microblog])
      flash[:notice] = "Successfully updated microblog page."
      redirect_to @microblog
    else
      render :action => 'edit'
    end
  end
end
