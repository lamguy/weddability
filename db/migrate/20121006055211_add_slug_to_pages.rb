class AddSlugToPages < ActiveRecord::Migration
  def change
    add_column :pages, :slug, :string, :after => :name
  end
end
