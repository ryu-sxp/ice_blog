require 'test_helper'

class AudioFilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @audio_file = audio_files(:one)
  end

  test "should get index" do
    get audio_files_url
    assert_response :success
  end

  test "should get new" do
    get new_audio_file_url
    assert_response :success
  end

  test "should create audio_file" do
    assert_difference('AudioFile.count') do
      post audio_files_url, params: { audio_file: { item: @audio_file.item, name: @audio_file.name, type: @audio_file.type } }
    end

    assert_redirected_to audio_file_url(AudioFile.last)
  end

  test "should show audio_file" do
    get audio_file_url(@audio_file)
    assert_response :success
  end

  test "should get edit" do
    get edit_audio_file_url(@audio_file)
    assert_response :success
  end

  test "should update audio_file" do
    patch audio_file_url(@audio_file), params: { audio_file: { item: @audio_file.item, name: @audio_file.name, type: @audio_file.type } }
    assert_redirected_to audio_file_url(@audio_file)
  end

  test "should destroy audio_file" do
    assert_difference('AudioFile.count', -1) do
      delete audio_file_url(@audio_file)
    end

    assert_redirected_to audio_files_url
  end
end
