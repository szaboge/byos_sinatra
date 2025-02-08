require 'erb'
require 'fileutils'
require_relative 'scheduler.rb'

class Renderer
    def initialize()
      @config = YAML.load_file('config.yaml')
      @plugins = {}
      load_plugins
    end
  
    def load_plugins
      @config['plugins'].each do |plugin_name, plugin_config|
        plugin_class_name = plugin_name.camelize # Convert snake_case to CamelCase
        begin
          require_relative "#{plugin_name}/#{plugin_name}.rb"
          plugin_class = Object.const_get(plugin_class_name)
          @plugins[plugin_name] = plugin_class.new(plugin_config['folder'])
        rescue NameError
          puts "Error: Plugin class '#{plugin_class_name}' not found."
        rescue => e
          puts "Error loading plugin '#{plugin_name}': #{e.message}"
        end
      end
    end
  
    def render
        container_erb = ERB.new(File.read('plugins/container.erb'))

        plugins = Scheduler.find_active_plugins(@config)
        rendered_plugins = ""
        plugins.each do |plugin_config|
          plugin_name = plugin_config['plugin']
          view_type = plugin_config['view']
          plugin = @plugins[plugin_name]
          if plugin
            rendered_plugins += plugin.render(view_type)
          else
              puts "Error: Plugin '#{plugin_name}' not found."
          end
        end
        container_erb.result_with_hash({rendered_plugins: rendered_plugins})
    end
end