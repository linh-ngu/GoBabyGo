require 'rails_helper'

RSpec.describe "contacts/edit", type: :view do
  let(:contact) {
    Contact.create!()
  }

  before(:each) do
    assign(:contact, contact)
  end

  it "renders the edit contact form" do
    render

    assert_select "form[action=?][method=?]", contact_path(contact), "post" do
    end
  end
end
