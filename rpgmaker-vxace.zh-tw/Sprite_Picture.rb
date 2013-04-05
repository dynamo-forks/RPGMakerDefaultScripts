#encoding:utf-8
#
# 顯示圖片用的精靈。根據 Game_Picture 類的案例的狀態自動變化。
#

class Sprite_Picture < Sprite
  #
  # 初始化物件
  #
  # picture : Game_Picture
  #
  def initialize(viewport, picture)
    super(viewport)
    @picture = picture
    update
  end
  #
  # 釋放
  #
  #
  def dispose
    bitmap.dispose if bitmap
    super
  end
  #
  # 更新畫面
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
  # 更新源點陣圖（Source Bitmap）
  #
  #
  def update_bitmap
    self.bitmap = Cache.picture(@picture.name)
  end
  #
  # 更新原點
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
  # 更新位置
  #
  #
  def update_position
    self.x = @picture.x
    self.y = @picture.y
    self.z = @picture.number
  end
  #
  # 更新縮放率
  #
  #
  def update_zoom
    self.zoom_x = @picture.zoom_x / 100.0
    self.zoom_y = @picture.zoom_y / 100.0
  end
  #
  # 更新其他
  #
  #
  def update_other
    self.opacity = @picture.opacity
    self.blend_type = @picture.blend_type
    self.angle = @picture.angle
    self.tone.set(@picture.tone)
  end
end
