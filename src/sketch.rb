$LOAD_PATH << File.expand_path(File.dirname(__FILE__))

class Sketch < PApplet
  import org.ruboto.Log

  field_accessor :frameCount   => :field_frame_count
  field_accessor :frameRate    => :field_frame_rate
  field_accessor :mousePressed => :field_mouse_pressed

  def ruboto_log
    Log
  end

  def settings
    $sketch = self
    dxruby_file_name = get_resources.get_string(R.string.dxruby_entry_point)
    require dxruby_file_name
    size(Window.width, Window.height)
  end

  def setup
    ruboto_log.d "displayWidth: #{displayWidth}"
    ruboto_log.d "displayHeight: #{displayHeight}"
    ruboto_log.d "width: #{width}"
    ruboto_log.d "height: #{height}"
  end

  def draw
    instance_eval(&DXRubyRP5::Window.instance_variable_get(:@loop))
  end

  def keyPressed(event)
    ruboto_log.d "keyPressed, key: #{key}, keyCode: #{keyCode}"
    DXRubyRP5::Input.send(:key_pressed, key, keyCode)
    DXRubyRP5::Input.send(:key_pushed, key, keyCode)
  end

  def keyReleased(event)
    ruboto_log.d "keyReleased, key: #{key}, keyCode: #{keyCode}"
    DXRubyRP5::Input.send(:key_released, key, keyCode)
  end

  def mousePressed(event)
    ruboto_log.d "mousePressed, event.get_button: #{event.get_button}"
  end

  def mouseClicked(event)
    ruboto_log.d "mouseClicked, event.get_button: #{event.get_button}"
    DXRubyRP5::Input.send(:mouse_pushed)
  end

  def mouseReleased(event)
    ruboto_log.d "mouseReleased, event.get_button: #{event.get_button}"
    DXRubyRP5::Input.send(:mouse_released)
  end
end
