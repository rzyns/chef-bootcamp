#
# Cookbook Name:: webserver
# Recipe:: provision
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

name = "FlyingSpaghettiMonster"

require "chef/provisioning/aws_driver"

with_driver "aws::us-east-1" do
  aws_key_pair "#{name}-key" do
    allow_overwrite false
    private_key_path "#{ENV['HOME']}/.ssh/#{name}-key"
  end

  aws_security_group "#{name}-ssh" do
    inbound_rules '0.0.0.0/0' => 22
  end

  aws_security_group "#{name}-http" do
    inbound_rules '0.0.0.0/0' => 80
  end

  with_machine_options({
    :aws_tags => {"belongs_to" => name},
    :ssh_username => "root",
    :bootstrap_options => {
      :image_id => "ami-bf5021d6",
      :instance_type => "t1.micro",
      :key_name => "#{name}-key",
      :security_group_ids => ["#{name}-ssh", "#{name}-http"]
    }
  })

  webservers = 1.upto(3).map {|n| "#{name}-webserver-#{n}"}

  machine_batch do
    webservers.each do |instance|
      machine instance do
        recipe "webserver"
        tag "your-webserver"
        converge true
      end
    end
  end

  load_balancer "#{name}-lb" do
    machines webservers
    load_balancer_options({
      :security_groups => "#{name}-http"
    })
  end

end
