#encoding:utf-8
#
# 管理跟隨角色的類。處理跟隨角色的顯示、跟隨的行為等。
# 請在 Game_Followers 類中檢視具體的套用。
#

class Game_Follower < Game_Character
  #
  # 初始化物件
  #
  #
  def initialize(member_index, preceding_character)
    super()
    @member_index = member_index
    @preceding_character = preceding_character
    @transparent = $data_system.opt_transparent
    @through = true
  end
  #
  # 重新整理
  #
  #
  def refresh
    @character_name = visible? ? actor.character_name : ""
    @character_index = visible? ? actor.character_index : 0
  end
  #
  # 取得對應的角色
  #
  #
  def actor
    $game_party.battle_members[@member_index]
  end
  #
  # 可視判定
  #
  #
  def visible?
    actor && $game_player.followers.visible
  end
  #
  # 更新畫面
  #
  #
  def update
    @move_speed     = $game_player.real_move_speed
    @transparent    = $game_player.transparent
    @walk_anime     = $game_player.walk_anime
    @step_anime     = $game_player.step_anime
    @direction_fix  = $game_player.direction_fix
    @opacity        = $game_player.opacity
    @blend_type     = $game_player.blend_type
    super
  end
  #
  # 追隨帶隊角色
  #
  #
  def chase_preceding_character
    unless moving?
      sx = distance_x_from(@preceding_character.x)
      sy = distance_y_from(@preceding_character.y)
      if sx != 0 && sy != 0
        move_diagonal(sx > 0 ? 4 : 6, sy > 0 ? 8 : 2)
      elsif sx != 0
        move_straight(sx > 0 ? 4 : 6)
      elsif sy != 0
        move_straight(sy > 0 ? 8 : 2)
      end
    end
  end
  #
  # 判定角色是否與領隊同一位置
  #
  #
  def gather?
    !moving? && pos?(@preceding_character.x, @preceding_character.y)
  end
end
