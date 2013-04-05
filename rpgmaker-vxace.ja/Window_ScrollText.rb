#
# 文章のスクロール表示に使うウィンドウです。枠は表示しませんが、便宜上ウィン
# ドウとして扱います。
#

class Window_ScrollText < Window_Base
  #
  # オブジェクト初期化
  #
  #
  def initialize
    super(0, 0, Graphics.width, Graphics.height)
    self.opacity = 0
    self.arrows_visible = false
    hide
  end
  #
  # フレーム更新
  #
  #
  def update
    super
    if $game_message.scroll_mode
      update_message if @text
      start_message if !@text && $game_message.has_text?
    end
  end
  #
  # メッセージの開始
  #
  #
  def start_message
    @text = $game_message.all_text
    refresh
    show
  end
  #
  # リフレッシュ
  #
  #
  def refresh
    reset_font_settings
    update_all_text_height
    create_contents
    draw_text_ex(4, 0, @text)
    self.oy = @scroll_pos = -height
  end
  #
  # 全テキストの描画に必要な高さを更新
  #
  #
  def update_all_text_height
    @all_text_height = 1
    convert_escape_characters(@text).each_line do |line|
      @all_text_height += calc_line_height(line, false)
    end
    reset_font_settings
  end
  #
  # ウィンドウ内容の高さを計算
  #
  #
  def contents_height
    @all_text_height ? @all_text_height : super
  end
  #
  # メッセージの更新
  #
  #
  def update_message
    @scroll_pos += scroll_speed
    self.oy = @scroll_pos
    terminate_message if @scroll_pos >= contents.height
  end
  #
  # スクロール速度の取得
  #
  #
  def scroll_speed
    $game_message.scroll_speed * (show_fast? ? 1.0 : 0.5)
  end
  #
  # 早送り判定
  #
  #
  def show_fast?
    !$game_message.scroll_no_fast && (Input.press?(:A) || Input.press?(:C))
  end
  #
  # メッセージの終了
  #
  #
  def terminate_message
    @text = nil
    $game_message.clear
    hide
  end
end
