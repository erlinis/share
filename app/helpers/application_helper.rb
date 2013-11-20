module ApplicationHelper
  def avatar_url(user)
    if user.profile_picture.present?
      user.profile_picture.thumb.to_s
    else
      gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
      "http://gravatar.com/avatar/#{gravatar_id}.png?s=50&d=mm"
    end
  end
end
