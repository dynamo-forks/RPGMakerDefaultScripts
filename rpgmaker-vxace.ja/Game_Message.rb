#
# 文章や選択肢などを表示するメッセージウィンドウの状態を扱うクラスです。この
# クラスのインスタンスは $game_message で参照されます。
#

class Game_Message
  #
  # 公開インスタンス変数
  #
  #
  attr_reader   :texts                    # 文章の配列（行単位）
  attr_reader   :choices                  # 選択肢の配列
  attr_accessor :face_name                # 顔グラフィック ファイル名
  attr_accessor :face_index               # 顔グラフィック インデックス
  attr_accessor :background               # 背景タイプ
  attr_accessor :position                 # 表示位置
  attr_accessor :choice_proc              # 選択肢 コールバック（Proc）
  attr_accessor :choice_cancel_type       # 選択肢 キャンセルの場合
  attr_accessor :num_input_variable_id    # 数値入力 変数 ID
  attr_accessor :num_input_digits_max     # 数値入力 桁数
  attr_accessor :item_choice_variable_id  # アイテム選択 変数 ID
  attr_accessor :scroll_mode              # スクロール文章フラグ
  attr_accessor :scroll_speed             # スクロール文章：速度
  attr_accessor :scroll_no_fast           # スクロール文章：早送り無効
  attr_accessor :visible                  # メッセージ表示中
  #
  # オブジェクト初期化
  #
  #
  def initialize
    clear
    @visible = false
  end
  #
  # クリア
  #
  #
  def clear
    @texts = []
    @choices = []
    @face_name = ""
    @face_index = 0
    @background = 0
    @position = 2
    @choice_cancel_type = 0
    @choice_proc = nil
    @num_input_variable_id = 0
    @num_input_digits_max = 0
    @item_choice_variable_id = 0
    @scroll_mode = false
    @scroll_speed = 2
    @scroll_no_fast = false
  end
  #
  # テキストの追加
  #
  #
  def add(text)
    @texts.push(text)
  end
  #
  # テキストの存在判定
  #
  #
  def has_text?
    @texts.size > 0
  end
  #
  # 選択肢モード判定
  #
  #
  def choice?
    @choices.size > 0
  end
  #
  # 数値入力モード判定
  #
  #
  def num_input?
    @num_input_variable_id > 0
  end
  #
  # アイテム選択モード判定
  #
  #
  def item_choice?
    @item_choice_variable_id > 0
  end
  #
  # ビジー判定
  #
  #
  def busy?
    has_text? || choice? || num_input? || item_choice?
  end
  #
  # 改ページ
  #
  #
  def new_page
    @texts[-1] += "\f" if @texts.size > 0
  end
  #
  # 改行込みの全テキストを取得
  #
  #
  def all_text
    @texts.inject("") {|r, text| r += text + "\n" }
  end
end
