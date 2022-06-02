require "test_helper"

class SiteLayoutTest < ActionDispatch::IntegrationTest
# use command to run only integration test: $ rails test:integration
  test "layout links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2 # (two links/logo & nav menu element)
    assert_select "a[href=?]", help_path           # Here Rails automatically
    assert_select "a[href=?]", about_path          # inserts the value of
    assert_select "a[href=?]", contact_path        # 'about_path' in place of the '?'
    assert_select "a[href=?]", signup_path
  end
end
