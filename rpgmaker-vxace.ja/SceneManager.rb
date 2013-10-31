#
# シーン遷移を管理するモジュールです。たとえばメインメニューからアイテム画面
# を呼び出し、また戻るというような階層構造を扱うことができます。
#

module SceneManager
  #
  # モジュールのインスタンス変数
  #
  #
  @scene = nil                            # 現在のシーンオブジェクト
  @stack = []                             # 階層遷移用のスタック
  @background_bitmap = nil                # 背景用ビットマップ
  #
  # 実行
  #
  #
  def self.run
    DataManager.init
    Audio.setup_midi if use_midi?
    @scene = first_scene_class.new
    @scene.main while @scene
  end
  #
  # 最初のシーンクラスを取得
  #
  #
  def self.first_scene_class
    $BTEST ? Scene_Battle : Scene_Title
  end
  #
  # MIDI を使用するか
  #
  #
  def self.use_midi?
    $data_system.opt_use_midi
  end
  #
  # 現在のシーンを取得
  #
  #
  def self.scene
    @scene
  end
  #
  # 現在のシーンクラス判定
  #
  #
  def self.scene_is?(scene_class)
    @scene.instance_of?(scene_class)
  end
  #
  # 直接遷移
  #
  #
  def self.goto(scene_class)
    @scene = scene_class.new
  end
  #
  # 呼び出し
  #
  #
  def self.call(scene_class)
    @stack.push(@scene)
    @scene = scene_class.new
  end
  #
  # 呼び出し元へ戻る
  #
  #
  def self.return
    @scene = @stack.pop
  end
  #
  # 呼び出しスタックのクリア
  #
  #
  def self.clear
    @stack.clear
  end
  #
  # ゲーム終了
  #
  #
  def self.exit
    @scene = nil
  end
  #
  # 背景として使うためのスナップショット作成
  #
  #
  def self.snapshot_for_background
    @background_bitmap.dispose if @background_bitmap
    @background_bitmap = Graphics.snap_to_bitmap
    @background_bitmap.blur
  end
  #
  # 背景用ビットマップを取得
  #
  #
  def self.background_bitmap
    @background_bitmap
  end
end