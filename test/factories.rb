Factory.sequence :id do |n|
  n
end

Factory.define :mp do |mp|
  mp.active true
  mp.riding_id { Factory.next :id }
  mp.parl_gc_id { Factory.next :id }
  mp.parl_gc_constituency_id { Factory.next :id }
  
  mp.party_id { Factory.next :id }
  mp.name { Factory.next :id }
end

Factory.define :senator do |s|
  s.name { Factory.next :id}
  s.party_id { Factory.next :id }
  s.province_id { Factory.next :id }
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