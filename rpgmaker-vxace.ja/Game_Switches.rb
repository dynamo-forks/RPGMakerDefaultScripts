#
# スイッチを扱うクラスです。組み込みクラス Array のラッパーです。このクラス
# のインスタンスは $game_switches で参照されます。
#

class Game_Switches
  #
  # オブジェクト初期化
  #
  #
  def initialize
    @data = []
  end
  #
  # スイッチの取得
  #
  #
  def [](switch_id)
    @data[switch_id] || false
  end
  #
  # スイッチの設定
  #
  # value : ON (true) / OFF (false)
  #
  def []=(switch_id, value)
    @data[switch_id] = value
    on_change
  end
  #
  # スイッチの設定時の処理
  #
  #
  def on_change
    $game_map.need_refresh = true
  end
end
