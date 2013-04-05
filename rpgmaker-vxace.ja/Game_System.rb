#
# システム周りのデータを扱うクラスです。セーブやメニューの禁止状態などを保存
# します。このクラスのインスタンスは $game_system で参照されます。
#

class Game_System
  #
  # 公開インスタンス変数
  #
  #
  attr_accessor :save_disabled            # セーブ禁止
  attr_accessor :menu_disabled            # メニュー禁止
  attr_accessor :encounter_disabled       # エンカウント禁止
  attr_accessor :formation_disabled       # 並び替え禁止
  attr_accessor :battle_count             # 戦闘回数
  attr_reader   :save_count               # セーブ回数
  attr_reader   :version_id               # ゲームのバージョン ID
  #
  # オブジェクト初期化
  #
  #
  def initialize
    @save_disabled = false
    @menu_disabled = false
    @encounter_disabled = false
    @formation_disabled = false
    @battle_count = 0
    @save_count = 0
    @version_id = 0
    @window_tone = nil
    @battle_bgm = nil
    @battle_end_me = nil
    @saved_bgm = nil
  end
  #
  # 日本語モード判定
  #
  #
  def japanese?
    $data_system.japanese
  end
  #
  # ウィンドウカラーの取得
  #
  #
  def window_tone
    @window_tone || $data_system.window_tone
  end
  #
  # ウィンドウカラーの設定
  #
  #
  def window_tone=(window_tone)
    @window_tone = window_tone
  end
  #
  # 戦闘 BGM の取得
  #
  #
  def battle_bgm
    @battle_bgm || $data_system.battle_bgm
  end
  #
  # 戦闘 BGM の設定
  #
  #
  def battle_bgm=(battle_bgm)
    @battle_bgm = battle_bgm
  end
  #
  # 戦闘終了 ME の取得
  #
  #
  def battle_end_me
    @battle_end_me || $data_system.battle_end_me
  end
  #
  # 戦闘終了 ME の設定
  #
  #
  def battle_end_me=(battle_end_me)
    @battle_end_me = battle_end_me
  end
  #
  # セーブ前の処理
  #
  #
  def on_before_save
    @save_count += 1
    @version_id = $data_system.version_id
    @frames_on_save = Graphics.frame_count
    @bgm_on_save = RPG::BGM.last
    @bgs_on_save = RPG::BGS.last
  end
  #
  # ロード後の処理
  #
  #
  def on_after_load
    Graphics.frame_count = @frames_on_save
    @bgm_on_save.play
    @bgs_on_save.play
  end
  #
  # プレイ時間を秒数で取得
  #
  #
  def playtime
    Graphics.frame_count / Graphics.frame_rate
  end
  #
  # プレイ時間を文字列で取得
  #
  #
  def playtime_s
    hour = playtime / 60 / 60
    min = playtime / 60 % 60
    sec = playtime % 60
    sprintf("%02d:%02d:%02d", hour, min, sec)
  end
  #
  # BGM の保存
  #
  #
  def save_bgm
    @saved_bgm = RPG::BGM.last
  end
  #
  # BGM の再開
  #
  #
  def replay_bgm
    @saved_bgm.replay if @saved_bgm
  end
end
