require 'test_helper'

class PendingTootsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @pending_toot = pending_toots(:one)
  end

  test "should get index" do
    get pending_toots_url
    assert_response :success
  end

  test "should get new" do
    get new_pending_toot_url
    assert_response :success
  end

  test "should create pending_toot" do
    assert_difference('PendingToot.count') do
      post pending_toots_url, params: { pending_toot: { media_id: @pending_toot.media_id, message: @pending_toot.message, requires_file: @pending_toot.requires_file, source_id: @pending_toot.source_id, source_model: @pending_toot.source_model } }
    end

    assert_redirected_to pending_toot_url(PendingToot.last)
  end

  test "should show pending_toot" do
    get pending_toot_url(@pending_toot)
    assert_response :success
  end

  test "should get edit" do
    get edit_pending_toot_url(@pending_toot)
    assert_response :success
  end

  test "should update pending_toot" do
    patch pending_toot_url(@pending_toot), params: { pending_toot: { media_id: @pending_toot.media_id, message: @pending_toot.message, requires_file: @pending_toot.requires_file, source_id: @pending_toot.source_id, source_model: @pending_toot.source_model } }
    assert_redirected_to pending_toot_url(@pending_toot)
  end

  test "should destroy pending_toot" do
    assert_difference('PendingToot.count', -1) do
      delete pending_toot_url(@pending_toot)
    end

    assert_redirected_to pending_toots_url
  end
end
