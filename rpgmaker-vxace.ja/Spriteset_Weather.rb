#
# 天候エフェクト（雨、嵐、雪）のクラスです。このクラスは Spriteset_Map クラ
# スの内部で使用されます。
#

class Spriteset_Weather
  #
  # 公開インスタンス変数
  #
  #
  attr_accessor :type                     # 天候タイプ
  attr_accessor :ox                       # 原点 X 座標
  attr_accessor :oy                       # 原点 Y 座標
  attr_reader   :power                    # 強さ
  #
  # オブジェクト初期化
  #
  #
  def initialize(viewport = nil)
    @viewport = viewport
    init_members
    create_rain_bitmap
    create_storm_bitmap
    create_snow_bitmap
  end
  #
  # メンバ変数の初期化
  #
  #
  def init_members
    @type = :none
    @ox = 0
    @oy = 0
    @power = 0
    @sprites = []
  end
  #
  # 解放
  #
  #
  def dispose
    @sprites.each {|sprite| sprite.dispose }
    @rain_bitmap.dispose
    @storm_bitmap.dispose
    @snow_bitmap.dispose
  end
  #
  # 粒子の色 1
  #
  #
  def particle_color1
    Color.new(255, 255, 255, 192)
  end
  #
  # 粒子の色 2
  #
  #
  def particle_color2
    Color.new(255, 255, 255, 96)
  end
  #
  # 天候［雨］のビットマップを作成
  #
  #
  def create_rain_bitmap
    @rain_bitmap = Bitmap.new(7, 42)
    7.times {|i| @rain_bitmap.fill_rect(6-i, i*6, 1, 6, particle_color1) }
  end
  #
  # 天候［嵐］のビットマップを作成
  #
  #
  def create_storm_bitmap
    @storm_bitmap = Bitmap.new(34, 64)
    32.times do |i|
      @storm_bitmap.fill_rect(33-i, i*2, 1, 2, particle_color2)
      @storm_bitmap.fill_rect(32-i, i*2, 1, 2, particle_color1)
      @storm_bitmap.fill_rect(31-i, i*2, 1, 2, particle_color2)
    end
  end
  #
  # 天候［雪］のビットマップを作成
  #
  #
  def create_snow_bitmap
    @snow_bitmap = Bitmap.new(6, 6)
    @snow_bitmap.fill_rect(0, 1, 6, 4, particle_color2)
    @snow_bitmap.fill_rect(1, 0, 4, 6, particle_color2)
    @snow_bitmap.fill_rect(1, 2, 4, 2, particle_color1)
    @snow_bitmap.fill_rect(2, 1, 2, 4, particle_color1)
  end
  #
  # 天候の強さを設定
  #
  #
  def power=(power)
    @power = power
    (sprite_max - @sprites.size).times { add_sprite }
    (@sprites.size - sprite_max).times { remove_sprite }
  end
  #
  # スプライトの最大数を取得
  #
  #
  def sprite_max
    (@power * 10).to_i
  end
  #
  # スプライトの追加
  #
  #
  def add_sprite
    sprite = Sprite.new(@viewport)
    sprite.opacity = 0
    @sprites.push(sprite)
  end
  #
  # スプライトの削除
  #
  #
  def remove_sprite
    sprite = @sprites.pop
    sprite.dispose if sprite
  end
  #
  # フレーム更新
  #
  #
  def update
    update_screen
    @sprites.each {|sprite| update_sprite(sprite) }
  end
  #
  # 画面の更新
  #
  #
  def update_screen
    @viewport.tone.set(-dimness, -dimness, -dimness)
  end
  #
  # 暗さの取得
  #
  #
  def dimness
    (@power * 6).to_i
  end
  #
  # スプライトの更新
  #
  #
  def update_sprite(sprite)
    sprite.ox = @ox
    sprite.oy = @oy
    case @type
    when :rain
      update_sprite_rain(sprite)
    when :storm
      update_sprite_storm(sprite)
    when :snow
      update_sprite_snow(sprite)
    end
    create_new_particle(sprite) if sprite.opacity < 64
  end
  #
  # スプライトの更新［雨］
  #
  #
  def update_sprite_rain(sprite)
    sprite.bitmap = @rain_bitmap
    sprite.x -= 1
    sprite.y += 6
    sprite.opacity -= 12
  end
  #
  # スプライトの更新［嵐］
  #
  #
  def update_sprite_storm(sprite)
    sprite.bitmap = @storm_bitmap
    sprite.x -= 3
    sprite.y += 6
    sprite.opacity -= 12
  end
  #
  # スプライトの更新［雪］
  #
  #
  def update_sprite_snow(sprite)
    sprite.bitmap = @snow_bitmap
    sprite.x -= 1
    sprite.y += 3
    sprite.opacity -= 12
  end
  #
  # 新しい粒子の作成
  #
  #
  def create_new_particle(sprite)
    sprite.x = rand(Graphics.width + 100) - 100 + @ox
    sprite.y = rand(Graphics.height + 200) - 200 + @oy
    sprite.opacity = 160 + rand(96)
  end
end
