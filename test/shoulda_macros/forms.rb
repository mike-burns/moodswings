class Test::Unit::TestCase
  def assert_labeled_select(selector, input_name)
    assert_select 'label[for=?]', input_name.gsub('[','_').gsub(']','')
    assert_select selector, input_name
  end
end
