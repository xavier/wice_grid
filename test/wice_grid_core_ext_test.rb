
require 'test/unit'

require File.dirname(__FILE__) + '/test_helper.rb'

class WiceGridCoreExtTest < Test::Unit::TestCase
  
  #
  # Hash
  #

  def test_rec_merge
    
    # required for will_paginate
    # read this - http://err.lighthouseapp.com/projects/466/tickets/197-using-param_name-something-page-leads-to-invalid-behavior
    
  end
  
  def test_hash_make_hash
    
    assert_equal({}, Hash.make_hash(:key, nil))
    assert_equal({}, Hash.make_hash(:key, ''))

    assert_equal({:key => "value"}, Hash.make_hash(:key, "value"))
    
  end
  
  def test_hash_deep_clone_yl
    
    a = {}
    b = a.deep_clone_yl
    assert_equal    a, b 
    assert_not_same a, b
    
    a = {'a' => 'b'}
    b = a.deep_clone_yl
    assert_equal    a, b 
    assert_not_same a, b

    a = {'a' => 'b', 'c' => {'d' => 'e'}}
    b = a.deep_clone_yl
    assert_equal    a, b
    assert_equal    a['c'], b['c']
    assert_not_same a, b
    assert_not_same a['c'], b['c']
    
  end
  
  def test_hash_add_or_append_class_value_on_empty_hash
    
    h = {}
    
    h.add_or_append_class_value('foo')
    assert_equal({:class => 'foo'}, h)

    h.add_or_append_class_value('bar')
    assert_equal({:class => 'foo bar'}, h)
        
  end
  
  def test_hash_add_or_append_class_value_key_normalization
    
    h = {'class' => 'foo'}

    h.add_or_append_class_value('bar')
    assert_equal({:class => 'foo bar'}, h)
  
  end
  
  def test_hash_parameter_names_and_values
    
    assert_equal([], {}.parameter_names_and_values)
    assert_equal([], {}.parameter_names_and_values(%w(foo)))

    assert_equal([['a', 'b']], {'a' => 'b'}.parameter_names_and_values)
    assert_equal([['a', 'b']], {'a' => 'b'}.parameter_names_and_values)
    assert_equal([['a', 'b'], ['c[d]', 'e']], {'a' => 'b', 'c' => {'d' => 'e'}}.parameter_names_and_values)
    
    assert_equal([['foo[a]', 'b']], {'a' => 'b'}.parameter_names_and_values(%w(foo)))
    assert_equal([['foo[a]', 'b'], ['foo[c][d]', 'e']], {'a' => 'b', 'c' => {'d' => 'e'}}.parameter_names_and_values(%w(foo)))

  end

  #
  # Enumerable
  # 

  def test_enumerable_all_items_are_of_class
    
    assert([].respond_to?(:all_items_are_of_class))
    assert({}.respond_to?(:all_items_are_of_class))
    
    assert_equal false, [].all_items_are_of_class(Object)
    
    assert_equal true, [1, 2, 3].all_items_are_of_class(Numeric)
    assert_equal true, %(one two three).all_items_are_of_class(String)

    assert_equal false, [1, 2, "apple"].all_items_are_of_class(String)
    assert_equal false, [1, 2, nil].all_items_are_of_class(String)
    assert_equal false, [1, 2.5].all_items_are_of_class(String)

    assert_equal true, [1, 2, "apple"].all_items_are_of_class(Object)
    
  end
  
  #
  # Object
  #
  
  def test_object_deep_send
    
    wrapper = Struct.new(:hop)
    
    z = wrapper.new(123)
    y = wrapper.new(z)
    x = wrapper.new(y)
    
    assert_equal x, x.deep_send
    assert_equal y, x.deep_send(:hop)
    assert_equal z, x.deep_send(:hop, :hop)
    assert_equal 123, x.deep_send(:hop, :hop, :hop)
    
    assert_nil x.deep_send(:non_existing_method)
    assert_nil x.deep_send(:hop, :non_existing_method)
    
  end
  
  
  #
  # Array
  #
  
  def test_array_to_parameter_name
    
    assert_equal '', [].to_parameter_name
    assert_equal 'foo', %w(foo).to_parameter_name
    assert_equal 'foo[bar]', %w(foo bar).to_parameter_name
    assert_equal 'foo[bar][baz]', %w(foo bar baz).to_parameter_name
    
  end
  
  #
  # ActionView
  #
  
  include ActionView::Helpers::TagHelper
  
  def test_action_view_tag_options_visibility
    # Probably not Good Enough
    assert_nothing_raised {
      tag_options({})
    }
  end
  

end
