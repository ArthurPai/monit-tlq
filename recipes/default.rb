# install monit
package 'monit'

# update the main monit configuration file
template "/etc/monitrc" do
  owner "root"
  group "root"
  mode "0700"
  source "monit-rc.erb"
  notifies :run, "execute[restart-monit]", :immediately
end

# Use upstart to manage monit
template '/etc/init/monit.conf' do
  owner "root"
  group "root"
  mode "0644"
  source "monit-upstart.conf.erb"
  notifies :run, "execute[restart-monit]", :immediately
end

# allow monit to startup
template '/etc/default/monit' do
  owner "root"
  group "root"
  mode "0644"
  source "allow-monit-start.erb"
  notifies :run, "execute[restart-monit]", :immediately
end

execute "restart-monit" do
  command "initctl reload-configuration"
  command "monit reload"
  action :nothing
end
