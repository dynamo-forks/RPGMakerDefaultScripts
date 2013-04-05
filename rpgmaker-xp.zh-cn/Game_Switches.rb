#
# 处理开关的类。编入的是类 Array 的外壳。本类的实例请参考
# $game_switches。
#

class Game_Switches
  #
  # 初始化对像
  #
  #
  def initialize
    @data = []
  end
  #
  # 获取开关
  #
  # switch_id : 开关 ID
  #
  def [](switch_id)
    if switch_id <= 5000 and @data[switch_id] != nil
      return @data[switch_id]
    else
      return false
    end
  end
  #
  # 设置开关
  #
  # switch_id : 开关 ID
  # value     : ON (true) / OFF (false)
  #
  def []=(switch_id, value)
    if switch_id <= 5000
      @data[switch_id] = value
    end
  end
end
