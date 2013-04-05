#
# This window displays the amount of gold.
#

class Window_Gold < Window_Base
  #
  # Object Initialization
  #
  # x : window X coordinate
  # y : window Y coordinate
  #
  def initialize(x, y)
    super(x, y, 160, WLH + 32)
    refresh
  end
  #
  # Refresh
  #
  #
  def refresh
    self.contents.clear
    draw_currency_value($game_party.gold, 4, 0, 120)
  end
end
