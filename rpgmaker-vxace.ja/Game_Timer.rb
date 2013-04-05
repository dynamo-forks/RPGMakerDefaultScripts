#
# タイマーを扱うクラスです。このクラスのインスタンスは $game_timer で参照さ
# れます。
#

class Game_Timer
  #
  # オブジェクト初期化
  #
  #
  def initialize
    @count = 0
    @working = false
  end
  #
  # フレーム更新
  #
  #
  def update
    if @working && @count > 0
      @count -= 1
      on_expire if @count == 0
    end
  end
  #
  # 始動
  #
  #
  def start(count)
    @count = count
    @working = true
  end
  #
  # 停止
  #
  #
  def stop
    @working = false
  end
  #
  # 作動中判定
  #
  #
  def working?
    @working
  end
  #
  # 秒の取得
  #
  #
  def sec
    @count / Graphics.frame_rate
  end
  #
  # タイマーが 0 になったときの処理
  #
  #
  def on_expire
    BattleManager.abort
  end
end
