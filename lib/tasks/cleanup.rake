namespace :cleanup do
  desc "Remove duplicate news article associations for MPs and Senators"
  task :remove_duplicate_news => ['cleanup:remove_duplicate_news_for_mps', 'cleanup:remove_duplicate_news_for_senators'] do
  end

  task :remove_duplicate_news_for_mps => :environment do
    puts "Starting removing duplicate news for MPs"
    RemoveDuplicateNews.for_mps
    puts "Finished removing duplicate news for MPs"
  end

  task :remove_duplicate_news_for_senators => :environment do
    puts "Starting removing duplicate news for Senators"
    RemoveDuplicateNews.for_senators
    puts "Finished removing duplicate news for Senators"
  end
end
