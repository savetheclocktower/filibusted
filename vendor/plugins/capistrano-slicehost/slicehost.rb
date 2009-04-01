unless Capistrano::Configuration.respond_to?(:instance)
  abort "Requires Capistrano 2"
end

Dir["#{File.dirname(__FILE__)}/slicehost/*.rb"].each { |lib|
  Capistrano::Configuration.instance.load {load(lib)}
}
