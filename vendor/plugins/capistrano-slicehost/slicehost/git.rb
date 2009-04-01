namespace :git do
  desc "Install git"
  task :install, :roles => :app do
    sudo "aptitude install -y git-core"
  end
end
