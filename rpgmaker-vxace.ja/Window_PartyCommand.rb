#
# バトル画面で、戦うか逃げるかを選択するウィンドウです。
#

class Window_PartyCommand < Window_Command
  #
  # オブジェクト初期化
  #
  #
  def initialize
    super(0, 0)
    self.openness = 0
    deactivate
  end
  #
  # ウィンドウ幅の取得
  #
  #
  def window_width
    return 128
  end
  #
  # 表示行数の取得
  #
  #
  def visible_line_number
    return 4
  end
  #
  # コマンドリストの作成
  #
  #
  def make_command_list
    add_command(Vocab::fight,  :fight)
    add_command(Vocab::escape, :escape, BattleManager.can_escape?)
  end
  #
  # セットアップ
  #
  #
  def setup
    clear_command_list
    make_command_list
    refresh
    select(0)
    activate
    open
  end
end