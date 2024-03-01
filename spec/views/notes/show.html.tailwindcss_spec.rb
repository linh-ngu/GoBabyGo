require 'rails_helper'

RSpec.describe "notes/show", type: :view do
  before(:each) do
    assign(:note, Note.create!(
      content: "Content",
      user_id: 2,
      car_id: 3
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Content/)
    expect(rendered).to match(/2/)
    expect(rendered).to match(/3/)
  end
end
