class CreatePackages < ActiveRecord::Migration[5.2]
  def change
    create_table :packages do |t|
      t.string :name
      t.string :version
      t.datetime :publication_date
      t.string :title
      t.string :description
      t.timestamps
    end
  end
end
