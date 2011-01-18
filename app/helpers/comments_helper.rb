module CommentsHelper

  def auto_link_hashtag(string)
    string = auto_link(string)

    # what if there is a stray hashtag in url 
    string.gsub(/#(\w+)/, link_to('#\1', request.protocol + request.host_with_port + '/microposts?utf8=✓&search=%23\1&sort=&commit=Search'))
  end

end
