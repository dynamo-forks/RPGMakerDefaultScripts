#
# 处理公共事件的类。包含执行并行事件的功能。
# 本类在 Game_Map 类 ($game_map) 的内部使用。
#

class Game_CommonEvent
  #
  # 初始对像
  #
  # common_event_id : 公共事件 ID
  #
  def initialize(common_event_id)
    @common_event_id = common_event_id
    @interpreter = nil
    refresh
  end
  #
  # 获取名称
  #
  #
  def name
    return $data_common_events[@common_event_id].name
  end
  #
  # 获取目标
  #
  #
  def trigger
    return $data_common_events[@common_event_id].trigger
  end
  #
  # 获取条件开关 ID
  #
  #
  def switch_id
    return $data_common_events[@common_event_id].switch_id
  end
  #
  # 获取执行内容
  #
  #
  def list
    return $data_common_events[@common_event_id].list
  end
  #
  # 刷新
  #
  #
  def refresh
    # 建立必须的处理并行事件用的解释器
    if self.trigger == 2 and $game_switches[self.switch_id] == true
      if @interpreter == nil
        @interpreter = Interpreter.new
      end
    else
      @interpreter = nil
    end
  end
  #
  # 更新画面
  #
  #
  def update
    # 并行处理有效的情况下
    if @interpreter != nil
      # 如果不是在执行中就设置
      unless @interpreter.running?
        @interpreter.setup(self.list, 0)
      end
      # 更新解释器
      @interpreter.update
    end
  end
end
