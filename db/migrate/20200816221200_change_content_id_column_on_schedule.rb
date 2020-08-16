class ChangeContentIdColumnOnSchedule < ActiveRecord::Migration[5.2]
  def change
    change_column_null :schedules, :content_id, false, 0
  end
end
