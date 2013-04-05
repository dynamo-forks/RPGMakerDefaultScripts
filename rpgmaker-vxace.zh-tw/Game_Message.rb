#encoding:utf-8
#
# 處理訊息視窗狀態、文字顯示、選項等的類。本類的案例請參考 $game_message 。
#

class Game_Message
  #
  # 定義案例變量
  #
  #
  attr_reader   :texts                    # 文字數組（行單位）
  attr_reader   :choices                  # 選項數組
  attr_accessor :face_name                # 肖像檔名
  attr_accessor :face_index               # 肖像索引
  attr_accessor :background               # 背景類型
  attr_accessor :position                 # 顯示位置
  attr_accessor :choice_proc              # 選項 回調（Proc）
  attr_accessor :choice_cancel_type       # 選項 取消的場合
  attr_accessor :num_input_variable_id    # 數值輸入 變量ID
  attr_accessor :num_input_digits_max     # 數值輸入 列數
  attr_accessor :item_choice_variable_id  # 物品選擇 變量ID
  attr_accessor :scroll_mode              # 卷動文字的標志
  attr_accessor :scroll_speed             # 卷動文字：卷動速度
  attr_accessor :scroll_no_fast           # 卷動文字：禁止快進
  attr_accessor :visible                  # 訊息顯示中
  #
  # 初始化物件
  #
  #
  def initialize
    clear
    @visible = false
  end
  #
  # 清除
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
  # 加入內容
  #
  #
  def add(text)
    @texts.push(text)
  end
  #
  # 判定是否存在顯示內容
  #
  #
  def has_text?
    @texts.size > 0
  end
  #
  # 判定是否為選擇模式
  #
  #
  def choice?
    @choices.size > 0
  end
  #
  # 判定是否為數值輸入模式
  #
  #
  def num_input?
    @num_input_variable_id > 0
  end
  #
  # 判定是否為物品選擇模式
  #
  #
  def item_choice?
    @item_choice_variable_id > 0
  end
  #
  # 判定是否為繁忙狀態
  #
  #
  def busy?
    has_text? || choice? || num_input? || item_choice?
  end
  #
  # 翻頁
  #
  #
  def new_page
    @texts[-1] += "\f" if @texts.size > 0
  end
  #
  # 取得內含換行符的所有內容
  #
  #
  def all_text
    @texts.inject("") {|r, text| r += text + "\n" }
  end
end
