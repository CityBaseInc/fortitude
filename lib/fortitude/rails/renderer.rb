require 'fortitude/rendering_context'
require 'fortitude/erector'

::ActiveSupport::SafeBuffer.class_eval do
  alias_method :fortitude_concat, :original_concat
  public :fortitude_concat
end

module Fortitude
  module Rails
    class Renderer
      class << self
        def render_file(template_identifier, view_paths, template_handler, local_assigns, &block)
          expanded_view_paths = view_paths.map do |path|
            File.expand_path(path.to_s, ::Rails.root.to_s)
          end

          valid_base_classes = [ ::Fortitude::Widget, ::Fortitude::Erector.erector_widget_base_class_if_available ].compact

          widget_class = ::Fortitude::Widget.widget_class_from_file(template_identifier,
            :root_dirs => expanded_view_paths, :valid_base_classes => valid_base_classes)

          is_partial = !! File.basename(template_identifier) =~ /^_/

          render(widget_class, template_handler, local_assigns, is_partial, &block)
        end

        # TODO: Refactor this and render :widget => ... support into one method somewhere.
        def render(widget_class, template_handler, local_assigns, is_partial, &block)
          if ::Fortitude::Erector.is_erector_widget_class?(widget_class)
            return ::Erector::Rails.render(widget_class, template_handler, local_assigns, is_partial, &block)
          end

          total_assigns = template_handler.assigns.symbolize_keys.merge(local_assigns.symbolize_keys)

          needed_assigns = if widget_class.extra_assigns == :use
            total_assigns
          else
            widget_class.extract_needed_assigns_from(total_assigns)
          end

          widget = widget_class.new(needed_assigns)
          template_handler.with_output_buffer do
            rendering_context = template_handler.controller.fortitude_rendering_context_for(template_handler, block)

            # TODO: Refactor this -- both passing it into the constructor and setting yield_block here is gross.
            #
            # We need to call #with_yield_block here, because we can actually be invoked with different yield blocks
            # in the case of "partial layouts" (which most people probably don't even realize exist); we use the same
            # RC for both the initial view rendering and for the partial layout, but they need different yield blocks.
            # Yuck, but this does the job.
            rendering_context.with_yield_block(block) do
              widget.render_to(rendering_context)
            end
            rendering_context.flush!
          end
        end
      end
    end
  end
end
