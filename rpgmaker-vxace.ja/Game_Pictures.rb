#
# ピクチャの配列のラッパーです。このクラスは Game_Screen クラスの内部で使用
# されます。マップ画面のピクチャとバトル画面のピクチャは別々に扱われます。
#

class Game_Pictures
  #
  # オブジェクト初期化
  #
  #
  def initialize
    @data = []
  end
  #
  # ピクチャの取得
  #
  #
  def [](number)
    @data[number] ||= Game_Picture.new(number)
  end
  #
  # イテレータ
  #
  #
  def each
    @data.compact.each {|picture| yield picture } if block_given?
  end
end
