class AddResolvedToProblems < ActiveRecord::Migration
  def change
    add_column :problems, :resolved, :boolean, default: false
  end
end
