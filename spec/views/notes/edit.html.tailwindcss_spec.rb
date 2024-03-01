require 'rails_helper'

RSpec.describe "notes/edit", type: :view do
  let(:note) {
    Note.create!(
      content: "MyString",
      user_id: 1,
      car_id: 1
    )
  }

  before(:each) do
    assign(:note, note)
  end

  it "renders the edit note form" do
    render

    assert_select "form[action=?][method=?]", note_path(note), "post" do

      assert_select "input[name=?]", "note[content]"

      assert_select "input[name=?]", "note[user_id]"

      assert_select "input[name=?]", "note[car_id]"
    end
  end
end
