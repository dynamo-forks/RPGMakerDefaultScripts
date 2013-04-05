#
# 各種グラフィックを読み込み、Bitmap オブジェクトを作成、保持するモジュール
# です。読み込みの高速化とメモリ節約のため、作成した Bitmap オブジェクトを内部
# のハッシュに保存し、同じビットマップが再度要求されたときに既存のオブジェクト
# を返すようになっています。
#

module Cache
  #
  # アニメーション グラフィックの取得
  #
  #
  def self.animation(filename, hue)
    load_bitmap("Graphics/Animations/", filename, hue)
  end
  #
  # 戦闘背景（床）グラフィックの取得
  #
  #
  def self.battleback1(filename)
    load_bitmap("Graphics/Battlebacks1/", filename)
  end
  #
  # 戦闘背景（壁）グラフィックの取得
  #
  #
  def self.battleback2(filename)
    load_bitmap("Graphics/Battlebacks2/", filename)
  end
  #
  # 戦闘グラフィックの取得
  #
  #
  def self.battler(filename, hue)
    load_bitmap("Graphics/Battlers/", filename, hue)
  end
  #
  # 歩行グラフィックの取得
  #
  #
  def self.character(filename)
    load_bitmap("Graphics/Characters/", filename)
  end
  #
  # 顔グラフィックの取得
  #
  #
  def self.face(filename)
    load_bitmap("Graphics/Faces/", filename)
  end
  #
  # 遠景グラフィックの取得
  #
  #
  def self.parallax(filename)
    load_bitmap("Graphics/Parallaxes/", filename)
  end
  #
  # ピクチャ グラフィックの取得
  #
  #
  def self.picture(filename)
    load_bitmap("Graphics/Pictures/", filename)
  end
  #
  # システム グラフィックの取得
  #
  #
  def self.system(filename)
    load_bitmap("Graphics/System/", filename)
  end
  #
  # タイルセット グラフィックの取得
  #
  #
  def self.tileset(filename)
    load_bitmap("Graphics/Tilesets/", filename)
  end
  #
  # タイトル（背景）グラフィックの取得
  #
  #
  def self.title1(filename)
    load_bitmap("Graphics/Titles1/", filename)
  end
  #
  # タイトル（枠）グラフィックの取得
  #
  #
  def self.title2(filename)
    load_bitmap("Graphics/Titles2/", filename)
  end
  #
  # ビットマップの読み込み
  #
  #
  def self.load_bitmap(folder_name, filename, hue = 0)
    @cache ||= {}
    if filename.empty?
      empty_bitmap
    elsif hue == 0
      normal_bitmap(folder_name + filename)
    else
      hue_changed_bitmap(folder_name + filename, hue)
    end
  end
  #
  # 空のビットマップを作成
  #
  #
  def self.empty_bitmap
    Bitmap.new(32, 32)
  end
  #
  # 通常のビットマップを作成／取得
  #
  #
  def self.normal_bitmap(path)
    @cache[path] = Bitmap.new(path) unless include?(path)
    @cache[path]
  end
  #
  # 色相変化済みビットマップを作成／取得
  #
  #
  def self.hue_changed_bitmap(path, hue)
    key = [path, hue]
    unless include?(key)
      @cache[key] = normal_bitmap(path).clone
      @cache[key].hue_change(hue)
    end
    @cache[key]
  end
  #
  # キャッシュ存在チェック
  #
  #
  def self.include?(key)
    @cache[key] && !@cache[key].disposed?
  end
  #
  # キャッシュのクリア
  #
  #
  def self.clear
    @cache ||= {}
    @cache.clear
    GC.start
  end
end
