require_relative '../plugin.rb'

class Example < Plugin
    def before_full
      @data[:titke] = "Full View Title"
      @data[:content] = "This is the content for the full view."
    end

    def before_half_horizontal
      @data[:subtitle] = "Half Horizontal Subtitle"
      @data[:items] = [1, 2, 3]
    end

    def before_half_vertical
      @data[:subtitle] = "Half Vertical Subtitle"
      @data[:items] = [4, 5, 6]
    end

    def before_quadrant
      @data[:message] = "Quadrant Message"
    end
  end