class AddProvinceAbbreviation < ActiveRecord::Migration
  def self.up
    add_column :provinces, :abbreviation, :string, :limit => 2
  end

  def self.down
    remove_column :provinces, :abbreviation
  end
end
