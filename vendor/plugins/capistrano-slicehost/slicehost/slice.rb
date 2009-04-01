namespace :slice do
  task :configure do
    ssh.setup
    iptables.configure
    aptitude.setup
  end
end
