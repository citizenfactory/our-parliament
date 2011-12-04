namespace :cleanup do
  desc "Remove duplicate news article associations for MPs and Senators"
  task :remove_duplicate_news => :environment do
    RemoveDuplicateNews.for_mps
    RemoveDuplicateNews.for_senators
  end
end
