class RenameWorkExperienceColumnLocation < ActiveRecord::Migration[7.1]
  def change
    rename_column :work_experiences, :locaton, :location
  end
end
