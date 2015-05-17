class CreateGroupedRoutes < ActiveRecord::Migration
  def change
    create_table :grouped_routes do |t|
      t.references :group, index: true
      t.text :route

      t.timestamps
    end
  end
end
