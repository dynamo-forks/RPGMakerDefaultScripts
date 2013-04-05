#
# 处理变量的类。编入的是类 Array 的外壳。本类的实例请参考
# $game_variables。
#

class Game_Variables
  #
  # 初始化
  #
  #
  def initialize
    @data = []
  end
  #
  # 获取变量
  #
  # variable_id : 变量 ID
  #
  def [](variable_id)
    if variable_id <= 5000 and @data[variable_id] != nil
      return @data[variable_id]
    else
      return 0
    end
  end
  #
  # 设置变量
  #
  # variable_id : 变量 ID
  # value       : 变量的值
  #
  def []=(variable_id, value)
    if variable_id <= 5000
      @data[variable_id] = value
    end
  end
end
