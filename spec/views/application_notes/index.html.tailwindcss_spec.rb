require 'rails_helper'

RSpec.describe "application_notes/index", type: :view do
  before(:each) do
    assign(:application_notes, [
      ApplicationNote.create!(
        content: "Content"
      ),
      ApplicationNote.create!(
        content: "Content"
      )
    ])
  end

  it "renders a list of application_notes" do
    render
    cell_selector = Rails::VERSION::STRING >= '7' ? 'div>p' : 'tr>td'
    assert_select cell_selector, text: Regexp.new("Content".to_s), count: 2
  end
end
