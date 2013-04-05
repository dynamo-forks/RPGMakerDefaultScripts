#encoding:utf-8
#
# 商店畫面中，選擇買入／賣出的視窗。
#

class Window_ShopCommand < Window_HorzCommand
  #
  # 初始化物件
  #
  #
  def initialize(window_width, purchase_only)
    @window_width = window_width
    @purchase_only = purchase_only
    super(0, 0)
  end
  #
  # 取得視窗的寬度
  #
  #
  def window_width
    @window_width
  end
  #
  # 取得列數
  #
  #
  def col_max
    return 3
  end
  #
  # 生成指令清單
  #
  #
  def make_command_list
    add_command(Vocab::ShopBuy,    :buy)
    add_command(Vocab::ShopSell,   :sell,   !@purchase_only)
    add_command(Vocab::ShopCancel, :cancel)
  end
end
