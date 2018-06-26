require 'test_helper'

class BlogCategoriesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @blog_category = blog_categories(:one)
  end

  test "should get index" do
    get blog_categories_url
    assert_response :success
  end

  test "should get new" do
    get new_blog_category_url
    assert_response :success
  end

  test "should create blog_category" do
    assert_difference('BlogCategory.count') do
      post blog_categories_url, params: { blog_category: { name: @blog_category.name } }
    end

    assert_redirected_to blog_category_url(BlogCategory.last)
  end

  test "should show blog_category" do
    get blog_category_url(@blog_category)
    assert_response :success
  end

  test "should get edit" do
    get edit_blog_category_url(@blog_category)
    assert_response :success
  end

  test "should update blog_category" do
    patch blog_category_url(@blog_category), params: { blog_category: { name: @blog_category.name } }
    assert_redirected_to blog_category_url(@blog_category)
  end

  test "should destroy blog_category" do
    assert_difference('BlogCategory.count', -1) do
      delete blog_category_url(@blog_category)
    end

    assert_redirected_to blog_categories_url
  end
end
