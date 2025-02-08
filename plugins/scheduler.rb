require 'time'

class Scheduler 
  def self.current_time_minutes
    now = Time.now
    now.hour * 60 + now.min
  end
  
  def self.time_to_minutes(time_str)
    hours, minutes = time_str.split(':').map(&:to_i)
    hours * 60 + minutes
  end
  
  def self.find_active_plugins(config)
    current_minutes = current_time_minutes
  
    config['schedules'].each do |schedule|
      schedule_from = time_to_minutes(schedule['from'])
      schedule_to = time_to_minutes(schedule['to'])
  
          # Handle overnight schedules
      if schedule_from <= current_minutes && current_minutes <= schedule_to || (schedule_to < schedule_from && (current_minutes >= schedule_from || current_minutes <= schedule_to))
        schedule['scenes'].each do |scene|
          scene_from = scene['from'].to_i
          scene_to = scene['to'].to_i
          minute_of_hour = current_minutes % 60
  
          # Handle scenes that cross the hour
          if scene_from <= minute_of_hour && minute_of_hour <= scene_to || (scene_to < scene_from && (minute_of_hour >= scene_from || minute_of_hour <= scene_to))
            return scene['plugins']
          end
        end
      end
    end
  
    return [] # No active plugins found
  end
end