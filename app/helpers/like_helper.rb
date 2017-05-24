module LikeHelper
  def likeable_icon(likeable)
    likeable.likes_count == 0 ? "fa-heart-o" : "fa-heart"
  end
end