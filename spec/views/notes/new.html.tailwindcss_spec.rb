require 'rails_helper'

RSpec.describe "notes/new", type: :view do
  before(:each) do
    assign(:note, Note.new(
      content: "MyString",
      user_id: 1,
      car_id: 1
    ))
  end

  it "renders new note form" do
    render

    assert_select "form[action=?][method=?]", notes_path, "post" do

      assert_select "input[name=?]", "note[content]"

      assert_select "input[name=?]", "note[user_id]"

      assert_select "input[name=?]", "note[car_id]"
    end
  end
end
