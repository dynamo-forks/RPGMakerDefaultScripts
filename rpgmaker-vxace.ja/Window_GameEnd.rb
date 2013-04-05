#
# ゲーム終了画面で、タイトルへ／シャットダウンを選択するウィンドウです。
#

class Window_GameEnd < Window_Command
  #
  # オブジェクト初期化
  #
  #
  def initialize
    super(0, 0)
    update_placement
    self.openness = 0
    open
  end
  #
  # ウィンドウ幅の取得
  #
  #
  def window_width
    return 160
  end
  #
  # ウィンドウ位置の更新
  #
  #
  def update_placement
    self.x = (Graphics.width - width) / 2
    self.y = (Graphics.height - height) / 2
  end
  #
  # コマンドリストの作成
  #
  #
  def make_command_list
    add_command(Vocab::to_title, :to_title)
    add_command(Vocab::shutdown, :shutdown)
    add_command(Vocab::cancel,   :cancel)
  end
end
