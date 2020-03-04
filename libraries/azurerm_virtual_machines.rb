# frozen_string_literal: true

require 'azurerm_resource'

class AzurermVirtualMachines < AzurermPluralResource
  name 'azurerm_virtual_machines'
  desc 'Verifies settings for Azure Virtual Machines'
  example <<-EXAMPLE
    azurerm_virtual_machines(resource_group: 'example') do
      it{ should exist }
    end
  EXAMPLE

  FilterTable.create
             .register_column(:os_disks,   field: 'os_disk')
             .register_column(:data_disks, field: 'data_disks')
             .register_column(:vm_names,   field: 'name')
             .register_column(:platforms,   field: 'platform')
             .register_column(:network_interfaces,   field: 'network_interfaces')
             .register_column(:tags,   field: 'tags')
             .install_filter_methods_on_resource(self, :table)

  attr_reader :table

  def initialize(resource_group: nil)
    resp = management.virtual_machines(resource_group)
    return if has_error?(resp)

    @table = resp.collect(&with_platform)
                 .collect(&with_os_disk)
                 .collect(&with_data_disks)
                 .collect(&with_network_interfaces)
                 .collect(&with_tags)
  end

  include Azure::Deprecations::StringsInWhereClause

  def to_s
    'Azure Virtual Machines'
  end

  def with_platform
    lambda do |vm|
      os_profile = vm.properties.osProfile

      platform = \
        if os_profile.key?(:windowsConfiguration)
          'windows'
        elsif os_profile.key?(:linuxConfiguration)
          'linux'
        else
          'unknown'
        end

      Azure::Response.create(vm.members << :platform, vm.values << platform)
    end
  end

  def with_os_disk
    lambda do |vm|
      os_disk = vm.properties.storageProfile.osDisk

      disk_name = os_disk.key?(:name) ? os_disk.name : ''

      Azure::Response.create(vm.members << :os_disk, vm.values << disk_name)
    end
  end

  def with_data_disks
    lambda do |vm|
      disks = Array(vm.properties.storageProfile.dataDisks)
      disks = disks.select { |disk| disk.key?(:managedDisk) }

      Azure::Response.create(vm.members << :data_disks, vm.values << disks.collect(&:name))
    end
  end

  def with_network_interfaces
    lambda do |vm|
      nics = Array(vm.properties.networkProfile.networkInterfaces)
      names = nics.map { |nic| nic.id.split("/").last }.compact

      Azure::Response.create(vm.members << :network_interfaces, vm.values << names)
    end
  end

  def with_tags
    lambda do |vm|
      if !vm.respond_to?(:tags)
        return Azure::Response.create(vm.members << :tags, vm.values << nil)
      end

      Azure::Response.create(vm.members, vm.values)
    end
  end
end
