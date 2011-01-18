class SitemapController < ApplicationController
  def index
    @microblogs << Microblog.order('updated_at DESC').limit(10000)
    @microposts << Comment.order('updated_at DESC').limit(39000) 

    respond_to do |format|
      format.xml { render :layout => false }
    end
  end
end
