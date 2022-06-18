require "test_helper"

class UsersEditTest < ActionDispatch::IntegrationTest
   
  def setup
    @user = users(:michael)
  end

  test "unsuccessful edit" do
    log_in_as(@user) # test_helper.rb
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: "",
                                              email: "invalid@inv",
                                              password: "foo",
                                              password_confirmation: "foo"} }
    assert_template 'users/edit'
  end
  
  test "successful edit with redirection to edit_user_url" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
