#
# フォロワーの配列のラッパーです。このクラスは Game_Player クラスの内部で使
# 用されます。
#

class Game_Followers
  #
  # 公開インスタンス変数
  #
  #
  attr_accessor :visible                  # 可視状態 (真なら隊列歩行 ON)
  #
  # オブジェクト初期化
  #
  # leader : 先頭のキャラクター
  #
  def initialize(leader)
    @visible = $data_system.opt_followers
    @gathering = false                    # 集合処理中フラグ
    @data = []
    @data.push(Game_Follower.new(1, leader))
    (2...$game_party.max_battle_members).each do |index|
      @data.push(Game_Follower.new(index, @data[-1]))
    end
  end
  #
  # フォロワーの取得
  #
  #
  def [](index)
    @data[index]
  end
  #
  # イテレータ
  #
  #
  def each
    @data.each {|follower| yield follower } if block_given?
  end
  #
  # イテレータ（逆順）
  #
  #
  def reverse_each
    @data.reverse.each {|follower| yield follower } if block_given?
  end
  #
  # リフレッシュ
  #
  #
  def refresh
    each {|follower| follower.refresh }
  end
  #
  # フレーム更新
  #
  #
  def update
    if gathering?
      move unless moving? || moving?
      @gathering = false if gather?
    end
    each {|follower| follower.update }
  end
  #
  # 移動
  #
  #
  def move
    reverse_each {|follower| follower.chase_preceding_character }
  end
  #
  # 同期
  #
  #
  def synchronize(x, y, d)
    each do |follower|
      follower.moveto(x, y)
      follower.set_direction(d)
    end
  end
  #
  # 集合
  #
  #
  def gather
    @gathering = true
  end
  #
  # 集合中判定
  #
  #
  def gathering?
    @gathering
  end
  #
  # 表示中のフォロワーの配列を取得
  #
  #
  def visible_folloers
    @data.select {|follower| follower.visible? }
  end
  #
  # 移動中判定
  #
  #
  def moving?
    visible_folloers.any? {|follower| follower.moving? }
  end
  #
  # 集合済み判定
  #
  #
  def gather?
    visible_folloers.all? {|follower| follower.gather? }
  end
  #
  # 衝突判定
  #
  #
  def collide?(x, y)
    visible_folloers.any? {|follower| follower.pos?(x, y) }
  end
end
