require 'net/http'
require 'json'

require_relative '../utils/HttpClient.rb'

class Plugin
    def initialize(plugin_folder)
      @plugin_folder = plugin_folder
      @data = {} # Initialize data storage
    end

    def before_render(view_name)
        hook_method = "before_#{view_name}"
        send(hook_method) if respond_to?(hook_method) # Call hook if defined
    end
  
    def render(view)
      before_render(view)
      template_path = File.join(@plugin_folder,"views","#{view}.erb")
      if File.exist?(template_path)
        erb = ERB.new(File.read(template_path))
        erb.result_with_hash(@data) # Merge plugin data with view data
      else
        "View '#{view}' not found for plugin '#{self.class.name}'"
      end
    end

    def fetch(url, request_headers, cache_time = nil)
      HttpClient.fetch(url, headers: request_headers, cache_time: cache_time)
    end
  end