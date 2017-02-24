require 'test_helper'

class ContactTest < ActiveSupport::TestCase
  test "should not save contact without name, e-mail, age, state and role" do
    contact = Contact.new

    assert_not contact.save
  end

  test "should not save contact without e-mail, age, state and role" do
    contact = Contact.new
    contact.name = "Full Name"

    assert_not contact.save
  end

  test "should not save contact without age, state and role" do
    contact = Contact.new
    contact.name = "Full Name"
    contact.email = "email@domain.subdomain"

    assert_not contact.save
  end

  test "should not save contact without state and role" do
    contact = Contact.new
    contact.name = "Full Name"
    contact.email = "email@domain.subdomain"
    contact.age = 50

    assert_not contact.save
  end

  test "should not save contact without role" do
    contact = Contact.new
    contact.name = "Full Name"
    contact.email = "email@domain.subdomain"
    contact.age = 50
    contact.state = "AC"

    assert_not contact.save
  end

  test "should not save contact with empty name" do
    contact = Contact.new
    contact.name = ""
    contact.email = "email@domain.subdomain"
    contact.age = 50
    contact.state = "AC"
    contact.role = "Role Name"

    assert_not contact.save
  end

  test "should not save contact with blank name" do
    contact = Contact.new
    contact.name = " "
    contact.email = "email@domain.subdomain"
    contact.age = 50
    contact.state = "AC"
    contact.role = "Role Name"

    assert_not contact.save
  end

  test "should not save contact with invalid e-mail" do
    contact = Contact.new
    contact.name = "Full Name"
    contact.email = "@domain.subdomain"
    contact.age = 50
    contact.state = "AC"
    contact.role = "Role Name"

    assert_not contact.save
  end

  test "should not save contact with non-unique e-mail" do
    contact_1 = Contact.new
    contact_1.name = "Full Name"
    contact_1.email = "email@domain.subdomain"
    contact_1.age = 50
    contact_1.state = "AC"
    contact_1.role = "Role Name"

    contact_1.save

    contact_2 = Contact.new
    contact_2.name = contact_1.name
    contact_2.email = contact_1.email
    contact_2.age = contact_1.age
    contact_2.state = contact_1.state
    contact_2.role = contact_1.role

    assert_not contact_2.save
  end

  test "should not save contact with non-numeric age" do
    contact = Contact.new
    contact.name = "Full Name"
    contact.email = "email@domain.subdomain"
    contact.age = ""
    contact.state = "AC"
    contact.role = "Role Name"

    assert_not contact.save
  end

  test "should not save contact with zero age" do
    contact = Contact.new
    contact.name = "Full Name"
    contact.email = "email@domain.subdomain"
    contact.age = 0
    contact.state = "AC"
    contact.role = "Role Name"

    assert_not contact.save
  end

  test "should not save contact with non-positive age" do
    contact = Contact.new
    contact.name = "Full Name"
    contact.email = "email@domain.subdomain"
    contact.age = -1
    contact.state = "AC"
    contact.role = "Role Name"

    assert_not contact.save
  end

  test "should not save contact with too high age" do
    contact = Contact.new
    contact.name = "Full Name"
    contact.email = "email@domain.subdomain"
    contact.age = 151
    contact.state = "AC"
    contact.role = "Role Name"

    assert_not contact.save
  end

  test "should not save contact with empty state" do
    contact = Contact.new
    contact.name = "Full Name"
    contact.email = "email@domain.subdomain"
    contact.age = 50
    contact.state = ""
    contact.role = "Role Name"

    assert_not contact.save
  end

  test "should not save contact with blank state" do
    contact = Contact.new
    contact.name = "Full Name"
    contact.email = "email@domain.subdomain"
    contact.age = 50
    contact.state = " "
    contact.role = "Role Name"

    assert_not contact.save
  end

  test "should not save contact with empty role" do
    contact = Contact.new
    contact.name = "Full Name"
    contact.email = "email@domain.subdomain"
    contact.age = 50
    contact.state = "AC"
    contact.role = ""

    assert_not contact.save
  end

  test "should not save contact with blank role" do
    contact = Contact.new
    contact.name = "Full Name"
    contact.email = "email@domain.subdomain"
    contact.age = 50
    contact.state = "AC"
    contact.role = " "

    assert_not contact.save
  end
end
