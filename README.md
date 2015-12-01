# DXRuby Ruboto Processing

DXRuby用のRubyスクリプトをAndroid上で動かしてみる試み。

## Getting Started

rubotoをインストールし`rake`を使ったapkのビルドが可能な状態にする。

このリポジトリを`git clone`する。

```
  $ git clone https://github.com/hoshi-sano/dxruby-ruboto-processing.git
  $ cd dxruby-ruboto-processing
  $ android update project -p .
```

ソースコードを配置する。
例えば以下のような`my_game.rb`と`my_game/sushi.rb`というファイルがあった場合、

```ruby
# my_game.rb

require "dxruby"
require "my_game/sushi"

sushi_image = Image.load("image/sushi.png")
sushi = MyGame::Sushi.new(100, 100, sushi_image)

Window.loop do
  sushi.draw
end
```

```ruby
# my_game/sushi.rb

module MyGame
  class Sushi < ::Sprite
  end
end
```

以下のようにファイルを配置する。
`Image.load`などで指定するファイルのパスは`assets`ディレクトリからの相対パスとなる点に注意。

```
.
├── assets
│   └── image
│       └── sushi.png
└── src
    ├── my_game.rb
    └── my_game
         └── sushi.rb
```

`res/values/strings.xml`にエントリーポイントを指定する。
上記の例の場合、以下の`main.rb`の箇所を`my_game.rb`に変更する。

```xml
<?xml version='1.0' encoding='UTF-8'?>
<resources>
    <string name='app_name'>
        DXRuby Android Test
    </string>
    <string name='dxruby_entry_point'>
        main.rb
    </string>
</resources>
```

ビルドして実機、またはエミュレータの端末にインストールする。

```
  $ rake build
  $ rake install
```
