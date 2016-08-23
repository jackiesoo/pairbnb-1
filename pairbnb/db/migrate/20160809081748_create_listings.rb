class CreateListings < ActiveRecord::Migration
  def change
    create_table :listings do |t|
      t.references :user,index: true, foreign_key: true
      t.string :place_name
      t.string :place_type
      t.string :address
      t.string :bedroom
      t.string :bath
      t.string :amenity
      t.integer :cost_per_night
      t.string :description


      t.timestamps null: false
    end
  end
end
