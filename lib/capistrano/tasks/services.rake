namespace :services do
  desc 'Restart application services'
  task :restart do
    services = fetch(:services)
    services.each do |service|
      on roles(service[:roles]) do
        sudo = service[:sudo] ? "sudo" : ""
        if test("initctl list | grep #{service[:name]}")
          if test("status #{service[:name]} 2>&1 | grep running")
            execute "#{sudo} restart #{service[:name]}"
          else
            execute "#{sudo} start #{service[:name]}"
          end
        end
      end
    end
  end
end

after "deploy:publishing", "services:restart"
