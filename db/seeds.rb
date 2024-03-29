# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
return unless Rails.env.development?
require 'factory_bot_rails'

puts 'Creating admin'
FactoryBot.create(:admin_user, email: 'admin@example.com')

puts 'Creating all Tag Infos from https://taginfo.openstreetmap.org/api/4/tags/popular'
TagInfo.all_tag_infos.each do |tag|
  FactoryBot.create(:tag_info, tag_key: tag[:key], tag_value: tag[:value])
end
