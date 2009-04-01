namespace :disk do
  desc "Show the amount of free disk space."
  task :free, :roles => :files do
    run "df -h /"
  end

  desc "Show free memory"
  task :memory, :roles => :files do
    run "free -m"
  end

end
