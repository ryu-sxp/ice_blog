require 'test_helper'

class BlogPostDraftsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @blog_post_draft = blog_post_drafts(:one)
  end

  test "should get index" do
    get blog_post_drafts_url
    assert_response :success
  end

  test "should get new" do
    get new_blog_post_draft_url
    assert_response :success
  end

  test "should create blog_post_draft" do
    assert_difference('BlogPostDraft.count') do
      post blog_post_drafts_url, params: { blog_post_draft: { content: @blog_post_draft.content, name: @blog_post_draft.name, published: @blog_post_draft.published } }
    end

    assert_redirected_to blog_post_draft_url(BlogPostDraft.last)
  end

  test "should show blog_post_draft" do
    get blog_post_draft_url(@blog_post_draft)
    assert_response :success
  end

  test "should get edit" do
    get edit_blog_post_draft_url(@blog_post_draft)
    assert_response :success
  end

  test "should update blog_post_draft" do
    patch blog_post_draft_url(@blog_post_draft), params: { blog_post_draft: { content: @blog_post_draft.content, name: @blog_post_draft.name, published: @blog_post_draft.published } }
    assert_redirected_to blog_post_draft_url(@blog_post_draft)
  end

  test "should destroy blog_post_draft" do
    assert_difference('BlogPostDraft.count', -1) do
      delete blog_post_draft_url(@blog_post_draft)
    end

    assert_redirected_to blog_post_drafts_url
  end
end
