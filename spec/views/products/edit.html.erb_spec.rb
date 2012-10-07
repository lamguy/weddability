require 'spec_helper'

describe "products/edit.html.erb" do
  before(:each) do
    @product = assign(:product, stub_model(Product,
      :new_record? => false,
      :name => "MyString",
      :desc => "MyText",
      :plan_id => "MyString",
      :price => 1.5
    ))
  end

  it "renders the edit product form" do
    render

    # Run the generator again with the --webrat-matchers flag if you want to use webrat matchers
    assert_select "form", :action => product_path(@product), :method => "post" do
      assert_select "input#product_name", :name => "product[name]"
      assert_select "textarea#product_desc", :name => "product[desc]"
      assert_select "input#product_plan_id", :name => "product[plan_id]"
      assert_select "input#product_price", :name => "product[price]"
    end
  end
end
