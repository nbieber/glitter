class CreateProfilesTable < ActiveRecord::Migration
  def change
  	create_table :profiles do |t|
  		t.string :fullname
  		t.string :email
  		t.belongs_to :user
  		t.timestamps
  	end
  end
end
