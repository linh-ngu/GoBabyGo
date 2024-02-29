require 'rails_helper'

RSpec.describe "abouts/edit", type: :view do
  let(:about) {
    About.create!()
  }

  before(:each) do
    assign(:about, about)
  end

  it "renders the edit about form" do
    render

    assert_select "form[action=?][method=?]", about_path(about), "post" do
    end
  end
end
