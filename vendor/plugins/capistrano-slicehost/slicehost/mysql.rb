namespace :mysql do
  desc "Restarts MySQL database server"
  task :restart, :roles => :db do
    sudo "/etc/init.d/mysql restart"
  end

  desc "Starts MySQL database server"
  task :start, :roles => :db do
    sudo "/etc/init.d/mysql start"
  end

  desc "Stops MySQL database server"
  task :stop, :roles => :db do
    sudo "/etc/init.d/mysql stop"
  end

  desc "Export MySQL database"
  task :export, :roles => :db do
    database = Capistrano::CLI.ui.ask("Which database should we export: ")
    sudo "mysqldump -u root -p #{database} > #{database}.sql"
  end

  desc "Import MySQL database"
  task :import, :roles => :db do
    database = Capistrano::CLI.ui.ask("Which database should we create: ")
    file = Capistrano::CLI.ui.ask("Which database file should we import: ")
    sudo "mysqladmin -u root -p create #{database}"
    sudo "mysql -u root -p #{database} < #{file}"
  end

  desc "Install MySQL"
  task :install, :roles => :db do
    sudo "aptitude install -y mysql-server mysql-client libmysqlclient15-dev"
    sudo "aptitude install -y libmysql-ruby1.8"
  end
end
