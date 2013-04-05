#
# 横選択形式のコマンドウィンドウです。
#

class Window_HorzCommand < Window_Command
  #
  # 表示行数の取得
  #
  #
  def visible_line_number
    return 1
  end
  #
  # 桁数の取得
  #
  #
  def col_max
    return 4
  end
  #
  # 横に項目が並ぶときの空白の幅を取得
  #
  #
  def spacing
    return 8
  end
  #
  # ウィンドウ内容の幅を計算
  #
  #
  def contents_width
    (item_width + spacing) * item_max - spacing
  end
  #
  # ウィンドウ内容の高さを計算
  #
  #
  def contents_height
    item_height
  end
  #
  # 先頭の桁の取得
  #
  #
  def top_col
    ox / (item_width + spacing)
  end
  #
  # 先頭の桁の設定
  #
  #
  def top_col=(col)
    col = 0 if col < 0
    col = col_max - 1 if col > col_max - 1
    self.ox = col * (item_width + spacing)
  end
  #
  # 末尾の桁の取得
  #
  #
  def bottom_col
    top_col + col_max - 1
  end
  #
  # 末尾の桁の設定
  #
  #
  def bottom_col=(col)
    self.top_col = col - (col_max - 1)
  end
  #
  # カーソル位置が画面内になるようにスクロール
  #
  #
  def ensure_cursor_visible
    self.top_col = index if index < top_col
    self.bottom_col = index if index > bottom_col
  end
  #
  # 項目を描画する矩形の取得
  #
  #
  def item_rect(index)
    rect = super
    rect.x = index * (item_width + spacing)
    rect.y = 0
    rect
  end
  #
  # アライメントの取得
  #
  #
  def alignment
    return 1
  end
  #
  # カーソルを下に移動
  #
  #
  def cursor_down(wrap = false)
  end
  #
  # カーソルを上に移動
  #
  #
  def cursor_up(wrap = false)
  end
  #
  # カーソルを 1 ページ後ろに移動
  #
  #
  def cursor_pagedown
  end
  #
  # カーソルを 1 ページ前に移動
  #
  #
  def cursor_pageup
  end
end
