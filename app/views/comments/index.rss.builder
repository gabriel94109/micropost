xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Micropost / Recent Posts"
    xml.description "Microposts / Recent Posts"
    xml.link request.protocol + request.host_with_port + url_for(:controller => 'comments', :action => 'index')

    for post in @microposts
      xml.item do
        xml.title post.body
        xml.link(request.protocol + request.host_with_port + 
                 url_for(:controller => 'comments', :action => 'show', :id => post.to_param))
        xml.description post.body
        xml.guid(request.protocol + request.host_with_port + 
                 url_for(:controller => 'comments', :action => 'show', :id => post.to_param))
        xml.pubDate post.updated_at.to_s(:rfc822)
      end
    end
  end
end
