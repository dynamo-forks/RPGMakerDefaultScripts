#
# ユニットを扱うクラスです。このクラスは Game_Party クラスと Game_Troop クラ
# スのスーパークラスとして使用されます。
#

class Game_Unit
  #
  # 公開インスタンス変数
  #
  #
  attr_reader   :in_battle                # 戦闘中フラグ
  #
  # オブジェクト初期化
  #
  #
  def initialize
    @in_battle = false
  end
  #
  # メンバーの取得
  #
  #
  def members
    return []
  end
  #
  # 生存しているメンバーの配列取得
  #
  #
  def alive_members
    members.select {|member| member.alive? }
  end
  #
  # 戦闘不能のメンバーの配列取得
  #
  #
  def dead_members
    members.select {|member| member.dead? }
  end
  #
  # 行動可能なメンバーの配列取得
  #
  #
  def movable_members
    members.select {|member| member.movable? }
  end
  #
  # 全員の戦闘行動クリア
  #
  #
  def clear_actions
    members.each {|member| member.clear_actions }
  end
  #
  # 敏捷性の平均値を計算
  #
  #
  def agi
    return 1 if members.size == 0
    members.inject(0) {|r, member| r += member.agi } / members.size
  end
  #
  # 狙われ率の合計を計算
  #
  #
  def tgr_sum
    alive_members.inject(0) {|r, member| r + member.tgr }
  end
  #
  # ターゲットのランダムな決定
  #
  #
  def random_target
    tgr_rand = rand * tgr_sum
    alive_members.each do |member|
      tgr_rand -= member.tgr
      return member if tgr_rand < 0
    end
    alive_members[0]
  end
  #
  # ターゲットのランダムな決定（戦闘不能）
  #
  #
  def random_dead_target
    dead_members.empty? ? nil : dead_members[rand(dead_members.size)]
  end
  #
  # ターゲットのスムーズな決定
  #
  #
  def smooth_target(index)
    member = members[index]
    (member && member.alive?) ? member : alive_members[0]
  end
  #
  # ターゲットのスムーズな決定（戦闘不能）
  #
  #
  def smooth_dead_target(index)
    member = members[index]
    (member && member.dead?) ? member : dead_members[0]
  end
  #
  # 行動結果のクリア
  #
  #
  def clear_results
    members.select {|member| member.result.clear }
  end
  #
  # 戦闘開始処理
  #
  #
  def on_battle_start
    members.each {|member| member.on_battle_start }
    @in_battle = true
  end
  #
  # 戦闘終了処理
  #
  #
  def on_battle_end
    @in_battle = false
    members.each {|member| member.on_battle_end }
  end
  #
  # 戦闘行動の作成
  #
  #
  def make_actions
    members.each {|member| member.make_actions }
  end
  #
  # 全滅判定
  #
  #
  def all_dead?
    alive_members.empty?
  end
  #
  # 身代わりバトラーの取得
  #
  #
  def substitute_battler
    members.find {|member| member.substitute? }
  end
end
