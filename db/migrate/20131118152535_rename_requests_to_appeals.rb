class RenameRequestsToAppeals < ActiveRecord::Migration
  def change
  	rename_table :requests, :appeals
  end
end
