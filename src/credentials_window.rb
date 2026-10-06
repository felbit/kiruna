require 'glimmer-dsl-libui'
require_relative 'non_stretchy_form_fields'

class CredentialsWindow
  include Glimmer

  def initialize(on_connect:, on_cancel:)
    @window = window('Login to Service', 360, 120) {
      margined true

      vertical_box {
        form {
          stretchy false
          @host = entry { label 'Host'; text 'localhost' }
          @user = entry { label 'User'; text ENV['USER'] }
          @password = password_entry { label 'Password' }
        }
        button('Connect') {
          stretchy false
          on_clicked do
            on_connect.call(host: @host.text, user: @user.text, password: @password.text)
          end
        }
      }

      on_closing do
        on_cancel.call
        0 # keep the app running
      end
    }
  end

  def show = ::LibUI.control_show(@window.libui)
  def close = @window.destroy
  def show_error(message) = msg_box_error(@window, 'Connection failed', message)
end