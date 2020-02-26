# frozen_string_literal: true

require 'singleton'

module Azure
  
  class Management
    include Singleton
    include Service

    def initialize
      @required_attrs = %i(backend)
      @page_link_name = 'nextLink'
      @active_profile_name = ENV['AZURE_REST_API_PROFILE'] || 'latest'
      @active_profile = get_api_profile_by_name(@active_profile_name)
    end

    def get_api_profile_by_name(name)
      if Azure::AZURE_API_PROFILES.key?(name)
        return Azure::AZURE_API_PROFILES[name]
      else
        return Azure::AZURE_API_PROFILES['latest']
      end
    end

    def activity_log_alert(resource_group, id)
      get(
        url: link(location: 'Microsoft.Insights/activityLogAlerts',
                  resource_group: resource_group) + id,
        api_version: @active_profile.get_api_version('Microsoft.Insights', 'activityLogAlerts'),
      )
    end

    def activity_log_alerts
      get(
        url: link(location: 'Microsoft.Insights/activityLogAlerts'),
        api_version: @active_profile.get_api_version('Microsoft.Insights', 'activityLogAlerts'),
      )
    end

    def activity_log_alert_filtered(filter)
      get(
        url: link(location: "Microsoft.Insights/eventTypes/management/values/?$filter=#{filter}"),
        api_version: @active_profile.get_api_version('Microsoft.Insights', 'activityLogAlerts'),
      )
    end

    def aks_cluster(resource_group, id)
      get(
        url: link(location: 'Microsoft.ContainerService/managedClusters',
                  resource_group: resource_group) + id,
        api_version: '2017-01-31',
      )
    end

    def aks_clusters(resource_group)
      get(
        url: link(location: 'Microsoft.ContainerService/managedClusters',
                  resource_group: resource_group),
        api_version: '2017-01-31',
      )
    end

    def blob_container(resource_group, storage_account_name, blob_container_name)
      get(
        url: link(location: "Microsoft.Storage/storageAccounts/#{storage_account_name}/"\
                          "blobServices/default/containers/#{blob_container_name}",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Storage', 'storageAccounts/blobServices'),
      )
    end

    def blob_containers(resource_group, storage_account_name)
      get(
        url: link(location: "Microsoft.Storage/storageAccounts/#{storage_account_name}/"\
                          'blobServices/default/containers/',
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Storage', 'storageAccounts/blobServices'),
      )
    end

    def key_vaults(resource_group)
      get(
        url: link(location: 'Microsoft.KeyVault/vaults',
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.KeyVault', 'vaults'),
      )
    end

    def key_vault(resource_group, key_vault_name)
      get(
        url: link(location: "Microsoft.KeyVault/vaults/#{key_vault_name}",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.KeyVault', 'vaults'),
      )
    end

    def key_vault_diagnostic_settings(key_vault_id)
      get(
        url: "#{key_vault_id}/providers/microsoft.insights/diagnosticSettings",
        api_version: @active_profile.get_api_version('Microsoft.Insights', 'diagnosticSettings'),
      )
    end

    def locks(resource_group, resource_name, resource_type)
      get(
        url: link(location: "#{resource_type}/#{resource_name}",
                  resource_group: resource_group) + 'providers/Microsoft.Authorization/locks',
        api_version: @active_profile.get_api_version('Microsoft.Authorization', 'locks'),
      )
    end

    def log_profile(id)
      get(
        url: link(location: 'Microsoft.Insights/logProfiles') + id,
        api_version: @active_profile.get_api_version('Microsoft.Insights', 'logProfiles'),
      )
    end

    def log_profiles
      get(
        url: link(location: 'Microsoft.Insights/logProfiles'),
        api_version: @active_profile.get_api_version('Microsoft.Insights', 'logProfiles'),
      )
    end

    def management_groups
      get(
        url: '/providers/Microsoft.Management/managementGroups',
        api_version: '2018-03-01-preview',
      )
    end

    def management_group(group_id, expand: nil, recurse: false, filter: nil)
      params = {
        '$recurse' => recurse,
      }
      params.merge!('$expand' => expand) if expand
      params.merge!('$filter' => filter) if filter

      get(
        url: "/providers/Microsoft.Management/managementGroups/#{group_id}",
        api_version: '2018-03-01-preview',
        params: params,
      )
    end

    def mysql_server(resource_group, name)
      get(
        url: link(location: "Microsoft.DBforMySQL/servers/#{name}",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.DBforMySQL', 'servers'),
      )
    end

    def mysql_server_firewall_rules(resource_group, server_name)
      get(
        url: link(location: "Microsoft.DBforMySQL/servers/#{server_name}/firewallRules",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.DBforMySQL', 'servers'),
      )
    end

    def mysql_servers(resource_group)
      get(
        url: link(location: 'Microsoft.DBforMySQL/servers/',
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.DBforMySQL', 'servers'),
      )
    end

    def mysql_database(resource_group, server_name, database_name)
      get(
        url: link(location: "Microsoft.DBforMySQL/servers/#{server_name}/databases/#{database_name}",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.DBforMySQL', 'servers'),
      )
    end

    def mysql_databases(resource_group, server_name)
      get(
        url: link(location: "Microsoft.DBforMySQL/servers/#{server_name}/databases",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.DBforMySQL', 'servers'),
      )
    end

    def network_security_group(resource_group, id)
      get(
        url: link(location: 'Microsoft.Network/networkSecurityGroups',
                  resource_group: resource_group) + id,
        api_version: @active_profile.get_api_version('microsoft.network', 'networkSecurityGroups'),
      )
    end

    def network_security_groups(resource_group)
      get(
        url: link(location: 'Microsoft.Network/networkSecurityGroups',
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('microsoft.network', 'networkSecurityGroups'),
      )
    end

    def network_watcher(resource_group, id)
      get(
        url: link(location: 'Microsoft.Network/networkWatchers',
                  resource_group: resource_group) + id,
        api_version: @active_profile.get_api_version('Microsoft.Network','networkWatchers'),
      )
    end

    def network_watchers(resource_group)
      get(
        url: link(location: 'Microsoft.Network/networkWatchers',
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Network','networkWatchers'),
      )
    end

    def network_watcher_flow_log_status(resource_group, network_watcher, nsg)
      post(
        url: link(location: "Microsoft.Network/networkWatchers/#{network_watcher}/queryFlowLogStatus",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Network','networkWatchers'),
        req_body: "{\"targetResourceId\": \"/subscriptions/#{subscription_id}/resourceGroups/#{resource_group}/providers/Microsoft.Network/networkSecurityGroups/#{nsg}\"}",
      )
    end

    def postgresql_server(resource_group, name)
      get(
        url: link(location: "Microsoft.DBforPostgreSQL/servers/#{name}",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('microsoft.DBforPostgreSQL','servers'),
      )
    end

    def postgresql_server_configurations(resource_group, name)
      get(
        url: link(location: "Microsoft.DBforPostgreSQL/servers/#{name}/configurations",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('microsoft.DBforPostgreSQL','servers'),
      )
    end

    def postgresql_servers(resource_group)
      get(
        url: link(location: 'Microsoft.DBforPostgreSQL/servers/',
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('microsoft.DBforPostgreSQL','servers'),
      )
    end

    def postgresql_database(resource_group, server_name, database_name)
      get(
        url: link(location: "Microsoft.DBforPostgreSQL/servers/#{server_name}/databases/#{database_name}",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('microsoft.DBforPostgreSQL','servers'),
      )
    end

    def postgresql_databases(resource_group, server_name)
      get(
        url: link(location: "Microsoft.DBforPostgreSQL/servers/#{server_name}/databases",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('microsoft.DBforPostgreSQL','servers'),
      )
    end

    def resource_groups
      get(
        url: link(location: 'resourcegroups', provider: false),
        api_version: @active_profile.get_api_version('microsoft.resources','resourceGroups'),
      )
    end

    def role_definition(name)
      get(
        url: link(location: "Microsoft.Authorization/roleDefinitions/#{name}", provider: true),
        api_version: @active_profile.get_api_version('microsoft.authorization', 'roleDefinitions'),
      )
    end

    def role_definitions
      get(
        url: link(location: 'Microsoft.Authorization/roleDefinitions', provider: true),
        api_version: @active_profile.get_api_version('microsoft.authorization', 'roleDefinitions'),
      )
    end

    def scp_auto_provisioning_settings
      get(
        url: link(location: 'Microsoft.Security/autoProvisioningSettings'),
        api_version: '2017-08-01-preview',
      )
    end

    def scp_default_policy
      get(
        url: link(location: 'Microsoft.Authorization/policyAssignments/SecurityCenterBuiltIn'),
        api_version: @active_profile.get_api_version('Microsoft.Authorization', 'policyAssignments'),
      )
    end

    def security_center_policy(id)
      get(
        url: link(location: 'Microsoft.Security/policies') + id,
        api_version: '2015-06-01-Preview',
      )
    end

    def security_center_policies
      get(
        url: link(location: 'Microsoft.Security/policies'),
        api_version: '2015-06-01-Preview',
      )
    end

    def sql_servers(resource_group)
      get(
        url: link(location: 'Microsoft.Sql/servers',
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Sql', 'servers'),
      )
    end

    def sql_server(resource_group, name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{name}",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Sql', 'servers'),
      )
    end

    def sql_server_auditing_settings(resource_group, server_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/auditingSettings/default",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Sql', 'servers/extendedAuditingSettings'),
      )
    end
    
    def sql_server_threat_detection_settings(resource_group, server_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/securityAlertPolicies/Default",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Sql', 'servers/securityAlertPolicies'),
      )
    end

    def sql_server_administrators(resource_group, server_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/administrators",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Sql', 'managedInstances/administrators'),
      )
    end

    def sql_encryption_protector(resource_group, server_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/encryptionProtector",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Sql', 'servers/encryptionProtector'),
      )
    end
    
    def sql_server_firewall_rules(resource_group, server_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/firewallRules",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Sql', 'servers'),
      )
    end

    def sql_database(resource_group, server_name, database_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/databases/#{database_name}",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Sql', 'servers/databases'),
      )
    end

    def sql_databases(resource_group, server_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/databases",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Sql', 'servers/databases'),
      )
    end

    def sql_database_auditing_settings(resource_group, server_name, database_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/databases/#{database_name}" \
                          '/auditingSettings/default',
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Sql', 'servers/extendedAuditingSettings'),
      )
    end

    def sql_database_threat_detection_settings(resource_group, server_name, database_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/databases/#{database_name}" \
                          '/securityAlertPolicies/default',
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Sql', 'servers/databases/securityAlertPolicies'),
      )
    end

    def sql_database_encryption(resource_group, server_name, database_name)
      get(
        url: link(location: "Microsoft.Sql/servers/#{server_name}/databases/#{database_name}" \
                          '/transparentDataEncryption/current',
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Sql', 'servers/databases/transparentDataEncryption'),
      )
    end

    def storage_account(resource_group, name)
      get(
        url: link(location: "Microsoft.Storage/storageAccounts/#{name}",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Storage', 'storageAccounts'),
      )
    end

    def storage_accounts(resource_group)
      get(
        url: link(location: 'Microsoft.Storage/storageAccounts',
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Storage', 'storageAccounts'),
      )
    end

    def subnet(resource_group, vnet, name)
      get(
        url: link(location: "Microsoft.Network/virtualNetworks/#{vnet}/subnets",
                  resource_group: resource_group) + name,
        api_version: @active_profile.get_api_version('Microsoft.Network', 'virtualNetworks'),
      )
    end

    def subnets(resource_group, vnet)
      get(
        url: link(location: "Microsoft.Network/virtualNetworks/#{vnet}/subnets",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Network', 'virtualNetworks'),
      )
    end

    def subscription
      get(
        url: "/subscriptions/#{subscription_id}",
        api_version: @active_profile.get_api_version('Microsoft.Resources','subscriptions'),
      )
    end

    def subscription_locations
      get(
        url: link(location: 'locations', provider: false),
        api_version: @active_profile.get_api_version('Microsoft.Resources', 'subscriptions/locations'),
      )
    end

    def virtual_machine(resource_group, id)
      get(
        url: link(location: 'Microsoft.Compute/virtualMachines',
                  resource_group: resource_group) + id,
        api_version: @active_profile.get_api_version('Microsoft.Compute','virtualMachines'),
      )
    end

    def virtual_machines(resource_group)
      get(
        url: link(location: 'Microsoft.Compute/virtualMachines',
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Compute','virtualMachines'),
      )
    end

    def virtual_network(resource_group, id)
      get(
        url: link(location: 'Microsoft.Network/virtualNetworks',
                  resource_group: resource_group) + id,
        api_version: @active_profile.get_api_version('Microsoft.Network', 'virtualNetworks'),
      )
    end

    def virtual_networks(resource_group)
      get(
        url: link(location: 'Microsoft.Network/virtualNetworks',
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Network', 'virtualNetworks'),
      )
    end

    def virtual_machine_disk(resource_group, id)
      get(
        url: link(location: 'Microsoft.Compute/disks',
                  resource_group: resource_group) + id,
        api_version: @active_profile.get_api_version('Microsoft.Compute', 'disks'),
      )
    end

    def virtual_machine_disks
      get(
        url: link(location: 'Microsoft.Compute/disks'),
        api_version: @active_profile.get_api_version('Microsoft.Compute', 'disks'),
      )
    end

    def webapp(resource_group, webapp_name)
      get(
        url: link(location: "Microsoft.Web/sites/#{webapp_name}",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Web', 'sites'),
      )
    end

    def webapps(resource_group)
      get(
        url: link(location: 'Microsoft.Web/sites',
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Web', 'sites'),
      )
    end

    def webapp_authentication_settings(resource_group, webapp_name)
      post(
        url: link(location: "Microsoft.Web/sites/#{webapp_name}" \
                          '/config/authsettings/list',
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Web', 'sites'),
      )
    end

    def webapp_configuration(resource_group, webapp_name)
      get(
        url: link(location: "Microsoft.Web/sites/#{webapp_name}/config/web",
                  resource_group: resource_group),
        api_version: @active_profile.get_api_version('Microsoft.Web', 'sites'),
      )
    end

    def webapp_supported_stacks
      get(
        url: link(location: 'Microsoft.Web/availableStacks'),
        api_version: @active_profile.get_api_version('Microsoft.Web', 'availableStacks'),
      )
    end

    private

    def rest_client
      backend.enable_cache(:api_call)
      @rest_client ||= Azure::Rest.new(backend.azure_client)
    end

    def link(location:, provider: true, resource_group: nil)
      "/subscriptions/#{subscription_id}" \
      "#{"/resourceGroups/#{resource_group}" if resource_group}" \
      "#{'/providers' if provider}" \
      "/#{location}/"
    end
  end
end
