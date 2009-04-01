set(:domain) do
  Capistrano::CLI.ui.ask "Which domain should we use? "
end

namespace :nginx do
  desc "Restarts Nginx webserver"
  task :restart, :roles => :web do
    sudo "/etc/init.d/nginx restart"
  end

  desc "Starts Nginx webserver"
  task :start, :roles => :web do
    sudo "/etc/init.d/nginx start"
  end

  desc "Stops Nginx webserver"
  task :stop, :roles => :web do
    sudo "/etc/init.d/nginx stop"
  end

  desc "Reload Nginx webserver"
  task :reload, :roles => :web do
    sudo "/etc/init.d/nginx reload"
  end

  desc "Force reload Nginx webserver"
  task :force_reload, :roles => :web do
    sudo "/etc/init.d/nginx force-reload"
  end

  desc "List enabled Nginx sites"
  task :enabled_sites, :roles => :web do
    run "ls /etc/nginx/sites-enabled"
  end

  desc "List available Nginx sites"
  task :available_sites, :roles => :web do
    run "ls /etc/nginx/sites-available"
  end

  desc "Disable Nginx site"
  task :disable_site, :roles => :web do
    site = Capistrano::CLI.ui.ask("Which site should we disable: ")
    sudo "rm /etc/nginx/sites-enabled/#{site}"
    reload
  end

  desc "Enable Nginx site"
  task :enable_site, :roles => :web do
    site = Capistrano::CLI.ui.ask("Which site should we enable: ")
    sudo "ln -s /etc/nginx/sites-available/#{site} /etc/nginx/sites-enabled/#{site}"
    reload
  end

  desc "Install Nginx"
  task :install, :roles => :web do
     sudo "aptitude install -y nginx"
  end
end
