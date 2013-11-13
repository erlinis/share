module ApplicationHelper
  def avatar_url(user)
    if true
      gravatar_id = Digest::MD5::hexdigest(user.email).downcase
      "http://gravatar.com/avatar/#{gravatar_id}.png"
    else
      user.profile_picture.to_s
    end
  end
end
