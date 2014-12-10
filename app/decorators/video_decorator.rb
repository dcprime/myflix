class VideoDecorator < Draper::Decorator
  delegate_all
  
  def rating
    if reviews.average(:rating)
      "#{reviews.average(:rating).round(1)}/5.0"
    else
      "N/A"
    end
  end

end
