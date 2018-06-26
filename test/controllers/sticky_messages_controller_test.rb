require 'test_helper'

class StickyMessagesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @sticky_message = sticky_messages(:one)
  end

  test "should get index" do
    get sticky_messages_url
    assert_response :success
  end

  test "should get new" do
    get new_sticky_message_url
    assert_response :success
  end

  test "should create sticky_message" do
    assert_difference('StickyMessage.count') do
      post sticky_messages_url, params: { sticky_message: { content: @sticky_message.content, draft: @sticky_message.draft, important: @sticky_message.important, published: @sticky_message.published, user: @sticky_message.user } }
    end

    assert_redirected_to sticky_message_url(StickyMessage.last)
  end

  test "should show sticky_message" do
    get sticky_message_url(@sticky_message)
    assert_response :success
  end

  test "should get edit" do
    get edit_sticky_message_url(@sticky_message)
    assert_response :success
  end

  test "should update sticky_message" do
    patch sticky_message_url(@sticky_message), params: { sticky_message: { content: @sticky_message.content, draft: @sticky_message.draft, important: @sticky_message.important, published: @sticky_message.published, user: @sticky_message.user } }
    assert_redirected_to sticky_message_url(@sticky_message)
  end

  test "should destroy sticky_message" do
    assert_difference('StickyMessage.count', -1) do
      delete sticky_message_url(@sticky_message)
    end

    assert_redirected_to sticky_messages_url
  end
end
