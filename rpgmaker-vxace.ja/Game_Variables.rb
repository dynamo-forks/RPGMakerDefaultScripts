#
# 変数を扱うクラスです。組み込みクラス Array のラッパーです。このクラスのイ
# ンスタンスは $game_variables で参照されます。
#

class Game_Variables
  #
  # オブジェクト初期化
  #
  #
  def initialize
    @data = []
  end
  #
  # 変数の取得
  #
  #
  def [](variable_id)
    @data[variable_id] || 0
  end
  #
  # 変数の設定
  #
  #
  def []=(variable_id, value)
    @data[variable_id] = value
    on_change
  end
  #
  # 変数の設定時の処理
  #
  #
  def on_change
    $game_map.need_refresh = true
  end
end
