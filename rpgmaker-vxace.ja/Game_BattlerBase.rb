#
# バトラーを扱う基本のクラスです。主に能力値計算のメソッドを含んでいます。こ
# のクラスは Game_Battler クラスのスーパークラスとして使用されます。
#

class Game_BattlerBase
  #
  # 定数（特徴）
  #
  #
  FEATURE_ELEMENT_RATE  = 11              # 属性有効度
  FEATURE_DEBUFF_RATE   = 12              # 弱体有効度
  FEATURE_STATE_RATE    = 13              # ステート有効度
  FEATURE_STATE_RESIST  = 14              # ステート無効化
  FEATURE_PARAM         = 21              # 通常能力値
  FEATURE_XPARAM        = 22              # 追加能力値
  FEATURE_SPARAM        = 23              # 特殊能力値
  FEATURE_ATK_ELEMENT   = 31              # 攻撃時属性
  FEATURE_ATK_STATE     = 32              # 攻撃時ステート
  FEATURE_ATK_SPEED     = 33              # 攻撃速度補正
  FEATURE_ATK_TIMES     = 34              # 攻撃追加回数
  FEATURE_STYPE_ADD     = 41              # スキルタイプ追加
  FEATURE_STYPE_SEAL    = 42              # スキルタイプ封印
  FEATURE_SKILL_ADD     = 43              # スキル追加
  FEATURE_SKILL_SEAL    = 44              # スキル封印
  FEATURE_EQUIP_WTYPE   = 51              # 武器タイプ装備
  FEATURE_EQUIP_ATYPE   = 52              # 防具タイプ装備
  FEATURE_EQUIP_FIX     = 53              # 装備固定
  FEATURE_EQUIP_SEAL    = 54              # 装備封印
  FEATURE_SLOT_TYPE     = 55              # スロットタイプ
  FEATURE_ACTION_PLUS   = 61              # 行動回数追加
  FEATURE_SPECIAL_FLAG  = 62              # 特殊フラグ
  FEATURE_COLLAPSE_TYPE = 63              # 消滅エフェクト
  FEATURE_PARTY_ABILITY = 64              # パーティ能力
  #
  # 定数（特殊フラグ）
  #
  #
  FLAG_ID_AUTO_BATTLE   = 0               # 自動戦闘
  FLAG_ID_GUARD         = 1               # 防御
  FLAG_ID_SUBSTITUTE    = 2               # 身代わり
  FLAG_ID_PRESERVE_TP   = 3               # TP持ち越し
  #
  # 定数（能力強化／弱体アイコンの開始番号）
  #
  #
  ICON_BUFF_START       = 64              # 強化（16 個）
  ICON_DEBUFF_START     = 80              # 弱体（16 個）
  #
  # 公開インスタンス変数
  #
  #
  attr_reader   :hp                       # HP
  attr_reader   :mp                       # MP
  attr_reader   :tp                       # TP
  #
  # 各種能力値の略称によるアクセスメソッド
  #
  #
  def mhp;  param(0);   end    # 最大HP          Maximum Hit Point
  def mmp;  param(1);   end    # 最大MP          Maximum Magic Point
  def atk;  param(2);   end    # 攻撃力          ATtacK power
  def def;  param(3);   end    # 防御力          DEFense power
  def mat;  param(4);   end    # 魔法力          Magic ATtack power
  def mdf;  param(5);   end    # 魔法防御        Magic DeFense power
  def agi;  param(6);   end    # 敏捷性          AGIlity
  def luk;  param(7);   end    # 運              LUcK
  def hit;  xparam(0);  end    # 命中率          HIT rate
  def eva;  xparam(1);  end    # 回避率          EVAsion rate
  def cri;  xparam(2);  end    # 会心率          CRItical rate
  def cev;  xparam(3);  end    # 会心回避率      Critical EVasion rate
  def mev;  xparam(4);  end    # 魔法回避率      Magic EVasion rate
  def mrf;  xparam(5);  end    # 魔法反射率      Magic ReFlection rate
  def cnt;  xparam(6);  end    # 反撃率          CouNTer attack rate
  def hrg;  xparam(7);  end    # HP再生率        Hp ReGeneration rate
  def mrg;  xparam(8);  end    # MP再生率        Mp ReGeneration rate
  def trg;  xparam(9);  end    # TP再生率        Tp ReGeneration rate
  def tgr;  sparam(0);  end    # 狙われ率        TarGet Rate
  def grd;  sparam(1);  end    # 防御効果率      GuaRD effect rate
  def rec;  sparam(2);  end    # 回復効果率      RECovery effect rate
  def pha;  sparam(3);  end    # 薬の知識        PHArmacology
  def mcr;  sparam(4);  end    # MP消費率        Mp Cost Rate
  def tcr;  sparam(5);  end    # TPチャージ率    Tp Charge Rate
  def pdr;  sparam(6);  end    # 物理ダメージ率  Physical Damage Rate
  def mdr;  sparam(7);  end    # 魔法ダメージ率  Magical Damage Rate
  def fdr;  sparam(8);  end    # 床ダメージ率    Floor Damage Rate
  def exr;  sparam(9);  end    # 経験獲得率      EXperience Rate
  #
  # オブジェクト初期化
  #
  #
  def initialize
    @hp = @mp = @tp = 0
    @hidden = false
    clear_param_plus
    clear_states
    clear_buffs
  end
  #
  # 能力値に加算する値をクリア
  #
  #
  def clear_param_plus
    @param_plus = [0] * 8
  end
  #
  # ステート情報をクリア
  #
  #
  def clear_states
    @states = []
    @state_turns = {}
    @state_steps = {}
  end
  #
  # ステートの消去
  #
  #
  def erase_state(state_id)
    @states.delete(state_id)
    @state_turns.delete(state_id)
    @state_steps.delete(state_id)
  end
  #
  # 能力強化情報をクリア
  #
  #
  def clear_buffs
    @buffs = Array.new(8) { 0 }
    @buff_turns = {}
  end
  #
  # ステートの検査
  #
  #
  def state?(state_id)
    @states.include?(state_id)
  end
  #
  # 戦闘不能ステートの検査
  #
  #
  def death_state?
    state?(death_state_id)
  end
  #
  # 戦闘不能のステート ID を取得
  #
  #
  def death_state_id
    return 1
  end
  #
  # 現在のステートをオブジェクトの配列で取得
  #
  #
  def states
    @states.collect {|id| $data_states[id] }
  end
  #
  # 現在のステートをアイコン番号の配列で取得
  #
  #
  def state_icons
    icons = states.collect {|state| state.icon_index }
    icons.delete(0)
    icons
  end
  #
  # 現在の強化／弱体をアイコン番号の配列で取得
  #
  #
  def buff_icons
    icons = []
    @buffs.each_with_index {|lv, i| icons.push(buff_icon_index(lv, i)) }
    icons.delete(0)
    icons
  end
  #
  # 強化／弱体に対応するアイコン番号を取得
  #
  #
  def buff_icon_index(buff_level, param_id)
    if buff_level > 0
      return ICON_BUFF_START + (buff_level - 1) * 8 + param_id
    elsif buff_level < 0
      return ICON_DEBUFF_START + (-buff_level - 1) * 8 + param_id 
    else
      return 0
    end
  end
  #
  # 特徴を保持する全オブジェクトの配列取得
  #
  #
  def feature_objects
    states
  end
  #
  # 全ての特徴オブジェクトの配列取得
  #
  #
  def all_features
    feature_objects.inject([]) {|r, obj| r + obj.features }
  end
  #
  # 特徴オブジェクトの配列取得（特徴コードを限定）
  #
  #
  def features(code)
    all_features.select {|ft| ft.code == code }
  end
  #
  # 特徴オブジェクトの配列取得（特徴コードとデータ ID を限定）
  #
  #
  def features_with_id(code, id)
    all_features.select {|ft| ft.code == code && ft.data_id == id }
  end
  #
  # 特徴値の総乗計算
  #
  #
  def features_pi(code, id)
    features_with_id(code, id).inject(1.0) {|r, ft| r *= ft.value }
  end
  #
  # 特徴値の総和計算（データ ID を指定）
  #
  #
  def features_sum(code, id)
    features_with_id(code, id).inject(0.0) {|r, ft| r += ft.value }
  end
  #
  # 特徴値の総和計算（データ ID は非指定）
  #
  #
  def features_sum_all(code)
    features(code).inject(0.0) {|r, ft| r += ft.value }
  end
  #
  # 特徴の集合和計算
  #
  #
  def features_set(code)
    features(code).inject([]) {|r, ft| r |= [ft.data_id] }
  end
  #
  # 通常能力値の基本値取得
  #
  #
  def param_base(param_id)
    return 0
  end
  #
  # 通常能力値の加算値取得
  #
  #
  def param_plus(param_id)
    @param_plus[param_id]
  end
  #
  # 通常能力値の最小値取得
  #
  #
  def param_min(param_id)
    return 0 if param_id == 1  # MMP
    return 1
  end
  #
  # 通常能力値の最大値取得
  #
  #
  def param_max(param_id)
    return 999999 if param_id == 0  # MHP
    return 9999   if param_id == 1  # MMP
    return 999
  end
  #
  # 通常能力値の変化率取得
  #
  #
  def param_rate(param_id)
    features_pi(FEATURE_PARAM, param_id)
  end
  #
  # 通常能力値の強化／弱体による変化率取得
  #
  #
  def param_buff_rate(param_id)
    @buffs[param_id] * 0.25 + 1.0
  end
  #
  # 通常能力値の取得
  #
  #
  def param(param_id)
    value = param_base(param_id) + param_plus(param_id)
    value *= param_rate(param_id) * param_buff_rate(param_id)
    [[value, param_max(param_id)].min, param_min(param_id)].max.to_i
  end
  #
  # 追加能力値の取得
  #
  #
  def xparam(xparam_id)
    features_sum(FEATURE_XPARAM, xparam_id)
  end
  #
  # 特殊能力値の取得
  #
  #
  def sparam(sparam_id)
    features_pi(FEATURE_SPARAM, sparam_id)
  end
  #
  # 属性有効度の取得
  #
  #
  def element_rate(element_id)
    features_pi(FEATURE_ELEMENT_RATE, element_id)
  end
  #
  # 弱体有効度の取得
  #
  #
  def debuff_rate(param_id)
    features_pi(FEATURE_DEBUFF_RATE, param_id)
  end
  #
  # ステート有効度の取得
  #
  #
  def state_rate(state_id)
    features_pi(FEATURE_STATE_RATE, state_id)
  end
  #
  # 無効化するステートの配列を取得
  #
  #
  def state_resist_set
    features_set(FEATURE_STATE_RESIST)
  end
  #
  # 無効化されているステートの判定
  #
  #
  def state_resist?(state_id)
    state_resist_set.include?(state_id)
  end
  #
  # 攻撃時属性の取得
  #
  #
  def atk_elements
    features_set(FEATURE_ATK_ELEMENT)
  end
  #
  # 攻撃時ステートの取得
  #
  #
  def atk_states
    features_set(FEATURE_ATK_STATE)
  end
  #
  # 攻撃時ステートの発動率取得
  #
  #
  def atk_states_rate(state_id)
    features_sum(FEATURE_ATK_STATE, state_id)
  end
  #
  # 攻撃速度補正の取得
  #
  #
  def atk_speed
    features_sum_all(FEATURE_ATK_SPEED)
  end
  #
  # 攻撃追加回数の取得
  #
  #
  def atk_times_add
    [features_sum_all(FEATURE_ATK_TIMES), 0].max
  end
  #
  # 追加スキルタイプの取得
  #
  #
  def added_skill_types
    features_set(FEATURE_STYPE_ADD)
  end
  #
  # スキルタイプ封印の判定
  #
  #
  def skill_type_sealed?(stype_id)
    features_set(FEATURE_STYPE_SEAL).include?(stype_id)
  end
  #
  # 追加スキルの取得
  #
  #
  def added_skills
    features_set(FEATURE_SKILL_ADD)
  end
  #
  # スキル封印の判定
  #
  #
  def skill_sealed?(skill_id)
    features_set(FEATURE_SKILL_SEAL).include?(skill_id)
  end
  #
  # 武器装備可能の判定
  #
  #
  def equip_wtype_ok?(wtype_id)
    features_set(FEATURE_EQUIP_WTYPE).include?(wtype_id)
  end
  #
  # 防具装備可能の判定
  #
  #
  def equip_atype_ok?(atype_id)
    features_set(FEATURE_EQUIP_ATYPE).include?(atype_id)
  end
  #
  # 装備固定の判定
  #
  #
  def equip_type_fixed?(etype_id)
    features_set(FEATURE_EQUIP_FIX).include?(etype_id)
  end
  #
  # 装備封印の判定
  #
  #
  def equip_type_sealed?(etype_id)
    features_set(FEATURE_EQUIP_SEAL).include?(etype_id)
  end
  #
  # スロットタイプの取得
  #
  #
  def slot_type
    features_set(FEATURE_SLOT_TYPE).max || 0
  end
  #
  # 二刀流の判定
  #
  #
  def dual_wield?
    slot_type == 1
  end
  #
  # 行動回数追加確率の配列を取得
  #
  #
  def action_plus_set
    features(FEATURE_ACTION_PLUS).collect {|ft| ft.value }
  end
  #
  # 特殊フラグ判定
  #
  #
  def special_flag(flag_id)
    features(FEATURE_SPECIAL_FLAG).any? {|ft| ft.data_id == flag_id }
  end
  #
  # 消滅エフェクトの取得
  #
  #
  def collapse_type
    features_set(FEATURE_COLLAPSE_TYPE).max || 0
  end
  #
  # パーティ能力判定
  #
  #
  def party_ability(ability_id)
    features(FEATURE_PARTY_ABILITY).any? {|ft| ft.data_id == ability_id }
  end
  #
  # 自動戦闘の判定
  #
  #
  def auto_battle?
    special_flag(FLAG_ID_AUTO_BATTLE)
  end
  #
  # 防御の判定
  #
  #
  def guard?
    special_flag(FLAG_ID_GUARD) && movable?
  end
  #
  # 身代わりの判定
  #
  #
  def substitute?
    special_flag(FLAG_ID_SUBSTITUTE) && movable?
  end
  #
  # TP持ち越しの判定
  #
  #
  def preserve_tp?
    special_flag(FLAG_ID_PRESERVE_TP)
  end
  #
  # 能力値の加算
  #
  #
  def add_param(param_id, value)
    @param_plus[param_id] += value
    refresh
  end
  #
  # HP の変更
  #
  #
  def hp=(hp)
    @hp = hp
    refresh
  end
  #
  # MP の変更
  #
  #
  def mp=(mp)
    @mp = mp
    refresh
  end
  #
  # HP の増減（イベント用）
  #
  # value        : 増減値
  # enable_death : 戦闘不能を許可
  #
  def change_hp(value, enable_death)
    if !enable_death && @hp + value <= 0
      self.hp = 1
    else
      self.hp += value
    end
  end
  #
  # TP の変更
  #
  #
  def tp=(tp)
    @tp = [[tp, max_tp].min, 0].max
  end
  #
  # TP の最大値を取得
  #
  #
  def max_tp
    return 100
  end
  #
  # リフレッシュ
  #
  #
  def refresh
    state_resist_set.each {|state_id| erase_state(state_id) }
    @hp = [[@hp, mhp].min, 0].max
    @mp = [[@mp, mmp].min, 0].max
    @hp == 0 ? add_state(death_state_id) : remove_state(death_state_id)
  end
  #
  # 全回復
  #
  #
  def recover_all
    clear_states
    @hp = mhp
    @mp = mmp
  end
  #
  # HP の割合を取得
  #
  #
  def hp_rate
    @hp.to_f / mhp
  end
  #
  # MP の割合を取得
  #
  #
  def mp_rate
    mmp > 0 ? @mp.to_f / mmp : 0
  end
  #
  # TP の割合を取得
  #
  #
  def tp_rate
    @tp.to_f / 100
  end
  #
  # 隠れる
  #
  #
  def hide
    @hidden = true
  end
  #
  # 現れる
  #
  #
  def appear
    @hidden = false
  end
  #
  # 隠れ状態取得
  #
  #
  def hidden?
    @hidden
  end
  #
  # 存在判定
  #
  #
  def exist?
    !hidden?
  end
  #
  # 戦闘不能判定
  #
  #
  def dead?
    exist? && death_state?
  end
  #
  # 生存判定
  #
  #
  def alive?
    exist? && !death_state?
  end
  #
  # 正常判定
  #
  #
  def normal?
    exist? && restriction == 0
  end
  #
  # コマンド入力可能判定
  #
  #
  def inputable?
    normal? && !auto_battle?
  end
  #
  # 行動可能判定
  #
  #
  def movable?
    exist? && restriction < 4
  end
  #
  # 混乱状態判定
  #
  #
  def confusion?
    exist? && restriction >= 1 && restriction <= 3
  end
  #
  # 混乱レベル取得
  #
  #
  def confusion_level
    confusion? ? restriction : 0
  end
  #
  # アクターか否かの判定
  #
  #
  def actor?
    return false
  end
  #
  # 敵キャラか否かの判定
  #
  #
  def enemy?
    return false
  end
  #
  # ステートの並び替え
  #
  # 配列 `@states` の内容を表示優先度の大きい順に並び替える。
  #
  def sort_states
    @states = @states.sort_by {|id| [-$data_states[id].priority, id] }
  end
  #
  # 制約の取得
  #
  # 現在付加されているステートから最大の restriction を取得する。
  #
  def restriction
    states.collect {|state| state.restriction }.push(0).max
  end
  #
  # 最重要のステート継続メッセージを取得
  #
  #
  def most_important_state_text
    states.each {|state| return state.message3 unless state.message3.empty? }
    return ""
  end
  #
  # スキルの必要武器を装備しているか
  #
  #
  def skill_wtype_ok?(skill)
    return true
  end
  #
  # スキルの消費 MP 計算
  #
  #
  def skill_mp_cost(skill)
    (skill.mp_cost * mcr).to_i
  end
  #
  # スキルの消費 TP 計算
  #
  #
  def skill_tp_cost(skill)
    skill.tp_cost
  end
  #
  # スキル使用コストの支払い可能判定
  #
  #
  def skill_cost_payable?(skill)
    tp >= skill_tp_cost(skill) && mp >= skill_mp_cost(skill)
  end
  #
  # スキル使用コストの支払い
  #
  #
  def pay_skill_cost(skill)
    self.mp -= skill_mp_cost(skill)
    self.tp -= skill_tp_cost(skill)
  end
  #
  # スキル／アイテムの使用可能時チェック
  #
  #
  def occasion_ok?(item)
    $game_party.in_battle ? item.battle_ok? : item.menu_ok?
  end
  #
  # スキル／アイテムの共通使用可能条件チェック
  #
  #
  def usable_item_conditions_met?(item)
    movable? && occasion_ok?(item)
  end
  #
  # スキルの使用可能条件チェック
  #
  #
  def skill_conditions_met?(skill)
    usable_item_conditions_met?(skill) &&
    skill_wtype_ok?(skill) && skill_cost_payable?(skill) &&
    !skill_sealed?(skill.id) && !skill_type_sealed?(skill.stype_id)
  end
  #
  # アイテムの使用可能条件チェック
  #
  #
  def item_conditions_met?(item)
    usable_item_conditions_met?(item) && $game_party.has_item?(item)
  end
  #
  # スキル／アイテムの使用可能判定
  #
  #
  def usable?(item)
    return skill_conditions_met?(item) if item.is_a?(RPG::Skill)
    return item_conditions_met?(item)  if item.is_a?(RPG::Item)
    return false
  end
  #
  # 装備可能判定
  #
  #
  def equippable?(item)
    return false unless item.is_a?(RPG::EquipItem)
    return false if equip_type_sealed?(item.etype_id)
    return equip_wtype_ok?(item.wtype_id) if item.is_a?(RPG::Weapon)
    return equip_atype_ok?(item.atype_id) if item.is_a?(RPG::Armor)
    return false
  end
  #
  # 通常攻撃のスキル ID を取得
  #
  #
  def attack_skill_id
    return 1
  end
  #
  # 防御のスキル ID を取得
  #
  #
  def guard_skill_id
    return 2
  end
  #
  # 通常攻撃の使用可能判定
  #
  #
  def attack_usable?
    usable?($data_skills[attack_skill_id])
  end
  #
  # 防御の使用可能判定
  #
  #
  def guard_usable?
    usable?($data_skills[guard_skill_id])
  end
end
