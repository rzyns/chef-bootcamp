#
# Cookbook Name:: webserver
# Recipe:: destroy
#
# Copyright (c) 2015 The Authors, All Rights Reserved.

name = "FlyingSpaghettiMonster"

require "chef/provisioning/aws_driver"

with_driver "aws::us-east-1" do
  machine_batch do
    action :destroy
    1.upto(3) do |n|
      machine "#{name}-webserver-#{n}"
    end
  end

  1.upto(3) do |n|
    aws_security_group "#{name}-ssh" do
      action :destroy
    end

    aws_security_group "#{name}-http" do
      action :destroy
    end

    aws_key_pair "#{name}-key" do
      action :destroy
    end
  end

end
