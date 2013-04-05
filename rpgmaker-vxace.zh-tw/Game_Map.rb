#encoding:utf-8
#
# 管理地圖的類。擁有卷動地圖以及判斷通行度的功能。
# 本類的案例請參考 $game_map 。
#

class Game_Map
  #
  # 定義案例變量
  #
  #
  attr_reader   :screen                   # 地圖畫面的狀態
  attr_reader   :interpreter              # 地圖事件用事件解釋器
  attr_reader   :events                   # 事件
  attr_reader   :display_x                # 顯示 X 坐標
  attr_reader   :display_y                # 顯示 Y 坐標
  attr_reader   :parallax_name            # 遠景圖檔名
  attr_reader   :vehicles                 # 載具
  attr_reader   :battleback1_name         # 戰鬥背景（地面）檔名
  attr_reader   :battleback2_name         # 戰鬥背景（牆壁）檔名
  attr_accessor :name_display             # 地圖名顯示的標志
  attr_accessor :need_refresh             # 重新整理要求的標志
  #
  # 初始化物件
  #
  #
  def initialize
    @screen = Game_Screen.new
    @interpreter = Game_Interpreter.new
    @map_id = 0
    @events = {}
    @display_x = 0
    @display_y = 0
    create_vehicles
    @name_display = true
  end
  #
  # 設定
  #
  #
  def setup(map_id)
    @map_id = map_id
    @map = load_data(sprintf("Data/Map%03d.rvdata2", @map_id))
    @tileset_id = @map.tileset_id
    @display_x = 0
    @display_y = 0
    referesh_vehicles
    setup_events
    setup_scroll
    setup_parallax
    setup_battleback
    @need_refresh = false
  end
  #
  # 生成載具
  #
  #
  def create_vehicles
    @vehicles = []
    @vehicles[0] = Game_Vehicle.new(:boat)
    @vehicles[1] = Game_Vehicle.new(:ship)
    @vehicles[2] = Game_Vehicle.new(:airship)
  end
  #
  # 更新載具
  #
  #
  def referesh_vehicles
    @vehicles.each {|vehicle| vehicle.refresh }
  end
  #
  # 取得載具
  #
  #
  def vehicle(type)
    return @vehicles[0] if type == :boat
    return @vehicles[1] if type == :ship
    return @vehicles[2] if type == :airship
    return nil
  end
  #
  # 取得小舟
  #
  #
  def boat
    @vehicles[0]
  end
  #
  # 取得大船
  #
  #
  def ship
    @vehicles[1]
  end
  #
  # 取得飛艇
  #
  #
  def airship
    @vehicles[2]
  end
  #
  # 設定事件
  #
  #
  def setup_events
    @events = {}
    @map.events.each do |i, event|
      @events[i] = Game_Event.new(@map_id, event)
    end
    @common_events = parallel_common_events.collect do |common_event|
      Game_CommonEvent.new(common_event.id)
    end
    refresh_tile_events
  end
  #
  # 取得並行處理的公共事件的數組
  #
  #
  def parallel_common_events
    $data_common_events.select {|event| event && event.parallel? }
  end
  #
  # 設定卷動
  #
  #
  def setup_scroll
    @scroll_direction = 2
    @scroll_rest = 0
    @scroll_speed = 4
  end
  #
  # 設定遠景圖
  #
  #
  def setup_parallax
    @parallax_name = @map.parallax_name
    @parallax_loop_x = @map.parallax_loop_x
    @parallax_loop_y = @map.parallax_loop_y
    @parallax_sx = @map.parallax_sx
    @parallax_sy = @map.parallax_sy
    @parallax_x = 0
    @parallax_y = 0
  end
  #
  # 設定戰鬥背景
  #
  #
  def setup_battleback
    if @map.specify_battleback
      @battleback1_name = @map.battleback1_name
      @battleback2_name = @map.battleback2_name
    else
      @battleback1_name = nil
      @battleback2_name = nil
    end
  end
  #
  # 設定顯示位置
  #
  #
  def set_display_pos(x, y)
    x = [0, [x, width - screen_tile_x].min].max unless loop_horizontal?
    y = [0, [y, height - screen_tile_y].min].max unless loop_vertical?
    @display_x = (x + width) % width
    @display_y = (y + height) % height
    @parallax_x = x
    @parallax_y = y
  end
  #
  # 計算遠景圖顯示的原點 X 坐標
  #
  #
  def parallax_ox(bitmap)
    if @parallax_loop_x
      @parallax_x * 16
    else
      w1 = [bitmap.width - Graphics.width, 0].max
      w2 = [width * 32 - Graphics.width, 1].max
      @parallax_x * 16 * w1 / w2
    end
  end
  #
  # 計算遠景圖顯示的原點 Y 坐標
  #
  #
  def parallax_oy(bitmap)
    if @parallax_loop_y
      @parallax_y * 16
    else
      h1 = [bitmap.height - Graphics.height, 0].max
      h2 = [height * 32 - Graphics.height, 1].max
      @parallax_y * 16 * h1 / h2
    end
  end
  #
  # 取得地圖 ID
  #
  #
  def map_id
    @map_id
  end
  #
  # 取得圖塊組
  #
  #
  def tileset
    $data_tilesets[@tileset_id]
  end
  #
  # 取得顯示名稱
  #
  #
  def display_name
    @map.display_name
  end
  #
  # 取得寬度
  #
  #
  def width
    @map.width
  end
  #
  # 取得高度
  #
  #
  def height
    @map.height
  end
  #
  # 取得是否橫印循環
  #
  #
  def loop_horizontal?
    @map.scroll_type == 2 || @map.scroll_type == 3
  end
  #
  # 取得是否直印循環
  #
  #
  def loop_vertical?
    @map.scroll_type == 1 || @map.scroll_type == 3
  end
  #
  # 取得是否禁止跑步
  #
  #
  def disable_dash?
    @map.disable_dashing
  end
  #
  # 取得遇敵清單
  #
  #
  def encounter_list
    @map.encounter_list
  end
  #
  # 取得遇敵步數
  #
  #
  def encounter_step
    @map.encounter_step
  end
  #
  # 取得地圖資料
  #
  #
  def data
    @map.data
  end
  #
  # 是否環球類型
  #
  #
  def overworld?
    tileset.mode == 0
  end
  #
  # 畫面的橫印圖塊數
  #
  #
  def screen_tile_x
    Graphics.width / 32
  end
  #
  # 畫面的直印圖塊數
  #
  #
  def screen_tile_y
    Graphics.height / 32
  end
  #
  # 計算顯示坐標的剩餘 X 坐標
  #
  #
  def adjust_x(x)
    if loop_horizontal? && x < @display_x - (width - screen_tile_x) / 2
      x - @display_x + @map.width
    else
      x - @display_x
    end
  end
  #
  # 計算顯示坐標的剩餘 Y 坐標
  #
  #
  def adjust_y(y)
    if loop_vertical? && y < @display_y - (height - screen_tile_y) / 2
      y - @display_y + @map.height
    else
      y - @display_y
    end
  end
  #
  # 計算循環修正後的 X 坐標
  #
  #
  def round_x(x)
    loop_horizontal? ? (x + width) % width : x
  end
  #
  # 計算循環修正後的 Y 坐標
  #
  #
  def round_y(y)
    loop_vertical? ? (y + height) % height : y
  end
  #
  # 計算特定方向推移一個圖塊的 X 坐標（沒有循環修正）
  #
  #
  def x_with_direction(x, d)
    x + (d == 6 ? 1 : d == 4 ? -1 : 0)
  end
  #
  # 計算特定方向推移一個圖塊的 Y 坐標（沒有循環修正）
  #
  #
  def y_with_direction(y, d)
    y + (d == 2 ? 1 : d == 8 ? -1 : 0)
  end
  #
  # 計算特定方向推移一個圖塊的 X 坐標（沒有循環修正）
  #
  #
  def round_x_with_direction(x, d)
    round_x(x + (d == 6 ? 1 : d == 4 ? -1 : 0))
  end
  #
  # 計算特定方向推移一個圖塊的 Y 坐標（沒有循環修正）
  #
  #
  def round_y_with_direction(y, d)
    round_y(y + (d == 2 ? 1 : d == 8 ? -1 : 0))
  end
  #
  # 自動切換 BGM / BGS 
  #
  #
  def autoplay
    @map.bgm.play if @map.autoplay_bgm
    @map.bgs.play if @map.autoplay_bgs
  end
  #
  # 重新整理
  #
  #
  def refresh
    @events.each_value {|event| event.refresh }
    @common_events.each {|event| event.refresh }
    refresh_tile_events
    @need_refresh = false
  end
  #
  # 更新圖塊事件的數組
  #
  #
  def refresh_tile_events
    @tile_events = @events.values.select {|event| event.tile? }
  end
  #
  # 取得指定坐標處存在的事件的數組
  #
  #
  def events_xy(x, y)
    @events.values.select {|event| event.pos?(x, y) }
  end
  #
  # 取得指定坐標處存在的事件（穿透以外）的數組
  #
  #
  def events_xy_nt(x, y)
    @events.values.select {|event| event.pos_nt?(x, y) }
  end
  #
  # 取得指定坐標處存在的圖塊事件（穿透以外）的數組
  #
  #
  def tile_events_xy(x, y)
    @tile_events.select {|event| event.pos_nt?(x, y) }
  end
  #
  # 取得指定坐標處存在的事件的 ID （僅一個）
  #
  #
  def event_id_xy(x, y)
    list = events_xy(x, y)
    list.empty? ? 0 : list[0].id
  end
  #
  # 向下卷動
  #
  #
  def scroll_down(distance)
    if loop_vertical?
      @display_y += distance
      @display_y %= @map.height
      @parallax_y += distance if @parallax_loop_y
    else
      last_y = @display_y
      @display_y = [@display_y + distance, height - screen_tile_y].min
      @parallax_y += @display_y - last_y
    end
  end
  #
  # 向左卷動
  #
  #
  def scroll_left(distance)
    if loop_horizontal?
      @display_x += @map.width - distance
      @display_x %= @map.width 
      @parallax_x -= distance if @parallax_loop_x
    else
      last_x = @display_x
      @display_x = [@display_x - distance, 0].max
      @parallax_x += @display_x - last_x
    end
  end
  #
  # 向右卷動
  #
  #
  def scroll_right(distance)
    if loop_horizontal?
      @display_x += distance
      @display_x %= @map.width
      @parallax_x += distance if @parallax_loop_x
    else
      last_x = @display_x
      @display_x = [@display_x + distance, (width - screen_tile_x)].min
      @parallax_x += @display_x - last_x
    end
  end
  #
  # 向上卷動
  #
  #
  def scroll_up(distance)
    if loop_vertical?
      @display_y += @map.height - distance
      @display_y %= @map.height
      @parallax_y -= distance if @parallax_loop_y
    else
      last_y = @display_y
      @display_y = [@display_y - distance, 0].max
      @parallax_y += @display_y - last_y
    end
  end
  #
  # 有效坐標判定
  #
  #
  def valid?(x, y)
    x >= 0 && x < width && y >= 0 && y < height
  end
  #
  # 通行檢查
  #
  # bit : 判斷通行禁止與否的位元組（請參照二進位運算）
  #
  def check_passage(x, y, bit)
    all_tiles(x, y).each do |tile_id|
      flag = tileset.flags[tile_id]
      next if flag & 0x10 != 0            # [☆] : 不影響通行
      return true  if flag & bit == 0     # [○] : 可以通行
      return false if flag & bit == bit   # [×] : 不能通行
    end
    return false                          # 不能通行
  end
  #
  # 取得指定坐標處的圖塊 ID 
  #
  #
  def tile_id(x, y, z)
    @map.data[x, y, z] || 0
  end
  #
  # （由上至下）取得指定坐標處所有層次的圖塊數組
  #
  #
  def layered_tiles(x, y)
    [2, 1, 0].collect {|z| tile_id(x, y, z) }
  end
  #
  # 取得指定坐標處的所有圖塊數組（內含事件）
  #
  #
  def all_tiles(x, y)
    tile_events_xy(x, y).collect {|ev| ev.tile_id } + layered_tiles(x, y)
  end
  #
  # 取得指定坐標處的自動原件種類
  #
  #
  def autotile_type(x, y, z)
    tile_id(x, y, z) >= 2048 ? (tile_id(x, y, z) - 2048) / 48 : -1
  end
  #
  # 判定普通角色是否可以通行
  #
  # d : 方向（2,4,6,8）
  # 判斷該位置的圖塊指定方向的通行度。
  #
  def passable?(x, y, d)
    check_passage(x, y, (1 << (d / 2 - 1)) & 0x0f)
  end
  #
  # 判定小舟是否可以通行
  #
  #
  def boat_passable?(x, y)
    check_passage(x, y, 0x0200)
  end
  #
  # 判定大船是否可以通行
  #
  #
  def ship_passable?(x, y)
    check_passage(x, y, 0x0400)
  end
  #
  # 判定飛艇是否可以著陸
  #
  #
  def airship_land_ok?(x, y)
    check_passage(x, y, 0x0800) && check_passage(x, y, 0x0f)
  end
  #
  # 判定指定坐標處所有層次的標志
  #
  #
  def layered_tiles_flag?(x, y, bit)
    layered_tiles(x, y).any? {|tile_id| tileset.flags[tile_id] & bit != 0 }
  end
  #
  # 判定是否梯子
  #
  #
  def ladder?(x, y)
    valid?(x, y) && layered_tiles_flag?(x, y, 0x20)
  end
  #
  # 判定是否草木茂密處
  #
  #
  def bush?(x, y)
    valid?(x, y) && layered_tiles_flag?(x, y, 0x40)
  end
  #
  # 判定是否櫃台屬性
  #
  #
  def counter?(x, y)
    valid?(x, y) && layered_tiles_flag?(x, y, 0x80)
  end
  #
  # 判定是否有害地形
  #
  #
  def damage_floor?(x, y)
    valid?(x, y) && layered_tiles_flag?(x, y, 0x100)
  end
  #
  # 取得地形標志
  #
  #
  def terrain_tag(x, y)
    return 0 unless valid?(x, y)
    layered_tiles(x, y).each do |tile_id|
      tag = tileset.flags[tile_id] >> 12
      return tag if tag > 0
    end
    return 0
  end
  #
  # 取得區域 ID 
  #
  #
  def region_id(x, y)
    valid?(x, y) ? @map.data[x, y, 3] >> 8 : 0
  end
  #
  # 開始卷動
  #
  #
  def start_scroll(direction, distance, speed)
    @scroll_direction = direction
    @scroll_rest = distance
    @scroll_speed = speed
  end
  #
  # 判定是否卷動中
  #
  #
  def scrolling?
    @scroll_rest > 0
  end
  #
  # 更新畫面
  #
  # main : 事件解釋器更新的標志
  #
  def update(main = false)
    refresh if @need_refresh
    update_interpreter if main
    update_scroll
    update_events
    update_vehicles
    update_parallax
    @screen.update
  end
  #
  # 更新卷動
  #
  #
  def update_scroll
    return unless scrolling?
    last_x = @display_x
    last_y = @display_y
    do_scroll(@scroll_direction, scroll_distance)
    if @display_x == last_x && @display_y == last_y
      @scroll_rest = 0
    else
      @scroll_rest -= scroll_distance
    end
  end
  #
  # 計算卷動的距離
  #
  #
  def scroll_distance
    2 ** @scroll_speed / 256.0
  end
  #
  # 執行卷動
  #
  #
  def do_scroll(direction, distance)
    case direction
    when 2;  scroll_down (distance)
    when 4;  scroll_left (distance)
    when 6;  scroll_right(distance)
    when 8;  scroll_up   (distance)
    end
  end
  #
  # 更新事件
  #
  #
  def update_events
    @events.each_value {|event| event.update }
    @common_events.each {|event| event.update }
  end
  #
  # 更新載具
  #
  #
  def update_vehicles
    @vehicles.each {|vehicle| vehicle.update }
  end
  #
  # 更新遠景圖
  #
  #
  def update_parallax
    @parallax_x += @parallax_sx / 64.0 if @parallax_loop_x
    @parallax_y += @parallax_sy / 64.0 if @parallax_loop_y
  end
  #
  # 變更圖塊組
  #
  #
  def change_tileset(tileset_id)
    @tileset_id = tileset_id
    refresh
  end
  #
  # 變更戰鬥背景
  #
  #
  def change_battleback(battleback1_name, battleback2_name)
    @battleback1_name = battleback1_name
    @battleback2_name = battleback2_name
  end
  #
  # 變更遠景圖
  #
  #
  def change_parallax(name, loop_x, loop_y, sx, sy)
    @parallax_name = name
    @parallax_x = 0 if @parallax_loop_x && !loop_x
    @parallax_y = 0 if @parallax_loop_y && !loop_y
    @parallax_loop_x = loop_x
    @parallax_loop_y = loop_y
    @parallax_sx = sx
    @parallax_sy = sy
  end
  #
  # 更新事件解釋器
  #
  #
  def update_interpreter
    loop do
      @interpreter.update
      return if @interpreter.running?
      if @interpreter.event_id > 0
        unlock_event(@interpreter.event_id)
        @interpreter.clear
      end
      return unless setup_starting_event
    end
  end
  #
  # 解鎖事件
  #
  #
  def unlock_event(event_id)
    @events[event_id].unlock if @events[event_id]
  end
  #
  # 設定啟動中事件
  #
  #
  def setup_starting_event
    refresh if @need_refresh
    return true if @interpreter.setup_reserved_common_event
    return true if setup_starting_map_event
    return true if setup_autorun_common_event
    return false
  end
  #
  # 判定是否擁有啟動中地圖事件
  #
  #
  def any_event_starting?
    @events.values.any? {|event| event.starting }
  end
  #
  # 檢驗／設定啟動中的地圖事件
  #
  #
  def setup_starting_map_event
    event = @events.values.find {|event| event.starting }
    event.clear_starting_flag if event
    @interpreter.setup(event.list, event.id) if event
    event
  end
  #
  # 檢驗／設定自動執行的公共事件
  #
  #
  def setup_autorun_common_event
    event = $data_common_events.find do |event|
      event && event.autorun? && $game_switches[event.switch_id]
    end
    @interpreter.setup(event.list) if event
    event
  end
end
