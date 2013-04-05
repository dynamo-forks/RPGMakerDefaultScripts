#
# スキル画面で、スキル使用者のステータスを表示するウィンドウです。
#

class Window_SkillStatus < Window_Base
  #
  # オブジェクト初期化
  #
  #
  def initialize(x, y)
    super(x, y, window_width, fitting_height(4))
    @actor = nil
  end
  #
  # ウィンドウ幅の取得
  #
  #
  def window_width
    Graphics.width - 160
  end
  #
  # アクターの設定
  #
  #
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
  end
  #
  # リフレッシュ
  #
  #
  def refresh
    contents.clear
    return unless @actor
    draw_actor_face(@actor, 0, 0)
    draw_actor_simple_status(@actor, 108, line_height / 2)
  end
end
