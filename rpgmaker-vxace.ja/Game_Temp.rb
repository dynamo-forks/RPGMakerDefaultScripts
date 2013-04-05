#
# セーブデータに含まれない、一時的なデータを扱うクラスです。このクラスのイン
# スタンスは $game_temp で参照されます。
#

class Game_Temp
  #
  # 公開インスタンス変数
  #
  #
  attr_reader   :common_event_id          # コモンイベント ID
  attr_accessor :fade_type                # 場所移動時のフェードタイプ
  #
  # オブジェクト初期化
  #
  #
  def initialize
    @common_event_id = 0
    @fade_type = 0
  end
  #
  # コモンイベントの呼び出しを予約
  #
  #
  def reserve_common_event(common_event_id)
    @common_event_id = common_event_id
  end
  #
  # コモンイベントの呼び出し予約をクリア
  #
  #
  def clear_common_event
    @common_event_id = 0
  end
  #
  # コモンイベント呼び出しの予約判定
  #
  #
  def common_event_reserved?
    @common_event_id > 0
  end
  #
  # 予約されているコモンイベントを取得
  #
  #
  def reserved_common_event
    $data_common_events[@common_event_id]
  end
end
