#
# ピクチャ表示用のスプライトです。Game_Picture クラスのインスタンスを監視し、
# スプライトの状態を自動的に変化させます。
#

class Sprite_Picture < Sprite
  #
  # オブジェクト初期化
  #
  # picture : Game_Picture
  #
  def initialize(viewport, picture)
    super(viewport)
    @picture = picture
    update
  end
  #
  # 解放
  #
  #
  def dispose
    bitmap.dispose if bitmap
    super
  end
  #
  # フレーム更新
  #
  #
  def update
    super
    update_bitmap
    update_origin
    update_position
    update_zoom
    update_other
  end
  #
  # 転送元ビットマップの更新
  #
  #
  def update_bitmap
    self.bitmap = Cache.picture(@picture.name)
  end
  #
  # 原点の更新
  #
  #
  def update_origin
    if @picture.origin == 0
      self.ox = 0
      self.oy = 0
    else
      self.ox = bitmap.width / 2
      self.oy = bitmap.height / 2
    end
  end
  #
  # 位置の更新
  #
  #
  def update_position
    self.x = @picture.x
    self.y = @picture.y
    self.z = @picture.number
  end
  #
  # 拡大率の更新
  #
  #
  def update_zoom
    self.zoom_x = @picture.zoom_x / 100.0
    self.zoom_y = @picture.zoom_y / 100.0
  end
  #
  # その他の更新
  #
  #
  def update_other
    self.opacity = @picture.opacity
    self.blend_type = @picture.blend_type
    self.angle = @picture.angle
    self.tone.set(@picture.tone)
  end
end
