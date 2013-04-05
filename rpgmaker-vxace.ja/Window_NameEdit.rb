#
# 名前入力画面で、名前を編集するウィンドウです。
#

class Window_NameEdit < Window_Base
  #
  # 公開インスタンス変数
  #
  #
  attr_reader   :name                     # 名前
  attr_reader   :index                    # カーソル位置
  attr_reader   :max_char                 # 最大文字数
  #
  # オブジェクト初期化
  #
  #
  def initialize(actor, max_char)
    x = (Graphics.width - 360) / 2
    y = (Graphics.height - (fitting_height(4) + fitting_height(9) + 8)) / 2
    super(x, y, 360, fitting_height(4))
    @actor = actor
    @max_char = max_char
    @default_name = @name = actor.name[0, @max_char]
    @index = @name.size
    deactivate
    refresh
  end
  #
  # デフォルトの名前に戻す
  #
  #
  def restore_default
    @name = @default_name
    @index = @name.size
    refresh
    return !@name.empty?
  end
  #
  # 文字の追加
  #
  # ch : 追加する文字
  #
  def add(ch)
    return false if @index >= @max_char
    @name += ch
    @index += 1
    refresh
    return true
  end
  #
  # 一文字戻す
  #
  #
  def back
    return false if @index == 0
    @index -= 1
    @name = @name[0, @index]
    refresh
    return true
  end
  #
  # 顔グラフィックの幅を取得
  #
  #
  def face_width
    return 96
  end
  #
  # 文字の幅を取得
  #
  #
  def char_width
    text_size($game_system.japanese? ? "あ" : "A").width 
  end
  #
  # 名前を描画する左端の座標を取得
  #
  #
  def left
    name_center = (contents_width + face_width) / 2
    name_width = (@max_char + 1) * char_width
    return [name_center - name_width / 2, contents_width - name_width].min
  end
  #
  # 項目を描画する矩形の取得
  #
  #
  def item_rect(index)
    Rect.new(left + index * char_width, 36, char_width, line_height)
  end
  #
  # 下線の矩形を取得
  #
  #
  def underline_rect(index)
    rect = item_rect(index)
    rect.x += 1
    rect.y += rect.height - 4
    rect.width -= 2
    rect.height = 2
    rect
  end
  #
  # 下線の色を取得
  #
  #
  def underline_color
    color = normal_color
    color.alpha = 48
    color
  end
  #
  # 下線を描画
  #
  #
  def draw_underline(index)
    contents.fill_rect(underline_rect(index), underline_color)
  end
  #
  # 文字を描画
  #
  #
  def draw_char(index)
    rect = item_rect(index)
    rect.x -= 1
    rect.width += 4
    change_color(normal_color)
    draw_text(rect, @name[index] || "")
  end
  #
  # リフレッシュ
  #
  #
  def refresh
    contents.clear
    draw_actor_face(@actor, 0, 0)
    @max_char.times {|i| draw_underline(i) }
    @name.size.times {|i| draw_char(i) }
    cursor_rect.set(item_rect(@index))
  end
end
