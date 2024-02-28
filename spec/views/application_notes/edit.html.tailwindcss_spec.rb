require 'rails_helper'

RSpec.describe "application_notes/edit", type: :view do
  let(:application_note) {
    ApplicationNote.create!(
      content: "MyString"
    )
  }

  before(:each) do
    assign(:application_note, application_note)
  end

  it "renders the edit application_note form" do
    render

    assert_select "form[action=?][method=?]", application_note_path(application_note), "post" do

      assert_select "input[name=?]", "application_note[content]"
    end
  end
end
