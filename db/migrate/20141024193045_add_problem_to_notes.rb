class AddProblemToNotes < ActiveRecord::Migration
  def change
    add_reference :notes, :problem, index: true
  end
end
