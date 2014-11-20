require 'active_support/concern'
require 'action_controller/metal/renderers'

module Fortitude
  module Rails
    module RenderingMethods
      extend ActiveSupport::Concern

      included do
        alias_method_chain :render, :fortitude
      end

      def fortitude_rendering_context_for(delegate_object, yield_block)
        @_fortitude_rendering_contexts ||= { }
        @_fortitude_rendering_contexts[delegate_object.object_id] ||= create_fortitude_rendering_context(
          :delegate_object => delegate_object, :yield_block => yield_block)
      end

      def create_fortitude_rendering_context(options)
        ::Fortitude::RenderingContext.new(options)
      end

      def self._fortitude_render_widget(controller, widget, options)
        if ::Fortitude::Erector.is_erector_widget_class?(widget) || ::Fortitude::Erector.is_erector_widget_class?(widget.class)
          return ::Erector::Rails.render(widget, controller.view_context, { }, false, options)
        end

        if widget.kind_of?(Class)
          if widget < ::Fortitude::Widget
            widget = widget.new(widget.extract_needed_assigns_from(controller.view_context.assigns))
          else
            raise "You tried to render something using 'render :widget' that is a class, but not a subclass of Fortitude::Widget: #{widget.inspect}"
          end
        end

        if (! widget.kind_of?(::Fortitude::Widget))
          raise "You tried to render something using 'render :widget' that is neither an instance of a subclass of Fortitude::Widget, nor a class that inherits from Fortitude::Widget: #{widget.inspect}"
        end

        rendering_context = controller.create_fortitude_rendering_context(:helpers_object => controller.view_context)
        widget.render_to(rendering_context)

        passed_options = options.dup
        passed_options.delete(:widget)
        passed_options[:text] = rendering_context.output_buffer_holder.output_buffer.to_s
        passed_options[:layout] = true unless passed_options.has_key?(:layout)

        return controller.render_to_string(passed_options)
      end

      def self._fortitude_register_renderer!
        ::ActionController.add_renderer(:widget) do |widget, options|
          ::Fortitude::Rails::RenderingMethods._fortitude_render_widget(self, widget, options)
        end
      end

      def render_with_fortitude(*args, &block)
        if (options = args[0]).kind_of?(Hash) && (widget_block = options[:inline]) && (options[:type] == :fortitude)
          options.delete(:inline)

          rendering_context = fortitude_rendering_context_for(self, nil)
          widget_class = Class.new(Fortitude::Widgets::Html5)
          widget_class.use_instance_variables_for_assigns(true)
          widget_class.extra_assigns(:use)
          widget_class.send(:define_method, :content, &widget_block)

          assigns = { }
          instance_variables.each do |ivar_name|
            value = instance_variable_get(ivar_name)
            assigns[$1.to_sym] = value if ivar_name =~ /^@([^_].*)$/
          end
          assigns = assigns.merge(options[:locals] || { })

          widget = widget_class.new(assigns)
          new_args = [ options.merge(:widget => widget) ] + args[1..-1]
          return render_without_fortitude(*new_args, &block)
        end

        return render_without_fortitude(*args, &block)
      end
    end
  end
end

::Fortitude::Rails::RenderingMethods._fortitude_register_renderer!
