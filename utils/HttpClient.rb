require 'httparty'
require 'json'

class HttpClient
  include HTTParty

  def self.fetch(url, headers: {}, cache_time: nil)
    if cache_time
      cached_response = HttpCache.find_by(url: url)

      if cached_response && !expired?(cached_response, cache_time)
        puts "Cache hit for: #{url}" # Optional logging
        return JSON.parse(cached_response.response_body) # Parse JSON if needed
      end
    end

    puts "Making HTTP request to: #{url}" # Optional logging

    begin
      response = get(url, headers: headers) # Or post, put, delete, etc.

      if cache_time
        puts "Caching response for: #{url}" # Optional logging
        expires_at = Time.now + cache_time
        HttpCache.find_or_create_by(url: url) do |cache|
          cache.response_body = response.body
          cache.expires_at = expires_at
        end
      end

      # Parse JSON if the response is JSON.  Otherwise, return the raw body
      if response.headers['Content-Type']&.include?('application/json')
         JSON.parse(response.body)
      else
         response.body
      end

    rescue HTTParty::Error => e
      puts "HTTParty Error: #{e.message}"
      raise # Re-raise the exception to be handled by the caller
    rescue JSON::ParserError => e
      puts "JSON Parse Error: #{e.message}"
      raise # Re-raise the exception
    end
  end

  private

  def self.expired?(cached_response, cache_time)
    return true if cache_time.nil? # No cache time, always treat as expired
    cached_response.expires_at < Time.now  # Check if the cache has expired
  end
end