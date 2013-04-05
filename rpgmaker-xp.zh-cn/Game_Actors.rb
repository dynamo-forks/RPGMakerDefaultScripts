#
# 处理角色排列的类。本类的实例请参考
# $game_actors。
#

class Game_Actors
  #
  # 初始化对像
  #
  #
  def initialize
    @data = []
  end
  #
  # 获取角色
  #
  # actor_id : 角色 ID
  #
  def [](actor_id)
    if actor_id > 999 or $data_actors[actor_id] == nil
      return nil
    end
    if @data[actor_id] == nil
      @data[actor_id] = Game_Actor.new(actor_id)
    end
    return @data[actor_id]
  end
end
