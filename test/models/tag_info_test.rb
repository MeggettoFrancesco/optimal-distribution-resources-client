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

  # TODO : test for TagInfo.all_tag_infos
end
