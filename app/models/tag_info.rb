class TagInfo < ApplicationRecord
  has_and_belongs_to_many :open_street_map_requests

  validates :tag_key, presence: true
  validates :tag_value, presence: true

  def display_name
    "Tag Info ##{id}"
  end

  def self.all_tag_infos
    TagInfoService.new.retrieve_all_tags
  end
end
