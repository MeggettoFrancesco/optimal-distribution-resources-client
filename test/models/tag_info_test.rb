require 'test_helper'
require 'models/_shared_models_test'

class TagInfoTest < ActiveSupport::TestCase
  include SharedModelsTest

  setup do
    @tag_info = build(:tag_info)
  end

  test 'valid tag_info' do
    assert @tag_info.valid?
  end

  test 'invalid without tag_key' do
    invalid_without(@tag_info, :tag_key)
  end

  test 'invalid without tag_value' do
    invalid_without(@tag_info, :tag_value)
  end

  test 'display_name should not be empty' do
    assert_not_empty @tag_info.display_name
  end

  test 'TagInfo.all_tag_infos should contain Array of Hashes' do
    stub_popular_tags_api_request
    tags = TagInfo.all_tag_infos

    assert tags.is_a? Array
    assert tags.first.is_a? Hash
  end

  test 'TagInfo.all_tag_infos should contain highway as key in hash items' do
    stub_popular_tags_api_request
    tags = TagInfo.all_tag_infos

    has_any_highway = tags.any? { |h| h[:key] == 'highway' }
    assert has_any_highway
  end
end
