#
# パーティを扱うクラスです。所持金やアイテムなどの情報が含まれます。このクラ
# スのインスタンスは $game_party で参照されます。
#

class Game_Party < Game_Unit
  #
  # 定数
  #
  #
  ABILITY_ENCOUNTER_HALF    = 0           # エンカウント半減
  ABILITY_ENCOUNTER_NONE    = 1           # エンカウント無効
  ABILITY_CANCEL_SURPRISE   = 2           # 不意打ち無効
  ABILITY_RAISE_PREEMPTIVE  = 3           # 先制攻撃率アップ
  ABILITY_GOLD_DOUBLE       = 4           # 獲得金額二倍
  ABILITY_DROP_ITEM_DOUBLE  = 5           # アイテム入手率二倍
  #
  # 公開インスタンス変数
  #
  #
  attr_reader   :gold                     # 所持金
  attr_reader   :steps                    # 歩数
  attr_reader   :last_item                # カーソル記憶用 : アイテム
  #
  # オブジェクト初期化
  #
  #
  def initialize
    super
    @gold = 0
    @steps = 0
    @last_item = Game_BaseItem.new
    @menu_actor_id = 0
    @target_actor_id = 0
    @actors = []
    init_all_items
  end
  #
  # 全アイテムリストの初期化
  #
  #
  def init_all_items
    @items = {}
    @weapons = {}
    @armors = {}
  end
  #
  # 存在判定
  #
  #
  def exists
    !@actors.empty?
  end
  #
  # メンバーの取得
  #
  #
  def members
    in_battle ? battle_members : all_members
  end
  #
  # 全メンバーの取得
  #
  #
  def all_members
    @actors.collect {|id| $game_actors[id] }
  end
  #
  # バトルメンバーの取得
  #
  #
  def battle_members
    all_members[0, max_battle_members].select {|actor| actor.exist? }
  end
  #
  # バトルメンバーの最大数を取得
  #
  #
  def max_battle_members
    return 4
  end
  #
  # リーダーの取得
  #
  #
  def leader
    battle_members[0]
  end
  #
  # アイテムオブジェクトの配列取得 
  #
  #
  def items
    @items.keys.sort.collect {|id| $data_items[id] }
  end
  #
  # 武器オブジェクトの配列取得 
  #
  #
  def weapons
    @weapons.keys.sort.collect {|id| $data_weapons[id] }
  end
  #
  # 防具オブジェクトの配列取得 
  #
  #
  def armors
    @armors.keys.sort.collect {|id| $data_armors[id] }
  end
  #
  # 全ての装備品オブジェクトの配列取得
  #
  #
  def equip_items
    weapons + armors
  end
  #
  # 全てのアイテムオブジェクトの配列取得
  #
  #
  def all_items
    items + equip_items
  end
  #
  # アイテムのクラスに対応するコンテナオブジェクトを取得
  #
  #
  def item_container(item_class)
    return @items   if item_class == RPG::Item
    return @weapons if item_class == RPG::Weapon
    return @armors  if item_class == RPG::Armor
    return nil
  end
  #
  # 初期パーティのセットアップ
  #
  #
  def setup_starting_members
    @actors = $data_system.party_members.clone
  end
  #
  # パーティ名の取得
  #
  # 一人ならそのアクターの名前、複数なら "○○たち" を返す。
  #
  def name
    return ""           if battle_members.size == 0
    return leader.name  if battle_members.size == 1
    return sprintf(Vocab::PartyName, leader.name)
  end
  #
  # 戦闘テストのセットアップ
  #
  #
  def setup_battle_test
    setup_battle_test_members
    setup_battle_test_items
  end
  #
  # 戦闘テスト用パーティのセットアップ
  #
  #
  def setup_battle_test_members
    $data_system.test_battlers.each do |battler|
      actor = $game_actors[battler.actor_id]
      actor.change_level(battler.level, false)
      actor.init_equips(battler.equips)
      actor.recover_all
      add_actor(actor.id)
    end
  end
  #
  # 戦闘テスト用アイテムのセットアップ
  #
  #
  def setup_battle_test_items
    $data_items.each do |item|
      gain_item(item, max_item_number(item)) if item && !item.name.empty?
    end
  end
  #
  # パーティメンバーの最も高いレベルの取得
  #
  #
  def highest_level
    lv = members.collect {|actor| actor.level }.max
  end
  #
  # アクターを加える
  #
  #
  def add_actor(actor_id)
    @actors.push(actor_id) unless @actors.include?(actor_id)
    $game_player.refresh
    $game_map.need_refresh = true
  end
  #
  # アクターを外す
  #
  #
  def remove_actor(actor_id)
    @actors.delete(actor_id)
    $game_player.refresh
    $game_map.need_refresh = true
  end
  #
  # 所持金の増加（減少）
  #
  #
  def gain_gold(amount)
    @gold = [[@gold + amount, 0].max, max_gold].min
  end
  #
  # 所持金の減少
  #
  #
  def lose_gold(amount)
    gain_gold(-amount)
  end
  #
  # 所持金の最大値を取得
  #
  #
  def max_gold
    return 99999999
  end
  #
  # 歩数増加
  #
  #
  def increase_steps
    @steps += 1
  end
  #
  # アイテムの所持数取得
  #
  #
  def item_number(item)
    container = item_container(item.class)
    container ? container[item.id] || 0 : 0
  end
  #
  # アイテムの最大所持数取得
  #
  #
  def max_item_number(item)
    return 99
  end
  #
  # アイテムを最大まで所持しているか判定
  #
  #
  def item_max?(item)
    item_number(item) >= max_item_number(item)
  end
  #
  # アイテムの所持判定
  #
  # include_equip : 装備品も含める
  #
  def has_item?(item, include_equip = false)
    return true if item_number(item) > 0
    return include_equip ? members_equip_include?(item) : false
  end
  #
  # 指定アイテムがメンバーの装備品に含まれているかを判定
  #
  #
  def members_equip_include?(item)
    members.any? {|actor| actor.equips.include?(item) }
  end
  #
  # アイテムの増加（減少）
  #
  # include_equip : 装備品も含める
  #
  def gain_item(item, amount, include_equip = false)
    container = item_container(item.class)
    return unless container
    last_number = item_number(item)
    new_number = last_number + amount
    container[item.id] = [[new_number, 0].max, max_item_number(item)].min
    container.delete(item.id) if container[item.id] == 0
    if include_equip && new_number < 0
      discard_members_equip(item, -new_number)
    end
    $game_map.need_refresh = true
  end
  #
  # メンバーの装備品を破棄する
  #
  #
  def discard_members_equip(item, amount)
    n = amount
    members.each do |actor|
      while n > 0 && actor.equips.include?(item)
        actor.discard_equip(item)
        n -= 1
      end
    end
  end
  #
  # アイテムの減少
  #
  # include_equip : 装備品も含める
  #
  def lose_item(item, amount, include_equip = false)
    gain_item(item, -amount, include_equip)
  end
  #
  # アイテムの消耗
  #
  # 指定されたオブジェクトが消耗アイテムであれば、所持数を 1 減らす。
  #
  def consume_item(item)
    lose_item(item, 1) if item.is_a?(RPG::Item) && item.consumable
  end
  #
  # スキル／アイテムの使用可能判定
  #
  #
  def usable?(item)
    members.any? {|actor| actor.usable?(item) }
  end
  #
  # 戦闘時コマンド入力可能判定
  #
  #
  def inputable?
    members.any? {|actor| actor.inputable? }
  end
  #
  # 全滅判定
  #
  #
  def all_dead?
    super && ($game_party.in_battle || members.size > 0)
  end
  #
  # プレイヤーが 1 歩動いたときの処理
  #
  #
  def on_player_walk
    members.each {|actor| actor.on_player_walk }
  end
  #
  # メニュー画面で選択中のアクターを取得
  #
  #
  def menu_actor
    $game_actors[@menu_actor_id] || members[0]
  end
  #
  # メニュー画面で選択中のアクターを設定
  #
  #
  def menu_actor=(actor)
    @menu_actor_id = actor.id
  end
  #
  # メニュー画面で次のアクターを選択
  #
  #
  def menu_actor_next
    index = members.index(menu_actor) || -1
    index = (index + 1) % members.size
    self.menu_actor = members[index]
  end
  #
  # メニュー画面で前のアクターを選択
  #
  #
  def menu_actor_prev
    index = members.index(menu_actor) || 1
    index = (index + members.size - 1) % members.size
    self.menu_actor = members[index]
  end
  #
  # スキル／アイテムの使用対象となったアクターを取得
  #
  #
  def target_actor
    $game_actors[@target_actor_id] || members[0]
  end
  #
  # スキル／アイテムの使用対象となったアクターを設定
  #
  #
  def target_actor=(actor)
    @target_actor_id = actor.id
  end
  #
  # 順序入れ替え
  #
  #
  def swap_order(index1, index2)
    @actors[index1], @actors[index2] = @actors[index2], @actors[index1]
    $game_player.refresh
  end
  #
  # セーブファイル表示用のキャラクター画像情報
  #
  #
  def characters_for_savefile
    battle_members.collect do |actor|
      [actor.character_name, actor.character_index]
    end
  end
  #
  # パーティ能力判定
  #
  #
  def party_ability(ability_id)
    battle_members.any? {|actor| actor.party_ability(ability_id) }
  end
  #
  # エンカウント半減？
  #
  #
  def encounter_half?
    party_ability(ABILITY_ENCOUNTER_HALF)
  end
  #
  # エンカウント無効？
  #
  #
  def encounter_none?
    party_ability(ABILITY_ENCOUNTER_NONE)
  end
  #
  # 不意打ち無効？
  #
  #
  def cancel_surprise?
    party_ability(ABILITY_CANCEL_SURPRISE)
  end
  #
  # 先制攻撃率アップ？
  #
  #
  def raise_preemptive?
    party_ability(ABILITY_RAISE_PREEMPTIVE)
  end
  #
  # 獲得金額二倍？
  #
  #
  def gold_double?
    party_ability(ABILITY_GOLD_DOUBLE)
  end
  #
  # アイテム入手率二倍？
  #
  #
  def drop_item_double?
    party_ability(ABILITY_DROP_ITEM_DOUBLE)
  end
  #
  # 先制攻撃の確率計算
  #
  #
  def rate_preemptive(troop_agi)
    (agi >= troop_agi ? 0.05 : 0.03) * (raise_preemptive? ? 4 : 1)
  end
  #
  # 不意打ちの確率計算
  #
  #
  def rate_surprise(troop_agi)
    cancel_surprise? ? 0 : (agi >= troop_agi ? 0.03 : 0.05)
  end
end
