module DXRubyRP5
  module Window
    module_function

    def width
      @width ||= DEFAULTS[:width]
      return @width
    end

    def height
      @height ||= DEFAULTS[:height]
      return @height
    end

    def width=(_width)
      @width = _width
    end

    def height=(_height)
      @height = _height
    end

    def caption
      return $sketch.get_activity.get_title
    end

    def caption=(val)
      $sketch.get_activity.set_title(val)
    end

    def fps
      $sketch.field_frame_rate
    end

    def fps=(val)
      $sketch.frameRate(val.to_f)
    end

    def get_load
      # TODO:
      return 0
    end

    def loop(&block)
      @loop = Proc.new do
        background(*DEFAULTS[:background_color])
        block.call
        Window.send(:exec_draw_tasks)
        Input.send(:handle_key_events)
        # Input.send(:handle_pad_events)
      end
      @queue = []
    end

    def draw(x, y, image, z = 0)
      draw_ex(x, y, image, { :z => z })
    end

    def draw_ex(x, y, image, hash = {})
      @queue << {
        :x     => x,
        :y     => y,
        :z     => hash[:z] || 0,
        :image => image._surface,
        :ex    => hash,
      }
    end

    def draw_font(x, y, string, font, hash = {})
      return if string.empty?
      @queue << {
        :x    => x,
        :y    => y,
        :z    => hash[:z] || 0,
        :text => string,
        :font => font,
        :ex   => hash,
      }
    end

    class << self
      alias_method :drawFont, :draw_font

      private

      def exec_draw_tasks
        @queue.sort { |a, b| a[:z] <=> b[:z] }.each do |task|
          if task[:image]
            if ex = task[:ex]
              $sketch.push_matrix
              $sketch.translate(task[:x], task[:y])
              $sketch.scale(ex[:scale_x] || 1, ex[:scale_y] || 1) if ex[:scale_x] || ex[:scale_y]
              $sketch.rotate($sketch.class.radians(ex[:angle])) if ex[:angle]
              $sketch.tint(255, ex[:alpha]) if ex[:alpha]
              $sketch.image(task[:image], 0, 0)
              $sketch.no_tint
              $sketch.pop_matrix
            else
              $sketch.image(task[:image], task[:x], task[:y])
            end
          elsif task[:text] && task[:font]
            ex = task[:ex] || {}
            color = ex[:color] ? $sketch.color(*ex[:color]) : $sketch.color(255)
            # TODO: scale, center, alpha などの対応
            $sketch.push_matrix
            $sketch.text_size(task[:font].size)
            $sketch.text_font(task[:font].native)
            $sketch.text_align($sketch.class::LEFT, $sketch.class::TOP)
            $sketch.fill(color)
            $sketch.text(task[:text], task[:x], task[:y])
            $sketch.pop_matrix
          end
        end
        @queue.clear
      end
    end

    private

    DEFAULTS = {
      width:  $sketch.displayWidth,
      height: $sketch.displayHeight,
      background_color: [0, 0, 0],
    }
    private_constant :DEFAULTS
  end
end
