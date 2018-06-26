require 'test_helper'

class MicropostDraftsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @micropost_draft = micropost_drafts(:one)
  end

  test "should get index" do
    get micropost_drafts_url
    assert_response :success
  end

  test "should get new" do
    get new_micropost_draft_url
    assert_response :success
  end

  test "should create micropost_draft" do
    assert_difference('MicropostDraft.count') do
      post micropost_drafts_url, params: { micropost_draft: { content: @micropost_draft.content, name: @micropost_draft.name, published: @micropost_draft.published } }
    end

    assert_redirected_to micropost_draft_url(MicropostDraft.last)
  end

  test "should show micropost_draft" do
    get micropost_draft_url(@micropost_draft)
    assert_response :success
  end

  test "should get edit" do
    get edit_micropost_draft_url(@micropost_draft)
    assert_response :success
  end

  test "should update micropost_draft" do
    patch micropost_draft_url(@micropost_draft), params: { micropost_draft: { content: @micropost_draft.content, name: @micropost_draft.name, published: @micropost_draft.published } }
    assert_redirected_to micropost_draft_url(@micropost_draft)
  end

  test "should destroy micropost_draft" do
    assert_difference('MicropostDraft.count', -1) do
      delete micropost_draft_url(@micropost_draft)
    end

    assert_redirected_to micropost_drafts_url
  end
end
