#
# 装備画面で、装備変更の候補となるアイテムの一覧を表示するウィンドウです。
#

class Window_EquipItem < Window_ItemList
  #
  # 公開インスタンス変数
  #
  #
  attr_reader   :status_window            # ステータスウィンドウ
  #
  # オブジェクト初期化
  #
  #
  def initialize(x, y, width, height)
    super
    @actor = nil
    @slot_id = 0
  end
  #
  # アクターの設定
  #
  #
  def actor=(actor)
    return if @actor == actor
    @actor = actor
    refresh
    self.oy = 0
  end
  #
  # 装備スロット ID の設定
  #
  #
  def slot_id=(slot_id)
    return if @slot_id == slot_id
    @slot_id = slot_id
    refresh
    self.oy = 0
  end
  #
  # アイテムをリストに含めるかどうか
  #
  #
  def include?(item)
    return true if item == nil
    return false unless item.is_a?(RPG::EquipItem)
    return false if @slot_id < 0
    return false if item.etype_id != @actor.equip_slots[@slot_id]
    return @actor.equippable?(item)
  end
  #
  # アイテムを許可状態で表示するかどうか
  #
  #
  def enable?(item)
    return true
  end
  #
  # 前回の選択位置を復帰
  #
  #
  def select_last
  end
  #
  # ステータスウィンドウの設定
  #
  #
  def status_window=(status_window)
    @status_window = status_window
    call_update_help
  end
  #
  # ヘルプテキスト更新
  #
  #
  def update_help
    super
    if @actor && @status_window
      temp_actor = Marshal.load(Marshal.dump(@actor))
      temp_actor.force_change_equip(@slot_id, item)
      @status_window.set_temp_actor(temp_actor)
    end
  end
end
