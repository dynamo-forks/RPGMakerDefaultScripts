#
# アイテムやスキルの使用対象となるアクターを選択するウィンドウです。
#

class Window_MenuActor < Window_MenuStatus
  #
  # オブジェクト初期化
  #
  #
  def initialize
    super(0, 0)
    self.visible = false
  end
  #
  # 決定ボタンが押されたときの処理
  #
  #
  def process_ok
    $game_party.target_actor = $game_party.members[index] unless @cursor_all
    call_ok_handler
  end
  #
  # 前回の選択位置を復帰
  #
  #
  def select_last
    select($game_party.target_actor.index || 0)
  end
  #
  # アイテムのためのカーソル位置設定
  #
  #
  def select_for_item(item)
    @cursor_fix = item.for_user?
    @cursor_all = item.for_all?
    if @cursor_fix
      select($game_party.menu_actor.index)
    elsif @cursor_all
      select(0)
    else
      select_last
    end
  end
end
