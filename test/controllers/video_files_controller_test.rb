require 'test_helper'

class VideoFilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @video_file = video_files(:one)
  end

  test "should get index" do
    get video_files_url
    assert_response :success
  end

  test "should get new" do
    get new_video_file_url
    assert_response :success
  end

  test "should create video_file" do
    assert_difference('VideoFile.count') do
      post video_files_url, params: { video_file: { item: @video_file.item, name: @video_file.name, type: @video_file.type } }
    end

    assert_redirected_to video_file_url(VideoFile.last)
  end

  test "should show video_file" do
    get video_file_url(@video_file)
    assert_response :success
  end

  test "should get edit" do
    get edit_video_file_url(@video_file)
    assert_response :success
  end

  test "should update video_file" do
    patch video_file_url(@video_file), params: { video_file: { item: @video_file.item, name: @video_file.name, type: @video_file.type } }
    assert_redirected_to video_file_url(@video_file)
  end

  test "should destroy video_file" do
    assert_difference('VideoFile.count', -1) do
      delete video_file_url(@video_file)
    end

    assert_redirected_to video_files_url
  end
end
