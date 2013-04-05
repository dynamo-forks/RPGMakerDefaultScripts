#
# This window shows skill and item explanations along with actor status.
#

class Window_Help < Window_Base
  #
  # Object Initialization
  #
  #
  def initialize(line_number = 2)
    super(0, 0, Graphics.width, fitting_height(line_number))
  end
  #
  # Set Text
  #
  #
  def set_text(text)
    if text != @text
      @text = text
      refresh
    end
  end
  #
  # Clear
  #
  #
  def clear
    set_text("")
  end
  #
  # Set Item
  #
  # item : Skills and items etc.
  #
  def set_item(item)
    set_text(item ? item.description : "")
  end
  #
  # Refresh
  #
  #
  def refresh
    contents.clear
    draw_text_ex(4, 0, @text)
  end
end
