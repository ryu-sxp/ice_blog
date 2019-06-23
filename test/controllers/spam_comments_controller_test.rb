require 'test_helper'

class SpamCommentsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @spam_comment = spam_comments(:one)
  end

  test "should get index" do
    get spam_comments_url
    assert_response :success
  end

  test "should get new" do
    get new_spam_comment_url
    assert_response :success
  end

  test "should create spam_comment" do
    assert_difference('SpamComment.count') do
      post spam_comments_url, params: { spam_comment: { blog_spam_blocker: @spam_comment.blog_spam_blocker, blog_spam_reason: @spam_comment.blog_spam_reason, blog_spam_result: @spam_comment.blog_spam_result, blog_spam_version: @spam_comment.blog_spam_version, content: @spam_comment.content, email: @spam_comment.email, ip: @spam_comment.ip, name: @spam_comment.name, useragent: @spam_comment.useragent, website: @spam_comment.website } }
    end

    assert_redirected_to spam_comment_url(SpamComment.last)
  end

  test "should show spam_comment" do
    get spam_comment_url(@spam_comment)
    assert_response :success
  end

  test "should get edit" do
    get edit_spam_comment_url(@spam_comment)
    assert_response :success
  end

  test "should update spam_comment" do
    patch spam_comment_url(@spam_comment), params: { spam_comment: { blog_spam_blocker: @spam_comment.blog_spam_blocker, blog_spam_reason: @spam_comment.blog_spam_reason, blog_spam_result: @spam_comment.blog_spam_result, blog_spam_version: @spam_comment.blog_spam_version, content: @spam_comment.content, email: @spam_comment.email, ip: @spam_comment.ip, name: @spam_comment.name, useragent: @spam_comment.useragent, website: @spam_comment.website } }
    assert_redirected_to spam_comment_url(@spam_comment)
  end

  test "should destroy spam_comment" do
    assert_difference('SpamComment.count', -1) do
      delete spam_comment_url(@spam_comment)
    end

    assert_redirected_to spam_comments_url
  end
end
