class Views::CaptureSystemSpec::CaptureErbFromWidget < Fortitude::Widget
  def content
    widget_text = capture do
      render :partial => 'some_erb_partial'
    end

    text "Widget text is: "
    text widget_text
    text "END"
  end
end