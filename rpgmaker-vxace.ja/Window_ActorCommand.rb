#
# バトル画面で、アクターの行動を選択するウィンドウです。
#

class Window_ActorCommand < Window_Command
  #
  # オブジェクト初期化
  #
  #
  def initialize
    super(0, 0)
    self.openness = 0
    deactivate
    @actor = nil
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
    return unless @actor
    add_attack_command
    add_skill_commands
    add_guard_command
    add_item_command
  end
  #
  # 攻撃コマンドをリストに追加
  #
  #
  def add_attack_command
    add_command(Vocab::attack, :attack, @actor.attack_usable?)
  end
  #
  # スキルコマンドをリストに追加
  #
  #
  def add_skill_commands
    @actor.added_skill_types.sort.each do |stype_id|
      name = $data_system.skill_types[stype_id]
      add_command(name, :skill, true, stype_id)
    end
  end
  #
  # 防御コマンドをリストに追加
  #
  #
  def add_guard_command
    add_command(Vocab::guard, :guard, @actor.guard_usable?)
  end
  #
  # アイテムコマンドをリストに追加
  #
  #
  def add_item_command
    add_command(Vocab::item, :item)
  end
  #
  # セットアップ
  #
  #
  def setup(actor)
    @actor = actor
    clear_command_list
    make_command_list
    refresh
    select(0)
    activate
    open
  end
end
