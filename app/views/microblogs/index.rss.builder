xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Micropost / Recent Microblog Posts"
    xml.description "Microposts / Recent Microblog Posts"
    xml.link request.protocol + request.host_with_port + url_for(:controller => 'microblogs', :action => 'index')

    for post in @microblogs
      xml.item do
        xml.title post.content
        xml.link(request.protocol + request.host_with_port + 
                 url_for(:controller => 'microblogs', :action => 'show', :id => post.to_param))
        xml.description post.content
        xml.guid(request.protocol + request.host_with_port + 
                 url_for(:controller => 'microblogs', :action => 'show', :id => post.to_param))
        xml.pubDate post.updated_at.to_s(:rfc822)
      end
    end
  end
end
