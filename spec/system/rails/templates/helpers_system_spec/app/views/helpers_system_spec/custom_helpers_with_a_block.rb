class Views::HelpersSystemSpec::CustomHelpersWithABlock < Fortitude::Widget
  def content
    result = (reverse_it { |v| "abc#{v}def" })
    text result
  end
end
