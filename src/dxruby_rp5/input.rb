java_import 'android.view.KeyEvent'

module DXRubyRP5
  module Input
    module_function

    def set_repeat(wait, interval)
      if wait == 0 && interval == 0
        @repeat_wait = nil
        @repeat_interval = nil
      else
        @repeat_wait = wait
        @repeat_interval = interval
      end
    end

    # NOTE: PAD非対応
    def x(pad_number = 0)
      res = 0
      if @pressed_keys
        res -= 1 if @pressed_keys.include?(to_dxruby_key($sketch.class::LEFT))
        res += 1 if @pressed_keys.include?(to_dxruby_key($sketch.class::RIGHT))
      end
      return res
    end

    # NOTE: PAD非対応
    def y(pad_number = 0)
      res = 0
      if @pressed_keys
        res -= 1 if @pressed_keys.include?(to_dxruby_key($sketch.class::UP))
        res += 1 if @pressed_keys.include?(to_dxruby_key($sketch.class::DOWN))
      end
      return res
    end

    def mouse_pos_x
      return $sketch.mouseX
    end

    def mouse_pos_y
      return $sketch.mouseY
    end

    def key_down?(key_code)
      if @pressed_keys
        return @pressed_keys.include?(key_code)
      else
        return false
      end
    end

    def key_push?(key_code)
      if @pushed_keys
        return @pushed_keys.include?(key_code)
      else
        return false
      end
    end

    def mouse_down?(button)
      if button == M_LBUTTON
        return $sketch.field_mouse_pressed
      else
        return false
      end
    end

    def mouse_push?(button)
      if button == M_LBUTTON
        return !!@mouse_pushed_count
      else
        return false
      end
    end

    def mouse_release?(button)
      if button == M_LBUTTON
        return !!@mouse_released_count
      else
        return false
      end
    end

    def pad_down?(button_code, pad_number = 0)
      if button_code == P_BUTTON0 && key_down?(K_Z) ||
          button_code == P_BUTTON1 && key_down?(K_X) ||
          button_code == P_BUTTON2 && key_down?(K_C) ||
          button_code == P_LEFT && key_down?(K_LEFT) ||
          button_code == P_RIGHT && key_down?(K_RIGHT) ||
          button_code == P_UP && key_down?(K_UP) ||
          button_code == P_DOWN && key_down?(K_DOWN) ||
          rp5_pad_pressed?(button_code)
        return true
      end
      return false
    end

    def pad_push?(button_code, pad_number = 0)
      if button_code == P_BUTTON0 && key_push?(K_Z) ||
          button_code == P_BUTTON1 && key_push?(K_X) ||
          button_code == P_BUTTON2 && key_push?(K_C) ||
          button_code == P_LEFT && key_push?(K_LEFT) ||
          button_code == P_RIGHT && key_push?(K_RIGHT) ||
          button_code == P_UP && key_push?(K_UP) ||
          button_code == P_DOWN && key_push?(K_DOWN) ||
          rp5_pad_pushed?(button_code)
        return true
      end
      return false
    end

    class << self
      alias_method :setRepeat, :set_repeat
      alias_method :padDown?, :pad_down?
      alias_method :padPush?, :pad_push?
      alias_method :keyDown?, :key_down?
      alias_method :keyPush?, :key_push?
      alias_method :mouseDown?, :mouse_down?
      alias_method :mousePush?, :mouse_push?
      alias_method :mousePosX, :mouse_pos_x
      alias_method :mousePosY, :mouse_pos_y

      private

      RP5_KEY_TABLE = {}
      replace_table = {
        'ABNT_C1'      => nil,
        'ABNT_C2'      => nil,
        'ADD'          => '+'.ord,
        'APOSTROPHE'   => "'".ord,
        'APPS'         => KeyEvent::KEYCODE_APP_SWITCH,
        'AT'           => '@'.ord,
        'AX'           => nil,
        'BACK'         => KeyEvent::KEYCODE_BACK,
        'BACKSPACE'    => $sketch.class::BACKSPACE,
        'BACKSLASH'    => "\\".ord,
        'CALCULATOR'   => KeyEvent::KEYCODE_CALCULATOR,
        'CAPITAL'      => KeyEvent::KEYCODE_CAPS_LOCK,
        'CAPSLOCK'     => KeyEvent::KEYCODE_CAPS_LOCK,
        'COLON'        => ':'.ord,
        'COMMA'        => ','.ord,
        'CONVERT'      => KeyEvent::KEYCODE_HENKAN,
        'DECIMAL'      => KeyEvent::KEYCODE_PERIOD,
        'DELETE'       => $sketch.class::DELETE,
        'DIVIDE'       => KeyEvent::KEYCODE_SLASH,
        'DOWN'         => $sketch.class::DOWN,
        'DOWNARROW'    => $sketch.class::DOWN,
        'END'          => KeyEvent::KEYCODE_MOVE_END,
        'EQUALS'       => '='.ord,
        'ESCAPE'       => $sketch.class::ESC,
        'F1'           => KeyEvent::KEYCODE_F1,
        'F10'          => KeyEvent::KEYCODE_F10,
        'F11'          => KeyEvent::KEYCODE_F11,
        'F12'          => KeyEvent::KEYCODE_F12,
        'F13'          => nil,
        'F14'          => nil,
        'F15'          => nil,
        'F2'           => KeyEvent::KEYCODE_F2,
        'F3'           => KeyEvent::KEYCODE_F3,
        'F4'           => KeyEvent::KEYCODE_F4,
        'F5'           => KeyEvent::KEYCODE_F5,
        'F6'           => KeyEvent::KEYCODE_F6,
        'F7'           => KeyEvent::KEYCODE_F7,
        'F8'           => KeyEvent::KEYCODE_F8,
        'F9'           => KeyEvent::KEYCODE_F9,
        'GRAVE'        => KeyEvent::KEYCODE_GRAVE,
        'HOME'         => KeyEvent::KEYCODE_MOVE_HOME,
        'INSERT'       => KeyEvent::KEYCODE_INSERT,
        'KANA'         => KeyEvent::KEYCODE_KANA,
        'KANJI'        => KeyEvent::KEYCODE_ZENKAKU_HANKAKU,
        'LALT'         => KeyEvent::KEYCODE_ALT_LEFT,
        'LBRACKET'     => '['.ord,
        'LCONTROL'     => KeyEvent::KEYCODE_CTRL_LEFT,
        'LEFT'         => $sketch.class::LEFT,
        'LEFTARROW'    => $sketch.class::LEFT,
        'LMENU'        => KeyEvent::KEYCODE_MENU,
        'LSHIFT'       => KeyEvent::KEYCODE_CTRL_LEFT,
        'LWIN'         => KeyEvent::KEYCODE_WINDOW,
        'MAIL'         => KeyEvent::KEYCODE_ENVELOPE,
        'MEDIASELECT'  => KeyEvent::KEYCODE_MEDIA_PLAY,
        'MEDIASTOP'    => KeyEvent::KEYCODE_MEDIA_STOP,
        'MINUS'        => '-'.ord,
        'MULTIPLY'     => '*'.ord,
        'MUTE'         => KeyEvent::KEYCODE_MUTE,
        'MYCOMPUTER'   => nil,
        'NEXT'         => nil,
        'NEXTTRACK'    => KeyEvent::KEYCODE_MEDIA_NEXT,
        'NOCONVERT'    => KeyEvent::KEYCODE_MUHENKAN,
        'NUMLOCK'      => KeyEvent::KEYCODE_NUM_LOCK,
        'NUMPAD0'      => KeyEvent::KEYCODE_NUMPAD_0,
        'NUMPAD1'      => KeyEvent::KEYCODE_NUMPAD_1,
        'NUMPAD2'      => KeyEvent::KEYCODE_NUMPAD_2,
        'NUMPAD3'      => KeyEvent::KEYCODE_NUMPAD_3,
        'NUMPAD4'      => KeyEvent::KEYCODE_NUMPAD_4,
        'NUMPAD5'      => KeyEvent::KEYCODE_NUMPAD_5,
        'NUMPAD6'      => KeyEvent::KEYCODE_NUMPAD_6,
        'NUMPAD7'      => KeyEvent::KEYCODE_NUMPAD_7,
        'NUMPAD8'      => KeyEvent::KEYCODE_NUMPAD_8,
        'NUMPAD9'      => KeyEvent::KEYCODE_NUMPAD_9,
        'NUMPADCOMMA'  => KeyEvent::KEYCODE_NUMPAD_COMMA,
        'NUMPADENTER'  => KeyEvent::KEYCODE_NUMPAD_ENTER,
        'NUMPADEQUALS' => KeyEvent::KEYCODE_NUMPAD_EQUALS,
        'NUMPADMINUS'  => KeyEvent::KEYCODE_NUMPAD_SUBTRACT,
        'NUMPADPERIOD' => KeyEvent::KEYCODE_NUMPAD_DOT,
        'NUMPADPLUS'   => KeyEvent::KEYCODE_NUMPAD_ADD,
        'NUMPADSLASH'  => KeyEvent::KEYCODE_NUMPAD_DIVIDE,
        'NUMPADSTAR'   => KeyEvent::KEYCODE_NUMPAD_MULTIPLY,
        'OEM_102'      => nil,
        'PAUSE'        => KeyEvent::KEYCODE_MEDIA_PAUSE,
        'PERIOD'       => '.'.ord,
        'PGDN'         => KeyEvent::KEYCODE_PAGE_DOWN,
        'PGUP'         => KeyEvent::KEYCODE_PAGE_UP,
        'PLAYPAUSE'    => KeyEvent::KEYCODE_MEDIA_PLAY_PAUSE,
        'POWER'        => KeyEvent::KEYCODE_POWER,
        'PREVTRACK'    => KeyEvent::KEYCODE_MEDIA_PREVIOUS,
        'PRIOR'        => nil,
        'RALT'         => KeyEvent::KEYCODE_ALT_RIGHT,
        'RBRACKET'     => ']'.ord,
        'RCONTROL'     => KeyEvent::KEYCODE_CTRL_RIGHT,
        'RETURN'       => $sketch.class::RETURN,
        'RIGHT'        => $sketch.class::RIGHT,
        'RIGHTARROW'   => $sketch.class::RIGHT,
        'RMENU'        => KeyEvent::KEYCODE_MENU,
        'RSHIFT'       => KeyEvent::KEYCODE_CTRL_RIGHT,
        'RWIN'         => KeyEvent::KEYCODE_WINDOW,
        'SCROLL'       => KeyEvent::KEYCODE_SCROLL_LOCK,
        'SEMICOLON'    => ';'.ord,
        'SLASH'        => '/'.ord,
        'SLEEP'        => KeyEvent::KEYCODE_SLEEP,
        'SPACE'        => ' '.ord,
        'STOP'         => KeyEvent::KEYCODE_MEDIA_STOP,
        'SUBTRACT'     => '-'.ord,
        'SYSRQ'        => KeyEvent::KEYCODE_SYSRQ,
        'TAB'          => "\t".ord,
        'UNDERLINE'    => '_'.ord,
        'UNLABELED'    => nil,
        'UP'           => $sketch.class::UP,
        'UPARROW'      => $sketch.class::UP,
        'VOLUMEDOWN'   => KeyEvent::KEYCODE_VOLUME_DOWN,
        'VOLUMEUP'     => KeyEvent::KEYCODE_VOLUME_UP,
        'WAKE'         => KeyEvent::KEYCODE_WAKEUP,
        'WEBBACK'      => $sketch.class::BACK,
        'WEBFAVORITES' => KeyEvent::KEYCODE_BOOKMARK,
        'WEBFORWARD'   => KeyEvent::KEYCODE_FORWARD,
        'WEBHOME'      => KeyEvent::KEYCODE_HOME,
        'WEBREFRESH'   => nil,
        'WEBSEARCH'    => KeyEvent::KEYCODE_SEARCH,
        'WEBSTOP'      => nil,
        'YEN'          => "\\".ord,
      }
      DXRubyRP5.constants.grep(/^K_/).each do |k|
        begin
          name = k.to_s.sub(/^K_/, '')
          value = replace_table.key?(name) ? replace_table[name] : name.downcase.ord
          RP5_KEY_TABLE[DXRubyRP5.const_get(k)] = value
        rescue NameError => e
          raise e
        end
      end
      private_constant :RP5_KEY_TABLE

      DXRUBY_KEY_TABLE = RP5_KEY_TABLE.invert
      private_constant :DXRUBY_KEY_TABLE

      # TODO: check dxruby supported keycode
      def rp5_key_press?(key)
        if $sketch.key_pressed?
          if $sketch.key == $sketch.class::CODED
            return $sketch.key_code == key
          else
            return $sketch.key == key.chr
          end
        end
        return false
      end

      def rp5_pad_slider_value(dir)
        return 0
      end

      def rp5_pad_pushed?(button_code)
        return false
      end

      def rp5_pad_pressed?(button_code)
        return false
      end

      def to_rp5_key(key_code)
        return RP5_KEY_TABLE[key_code]
      end

      def to_dxruby_key(key_code)
        return DXRUBY_KEY_TABLE[key_code]
      end

      def key_pressed(key, key_code)
        @pressed_keys ||= []
        if key == $sketch.class::CODED
          dkey = to_dxruby_key(key_code)
        else
          dkey = to_dxruby_key(key)
        end
        return if @pressed_keys.include?(dkey)
        @pressed_keys << dkey
      end

      def key_pushed(key, key_code)
        @pushed_keys ||= []
        @checked_keys ||= []
        if key == $sketch.class::CODED
          dkey = to_dxruby_key(key_code)
        else
          dkey = to_dxruby_key(key)
        end
        return if @checked_keys.include?(dkey)
        @pushed_keys << dkey
      end

      def key_released(key, key_code)
        return if @pressed_keys.nil?
        if key == $sketch.class::CODED
          dkey = to_dxruby_key(key_code)
        else
          dkey = to_dxruby_key(key)
        end
        @pressed_keys.delete(dkey)
        @checked_keys.delete(dkey)
      end

      def mouse_pushed
        @mouse_pushed_count = 1
      end

      def mouse_released
        @mouse_released_count = 1
      end

      def handle_key_events
        if @mouse_pushed_count
          @mouse_pushed_count -= 1
          @mouse_pushed_count = nil if @mouse_pushed_count < 0
        end

        if @mouse_released_count
          @mouse_released_count -= 1
          @mouse_released_count = nil if @mouse_released_count < 0
        end

        return if @pushed_keys.nil?
        @checked_keys |= @pushed_keys
        @pushed_keys.clear

        # for key repeat
        # TODO: use `wait`
        if @repeat_interval &&
            $sketch.field_frame_count % @repeat_interval == 0
          @pushed_keys |= @pressed_keys
          @checked_keys -= @pressed_keys
        end
      end
    end
  end
end
