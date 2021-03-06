#encoding:utf-8
#
# 管理敵人的類。本類在 Game_Troop 類 ($game_troop) 的內定使用。
#

class Game_Enemy < Game_Battler
  #
  # 定義案例變量
  #
  #
  attr_reader   :index                    # 敵群內的索引
  attr_reader   :enemy_id                 # 敵人 ID
  attr_reader   :original_name            # 原名
  attr_accessor :letter                   # 名字後附加的字母
  attr_accessor :plural                   # 復數出現的標志
  attr_accessor :screen_x                 # 戰鬥畫面 X 坐標
  attr_accessor :screen_y                 # 戰鬥畫面 Y 坐標
  #
  # 初始化物件
  #
  #
  def initialize(index, enemy_id)
    super()
    @index = index
    @enemy_id = enemy_id
    enemy = $data_enemies[@enemy_id]
    @original_name = enemy.name
    @letter = ""
    @plural = false
    @screen_x = 0
    @screen_y = 0
    @battler_name = enemy.battler_name
    @battler_hue = enemy.battler_hue
    @hp = mhp
    @mp = mmp
  end
  #
  # 判定是否敵人
  #
  #
  def enemy?
    return true
  end
  #
  # 取得隊友單位
  #
  #
  def friends_unit
    $game_troop
  end
  #
  # 取得敵人單位
  #
  #
  def opponents_unit
    $game_party
  end
  #
  # 取得敵人案例
  #
  #
  def enemy
    $data_enemies[@enemy_id]
  end
  #
  # 以數組模式取得擁有特性所有案例
  #
  #
  def feature_objects
    super + [enemy]
  end
  #
  # 取得顯示名稱
  #
  #
  def name
    @original_name + (@plural ? letter : "")
  end
  #
  # 取得普通能力的基礎值
  #
  #
  def param_base(param_id)
    enemy.params[param_id]
  end
  #
  # 取得經驗值
  #
  #
  def exp
    enemy.exp
  end
  #
  # 取得金錢
  #
  #
  def gold
    enemy.gold
  end
  #
  # 生成物品數組
  #
  #
  def make_drop_items
    enemy.drop_items.inject([]) do |r, di|
      if di.kind > 0 && rand * di.denominator < drop_item_rate
        r.push(item_object(di.kind, di.data_id))
      else
        r
      end
    end
  end
  #
  # 取得物品掉率的倍率
  #
  #
  def drop_item_rate
    $game_party.drop_item_double? ? 2 : 1
  end
  #
  # 取得物品案例
  #
  #
  def item_object(kind, data_id)
    return $data_items  [data_id] if kind == 1
    return $data_weapons[data_id] if kind == 2
    return $data_armors [data_id] if kind == 3
    return nil
  end
  #
  # 是否使用精靈
  #
  #
  def use_sprite?
    return true
  end
  #
  # 取得戰鬥畫面 Z 坐標
  #
  #
  def screen_z
    return 100
  end
  #
  # 執行傷害效果
  #
  #
  def perform_damage_effect
    @sprite_effect_type = :blink
    Sound.play_enemy_damage
  end
  #
  # 執行人物倒下的效果
  #
  #
  def perform_collapse_effect
    case collapse_type
    when 0
      @sprite_effect_type = :collapse
      Sound.play_enemy_collapse
    when 1
      @sprite_effect_type = :boss_collapse
      Sound.play_boss_collapse1
    when 2
      @sprite_effect_type = :instant_collapse
    end
  end
  #
  # 變身
  #
  #
  def transform(enemy_id)
    @enemy_id = enemy_id
    if enemy.name != @original_name
      @original_name = enemy.name
      @letter = ""
      @plural = false
    end
    @battler_name = enemy.battler_name
    @battler_hue = enemy.battler_hue
    refresh
    make_actions unless @actions.empty?
  end
  #
  # 判定行動條件是否符合
  #
  # action : RPG::Enemy::Action
  #
  def conditions_met?(action)
    method_table = {
      1 => :conditions_met_turns?,
      2 => :conditions_met_hp?,
      3 => :conditions_met_mp?,
      4 => :conditions_met_state?,
      5 => :conditions_met_party_level?,
      6 => :conditions_met_switch?,
    }
    method_name = method_table[action.condition_type]
    if method_name
      send(method_name, action.condition_param1, action.condition_param2)
    else
      true
    end
  end
  #
  # 判定行動條件是否符合“回合數”
  #
  #
  def conditions_met_turns?(param1, param2)
    n = $game_troop.turn_count
    if param2 == 0
      n == param1
    else
      n > 0 && n >= param1 && n % param2 == param1 % param2
    end
  end
  #
  # 判定行動條件是否符合“HP”
  #
  #
  def conditions_met_hp?(param1, param2)
    hp_rate >= param1 && hp_rate <= param2
  end
  #
  # 判定行動條件是否符合“MP”
  #
  #
  def conditions_met_mp?(param1, param2)
    mp_rate >= param1 && mp_rate <= param2
  end
  #
  # 判定行動條件是否符合“狀態”
  #
  #
  def conditions_met_state?(param1, param2)
    state?(param1)
  end
  #
  # 判定行動條件是否符合“隊伍等級”
  #
  #
  def conditions_met_party_level?(param1, param2)
    $game_party.highest_level >= param1
  end
  #
  # 判定行動條件是否符合“開關”
  #
  #
  def conditions_met_switch?(param1, param2)
    $game_switches[param1]
  end
  #
  # 判定在當前狀況下戰鬥行動是否有效
  #
  # action : RPG::Enemy::Action
  #
  def action_valid?(action)
    conditions_met?(action) && usable?($data_skills[action.skill_id])
  end
  #
  # 隨機選擇戰鬥行動
  #
  # action_list : RPG::Enemy::Action 的數組
  # rating_zero : 作為零值的標准
  #
  def select_enemy_action(action_list, rating_zero)
    sum = action_list.inject(0) {|r, a| r += a.rating - rating_zero }
    return nil if sum <= 0
    value = rand(sum)
    action_list.each do |action|
      return action if value < action.rating - rating_zero
      value -= action.rating - rating_zero
    end
  end
  #
  # 生成戰鬥行動
  #
  #
  def make_actions
    super
    return if @actions.empty?
    action_list = enemy.actions.select {|a| action_valid?(a) }
    return if action_list.empty?
    rating_max = action_list.collect {|a| a.rating }.max
    rating_zero = rating_max - 3
    action_list.reject! {|a| a.rating <= rating_zero }
    @actions.each do |action|
      action.set_enemy_action(select_enemy_action(action_list, rating_zero))
    end
  end
end
