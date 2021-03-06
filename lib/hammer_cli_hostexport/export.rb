require 'hammer_cli'
require 'hammer_cli_foreman/host'

module HammerCLIExportHosts
  class ExportHostsCommand < HammerCLIForeman::Command

    resource :hosts
    action :index

    command_name 'Export Hosts for Migration'
    option ["--per_page"], "PER_PAGE", "Number of responses to return", :default => 1000 

    output do
      field :name, 'name'
      field :ip, 'ip'
      field :mac, 'mac'
      field :operatingsystem_name, 'os'
      field :environment_name, 'environment'
    end

    def adapter
      :csv
    end

    def request_params
      params             = super
      params['per_page'] ||= "#{per_page}"
      params
    end

    def execute
      puts :operating_systems    

      print_record(output_definition, hosts)
      
      HammerCLI::EX_OK
    end

    private

    def response
      @response ||= send_request
    end

    def hosts
      @hosts ||= response['results']
    end

  end

  # Plug in to the hammer command
  HammerCLIForeman::Host.subcommand('exporthosts', 'Export basic host information', HammerCLIExportHosts::ExportHostsCommand)
end
