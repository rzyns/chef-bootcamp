#
# Cookbook Name:: webserver
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

package "httpd"

template "/var/www/html/index.html" do
  source "index_html.erb"
  variables({
    :webservers => search(:node, "tags:your-webserver AND NOT name:#{node.name}")
  })
end

service "httpd" do
  action [ :enable, :start ]
end

service "iptables" do
  action [ :disable, :stop ]
end
