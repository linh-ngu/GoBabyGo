require 'rails_helper'

RSpec.describe "application_notes/show", type: :view do
  before(:each) do
    assign(:application_note, ApplicationNote.create!(
      content: "Content"
    ))
  end

  it "renders attributes in <p>" do
    render
    expect(rendered).to match(/Content/)
  end
end
