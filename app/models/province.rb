class Province < ActiveRecord::Base
  ALIASES = {
    "québec" => "Quebec",
    "nl" => "Newfoundland and Labrador",
    "p.e.i." => "Prince Edward Island",
    "b.c." => "British Columbia",
    "n.b." => "New Brunswick",
    "n.s." => "Nova Scotia",
    "n.w.t." => "Northwest Territories"
  }

  translatable_columns :name
  has_many :ridings
  has_many :senators
  has_many :mps, :order => "name"

  class << self
    def lookup(name)
      province_name = ALIASES[name.downcase] || name
      Province.find_by_name_en(province_name)
    end
  end
end
