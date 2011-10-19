Factory.sequence :id do |n|
  n
end

Factory.define :mp do |mp|
  mp.active true
  mp.riding { Factory(:riding) }
  mp.parl_gc_id { Factory.next :id }
  mp.parl_gc_constituency_id { Factory.next :id }
  
  mp.party { Factory(:party) }
  mp.name "MP"
end

Factory.define :senator do |s|
  s.name "Senator"
  s.party { Factory(:party) }
  s.province { Factory(:province) }
  s.nomination_date Date.parse("1993-03-11")
  s.retirement_date Date.parse("2019-08-14")
  s.appointed_by "Mulroney (Prog. Conser.)"
end

Factory.define :vote do |v|
  v.bill_number "C2"
end

Factory.define :link do |l|
  l.url      "http://example.com"
  l.title    "example"
  l.category "glossary"
end

Factory.define :province do |p|
  p.abbreviation "NY"
  p.name "Empire Province"
end

Factory.define :party do |p|
  p.name "Party"
end

Factory.define :riding do |r|
  r.name "Riding"
end
