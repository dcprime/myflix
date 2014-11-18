class Video < ActiveRecord::Base
  
  has_many :video_categories
  has_many :categories, through: :video_categories
  has_many :reviews
  
  validates_presence_of :title, :description
  validates_uniqueness_of :title
  
  mount_uploader :small_cover, SmallCoverUploader
  mount_uploader :large_cover, LargeCoverUploader
  
  def self.search_by_title(search_term)
    return [] if search_term.blank?
    where("title like ?", "%#{search_term}%").order("title")
  end
  
end