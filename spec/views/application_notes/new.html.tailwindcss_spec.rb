require 'rails_helper'

RSpec.describe "application_notes/new", type: :view do
  before(:each) do
    assign(:application_note, ApplicationNote.new(
      content: "MyString"
    ))
  end

  it "renders new application_note form" do
    render

    assert_select "form[action=?][method=?]", application_notes_path, "post" do

      assert_select "input[name=?]", "application_note[content]"
    end
  end
end
