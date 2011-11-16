class Party < ActiveRecord::Base
  ALIASES = {
    "ndp" => "New Democratic Party",
    "c" => "Conservative",
    "lib." => "Liberal",
    "ind." => "Independent",
    "prog. conser." => "Progressive Conservative"
  }

  translatable_columns :name
  has_many :mps

  class << self
    def lookup(name)
      party_name = ALIASES[name.downcase] || name
      Party.find_by_name_en(party_name)
    end
  end

  def active_mps
    return Mp.find_all_active_by_party_id(id)
  end
end
