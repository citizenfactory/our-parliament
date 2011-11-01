class AddParlGcConstituencyIdToRidings < ActiveRecord::Migration
  def self.up
    add_column :ridings, :parl_gc_constituency_id, :string
    add_index :ridings, :parl_gc_constituency_id, :unique => true
  end

  def self.down
    remove_index :ridings, :parl_gc_constituency_id
    remove_column :ridings, :parl_gc_constituency_id
  end
end
