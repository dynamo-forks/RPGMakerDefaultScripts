#
# セルフスイッチを扱うクラスです。組み込みクラス Hash のラッパーです。このク
# ラスのインスタンスは $game_self_switches で参照されます。
#

class Game_SelfSwitches
  #
  # オブジェクト初期化
  #
  #
  def initialize
    @data = {}
  end
  #
  # セルフスイッチの取得
  #
  #
  def [](key)
    @data[key] == true
  end
  #
  # セルフスイッチの設定
  #
  # value : ON (true) / OFF (false)
  #
  def []=(key, value)
    @data[key] = value
    on_change
  end
  #
  # セルフスイッチの設定時の処理
  #
  #
  def on_change
    $game_map.need_refresh = true
  end
end
