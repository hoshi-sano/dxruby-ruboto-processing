module DXRubyRP5
  class RenderTarget
    attr_reader :bgcolor
    attr_reader :_surface

    def initialize(width, height, _bgcolor = [0, 255, 255, 255])
      _bgcolor = to_rp5_color(_bgcolor)
      @bgcolor = $sketch.color(*_bgcolor)
      @_surface = $sketch.create_graphics(width, height)
      @queue = []
    end

    def width
      return @_surface.width
    end

    def height
      return @_surface.height
    end

    def bgcolor
      return to_dxr_color(@bgcolor)
    end

    def bgcolor=(color)
      color = to_rp5_color(color)
      @bgcolor = $sketch.color(*color)
    end

    def update
      @_surface.begin_draw()
      @_surface.background(@bgcolor)
      @queue.sort { |a, b| a[:z] <=> b[:z] }.each do |task|
        @_surface.image(task[:image], task[:x], task[:y])
      end
      @queue.clear
      @_surface.end_draw()
    end

    def draw(x, y, image, z = 0)
      return if image.nil?
      @queue << {
        :x     => x,
        :y     => y,
        :z     => z,
        :image => image._surface,
      }
    end

    def draw_font(x, y, string, font, hash = {})
      # TODO
    end

    def draw_tile(basex, basey, map, image_arr, startx, starty, sizex, sizey, z = 0)
      @image_arr_cache ||= {}
      unless @image_arr_cache[image_arr.object_id]
        flattened = image_arr.flatten
        @image_arr_cache[image_arr.object_id] = {
          :image_array => flattened,
          :width       => flattened[0].width,
          :height      => flattened[0].height,
        }
      end
      cache = @image_arr_cache[image_arr.object_id]
      startx_mod_w = startx % cache[:width]
      starty_mod_h = starty % cache[:height]

      from_i = starty_mod_h < 0 ? -1 : 0
      to_i   = sizey + (starty_mod_h <= 0 ?  0 : 1)
      from_j = startx_mod_w < 0 ? -1 : 0
      to_j   = sizex + (startx_mod_w <= 0 ?  0 : 1)

      y = basey - (starty_mod_h < 0 ? h + starty_mod_h : starty_mod_h)
      init_x = basex - (startx_mod_w < 0 ? w + startx_mod_w : startx_mod_w)

      (from_i..to_i).each do |i|
        if (i + starty / cache[:height]) < 0
          my = (((i + starty / cache[:height]) % map.size) + map.size) % map.size
        else
          my = (i + starty / cache[:height]) % map.size
        end
        map_row = map[my]

        x = init_x
        (from_j..to_j).each do |j|
          if (j + startx / cache[:width]) < 0
            mx = (((j + startx / cache[:width]) % map_row.size) + map_row.size) % map_row.size
          else
            mx = (j + startx / cache[:width]) % map_row.size
          end
          idx = map_row[mx]

          map_img = cache[:image_array][idx]
          self.draw(x, y, map_img, z)

          x += cache[:width]
        end
        y += cache[:height]
      end
    end

    alias_method :drawFont, :draw_font
    alias_method :drawTile, :draw_tile

    private

    def to_dxr_color(c)
      dxr_c = [c >> 16 & 0xFF, c >> 8 & 0xFF, c & 0xFF]
      if @_surface.format == $sketch.class::ARGB
        return dxr_c.unshift(c >> 24 & 0xFF)
      else
        return dxr_c
      end
    end

    def to_rp5_color(color)
      if color.size > 3
        color = color.dup
        color.push(color.shift)
      end
      return color
    end
  end
end
