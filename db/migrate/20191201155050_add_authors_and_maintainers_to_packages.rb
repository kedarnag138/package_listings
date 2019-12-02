class AddAuthorsAndMaintainersToPackages < ActiveRecord::Migration[5.2]
  def change
    add_column :packages, :authors, :jsonb, default: {}
    add_column :packages, :maintainers, :jsonb, default: {}
  end
end