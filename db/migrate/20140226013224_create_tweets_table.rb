class CreateTweetsTable < ActiveRecord::Migration
  def change
  	create_table :tweets do |t|
  		t.string :content, :limit => 140
  		t.belongs_to :user
  		t.timestamps
  	end
  end
end
