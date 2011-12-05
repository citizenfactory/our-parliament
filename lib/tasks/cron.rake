task :cron => :environment do
  now = Time.now
  if now.hour == 0 # run at midnight
    Rake::Task['update:hansards'].execute
    Rake::Task['scrape:vote_list'].execute
    Rake::Task['scrape:all_vote_details'].execute

    if now.wday == 6 # run on Saturday
      Rake::Task['scrape:members']
      Rake::Task['scrape:senators']
    end
  end

  if (now.hour % 5) == 0
    Rake::Task['update:twitter'].execute
    Rake::Task['update:news'].execute
  end
end
