class CreateProblems < ActiveRecord::Migration
  def change
    create_table :problems do |t|
      t.text :issue
      t.text :try
      t.references :user, index: true

      t.timestamps
    end
  end
end
