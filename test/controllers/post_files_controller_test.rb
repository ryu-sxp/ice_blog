require 'test_helper'

class PostFilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @post_file = post_files(:one)
  end

  test "should get index" do
    get post_files_url
    assert_response :success
  end

  test "should get new" do
    get new_post_file_url
    assert_response :success
  end

  test "should create post_file" do
    assert_difference('PostFile.count') do
      post post_files_url, params: { post_file: { image_dimensions: @post_file.image_dimensions, item: @post_file.item, name: @post_file.name, type: @post_file.type } }
    end

    assert_redirected_to post_file_url(PostFile.last)
  end

  test "should show post_file" do
    get post_file_url(@post_file)
    assert_response :success
  end

  test "should get edit" do
    get edit_post_file_url(@post_file)
    assert_response :success
  end

  test "should update post_file" do
    patch post_file_url(@post_file), params: { post_file: { image_dimensions: @post_file.image_dimensions, item: @post_file.item, name: @post_file.name, type: @post_file.type } }
    assert_redirected_to post_file_url(@post_file)
  end

  test "should destroy post_file" do
    assert_difference('PostFile.count', -1) do
      delete post_file_url(@post_file)
    end

    assert_redirected_to post_files_url
  end
end
