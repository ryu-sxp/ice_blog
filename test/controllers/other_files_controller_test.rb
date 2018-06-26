require 'test_helper'

class OtherFilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @other_file = other_files(:one)
  end

  test "should get index" do
    get other_files_url
    assert_response :success
  end

  test "should get new" do
    get new_other_file_url
    assert_response :success
  end

  test "should create other_file" do
    assert_difference('OtherFile.count') do
      post other_files_url, params: { other_file: { item: @other_file.item, name: @other_file.name } }
    end

    assert_redirected_to other_file_url(OtherFile.last)
  end

  test "should show other_file" do
    get other_file_url(@other_file)
    assert_response :success
  end

  test "should get edit" do
    get edit_other_file_url(@other_file)
    assert_response :success
  end

  test "should update other_file" do
    patch other_file_url(@other_file), params: { other_file: { item: @other_file.item, name: @other_file.name } }
    assert_redirected_to other_file_url(@other_file)
  end

  test "should destroy other_file" do
    assert_difference('OtherFile.count', -1) do
      delete other_file_url(@other_file)
    end

    assert_redirected_to other_files_url
  end
end
