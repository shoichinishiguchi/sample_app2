require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest

  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @acti = User.create(name: "acti User", email: "acti@example.com", password: "foobar", password_confirmation: "foobar", activated: true)
    @non_acti = User.create(name: "non_acti User", email: "nonacti@example.com", password: "foobar", password_confirmation: "foobar", activated: false, activated_at: nil)
  end


  test "index as admin including pagination and delete links" do
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
  end

  test "index as non_admin" do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end

  test "index don't include non_activated user" do
    log_in_as(@admin)
    max_page = User.all.count/30 + 1
    (1..max_page).each do |page|
      get users_path, params: {page:page}
      assert_select 'a[href=?]', user_path(@non_acti), count: 0
    end
  end

end
