#
# コモンイベントを扱うクラスです。並列処理イベントを実行する機能を持っていま
# す。このクラスは Game_Map クラス（$game_map）の内部で使用されます。
#

class Game_CommonEvent
  #
  # オブジェクト初期化
  #
  #
  def initialize(common_event_id)
    @event = $data_common_events[common_event_id]
    refresh
  end
  #
  # リフレッシュ
  #
  #
  def refresh
    if active?
      @interpreter ||= Game_Interpreter.new
    else
      @interpreter = nil
    end
  end
  #
  # 有効状態判定
  #
  #
  def active?
    @event.parallel? && $game_switches[@event.switch_id]
  end
  #
  # フレーム更新
  #
  #
  def update
    if @interpreter
      @interpreter.setup(@event.list) unless @interpreter.running?
      @interpreter.update
    end
  end
end
