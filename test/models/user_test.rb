require 'test_helper'

class UserTest < ActiveSupport::TestCase
	subject { users(:one) }

	should validate_presence_of(:name)

	should validate_presence_of(:email)
	should validate_uniqueness_of(:email).case_insensitive

	should_not allow_value("BAD EMAIL").for(:email)
	should_not allow_value("@").for(:email)
	should_not allow_value("  bad@example.com").for(:email)

	should have_secure_password

	should have_many(:problems)
	should have_many(:notes)

	test "should set a key before validation" do
		user = User.new
		user.valid?
		assert_not_nil user.activation_key, "should have a key before validation"
	end
end
