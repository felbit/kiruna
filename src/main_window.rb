require 'glimmer-dsl-libui'

class MainWindow
  include Glimmer

  attr_accessor :sidebar_visible, :bottom_visible, :inspector_visible

  def initialize(databases:, on_disconnect:, on_close:)
    @sidebar_visible = @bottom_visible = @inspector_visible = true

    @window = window('Kiruna', 800, 600) {
      vertical_box {
        horizontal_box {
          stretchy false

          label
          button('L') {
            stretchy false
            on_clicked { self.sidebar_visible = !sidebar_visible }
          }
          button('B') {
            stretchy false
            on_clicked { self.bottom_visible = !bottom_visible }
          }
          button('R') {
            stretchy false
            on_clicked { self.inspector_visible = !inspector_visible }
          }
        }

        horizontal_box {
          group('Sidebar') {
            visible bind(self, :sidebar_visible, read_only: true)
            label 'Databases'
          }

          group('Content') {
            label 'Content Area'
          }
          group('Inspector') {
            visible bind(self, :inspector_visible, read_only: true)
            label 'Details'
          }
        }

        group('Bottom') {
          stretchy false
          label 'Output'
          visible bind(self, :bottom_visible, read_only: true)
        }
      }

      on_closing do
        on_close.call
        nil # quit the app
      end
    }
  end

  def show = @window.show
  def close = @window.close
  def enabled=(value)
    @window.enabled = value
  end
end
