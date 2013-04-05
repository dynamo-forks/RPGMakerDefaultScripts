#
# メニュー画面で表示するコマンドウィンドウです。
#

class Window_MenuCommand < Window_Command
  #
  # コマンド選択位置の初期化（クラスメソッド）
  #
  #
  def self.init_command_position
    @@last_command_symbol = nil
  end
  #
  # オブジェクト初期化
  #
  #
  def initialize
    super(0, 0)
    select_last
  end
  #
  # ウィンドウ幅の取得
  #
  #
  def window_width
    return 160
  end
  #
  # 表示行数の取得
  #
  #
  def visible_line_number
    item_max
  end
  #
  # コマンドリストの作成
  #
  #
  def make_command_list
    add_main_commands
    add_formation_command
    add_original_commands
    add_save_command
    add_game_end_command
  end
  #
  # 主要コマンドをリストに追加
  #
  #
  def add_main_commands
    add_command(Vocab::item,   :item,   main_commands_enabled)
    add_command(Vocab::skill,  :skill,  main_commands_enabled)
    add_command(Vocab::equip,  :equip,  main_commands_enabled)
    add_command(Vocab::status, :status, main_commands_enabled)
  end
  #
  # 並び替えをコマンドリストに追加
  #
  #
  def add_formation_command
    add_command(Vocab::formation, :formation, formation_enabled)
  end
  #
  # 独自コマンドの追加用
  #
  #
  def add_original_commands
  end
  #
  # セーブをコマンドリストに追加
  #
  #
  def add_save_command
    add_command(Vocab::save, :save, save_enabled)
  end
  #
  # ゲーム終了をコマンドリストに追加
  #
  #
  def add_game_end_command
    add_command(Vocab::game_end, :game_end)
  end
  #
  # 主要コマンドの有効状態を取得
  #
  #
  def main_commands_enabled
    $game_party.exists
  end
  #
  # 並び替えの有効状態を取得
  #
  #
  def formation_enabled
    $game_party.members.size >= 2 && !$game_system.formation_disabled
  end
  #
  # セーブの有効状態を取得
  #
  #
  def save_enabled
    !$game_system.save_disabled
  end
  #
  # 決定ボタンが押されたときの処理
  #
  #
  def process_ok
    @@last_command_symbol = current_symbol
    super
  end
  #
  # 前回の選択位置を復帰
  #
  #
  def select_last
    select_symbol(@@last_command_symbol)
  end
end
