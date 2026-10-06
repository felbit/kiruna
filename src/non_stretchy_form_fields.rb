require 'glimmer-dsl-libui'

module NonStretchyFormFields
  def post_initialize_child(child)
    child.stretchy = false if child.stretchy.nil?
    super
  end
end

Glimmer::LibUI::ControlProxy::FormProxy.prepend(NonStretchyFormFields)
