#encoding:utf-8
#
# 天氣效果（雨、風、雪）的精靈。在 Spriteset_Map 內定使用。
#

class Spriteset_Weather
  #
  # 定義案例變量
  #
  #
  attr_accessor :type                     # 天氣類型
  attr_accessor :ox                       # 原點 X 坐標
  attr_accessor :oy                       # 原點 Y 坐標
  attr_reader   :power                    # 強度
  #
  # 初始化物件
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
  # 初始化成員變量
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
  # 釋放
  #
  #
  def dispose
    @sprites.each {|sprite| sprite.dispose }
    @rain_bitmap.dispose
    @storm_bitmap.dispose
    @snow_bitmap.dispose
  end
  #
  # 粒子的顏色 1
  #
  #
  def particle_color1
    Color.new(255, 255, 255, 192)
  end
  #
  # 粒子的顏色 2
  #
  #
  def particle_color2
    Color.new(255, 255, 255, 96)
  end
  #
  # 生成天氣“雨”的點陣圖
  #
  #
  def create_rain_bitmap
    @rain_bitmap = Bitmap.new(7, 42)
    7.times {|i| @rain_bitmap.fill_rect(6-i, i*6, 1, 6, particle_color1) }
  end
  #
  # 生成天氣“風”的點陣圖
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
  # 生成天氣“雪”的點陣圖
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
  # 設定天氣的強度
  #
  #
  def power=(power)
    @power = power
    (sprite_max - @sprites.size).times { add_sprite }
    (@sprites.size - sprite_max).times { remove_sprite }
  end
  #
  # 取得精靈的最大數
  #
  #
  def sprite_max
    (@power * 10).to_i
  end
  #
  # 加入精靈
  #
  #
  def add_sprite
    sprite = Sprite.new(@viewport)
    sprite.opacity = 0
    @sprites.push(sprite)
  end
  #
  # 刪除精靈
  #
  #
  def remove_sprite
    sprite = @sprites.pop
    sprite.dispose if sprite
  end
  #
  # 更新畫面
  #
  #
  def update
    update_screen
    @sprites.each {|sprite| update_sprite(sprite) }
  end
  #
  # 更新畫面
  #
  #
  def update_screen
    @viewport.tone.set(-dimness, -dimness, -dimness)
  end
  #
  # 取得灰暗度
  #
  #
  def dimness
    (@power * 6).to_i
  end
  #
  # 更新精靈
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
  # 更新精靈 “雨”
  #
  #
  def update_sprite_rain(sprite)
    sprite.bitmap = @rain_bitmap
    sprite.x -= 1
    sprite.y += 6
    sprite.opacity -= 12
  end
  #
  # 更新精靈 “風”
  #
  #
  def update_sprite_storm(sprite)
    sprite.bitmap = @storm_bitmap
    sprite.x -= 3
    sprite.y += 6
    sprite.opacity -= 12
  end
  #
  # 更新精靈 “雪”
  #
  #
  def update_sprite_snow(sprite)
    sprite.bitmap = @snow_bitmap
    sprite.x -= 1
    sprite.y += 3
    sprite.opacity -= 12
  end
  #
  # 生成新的粒子
  #
  #
  def create_new_particle(sprite)
    sprite.x = rand(Graphics.width + 100) - 100 + @ox
    sprite.y = rand(Graphics.height + 200) - 200 + @oy
    sprite.opacity = 160 + rand(96)
  end
end
