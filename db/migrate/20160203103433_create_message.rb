class CreateMessage < ActiveRecord::Migration
  def change
     create_table :messages do |m|
        m.text :mail
        m.text :msg
        m.timestamps
     end
  end
end
