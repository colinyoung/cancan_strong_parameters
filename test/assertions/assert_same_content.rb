module MiniTest::Expectations
  def assert_same_content(item, other_item, verb=:assert)  
    item.each do |attrs|
      value = attrs.last
      key = attrs.first if attrs.length > 1
      
      
      other_value = other_item[key] if self.is_a?(Hash)
      
      if other_value.present?
        if value.respond_to? :same_as?
          send verb, value.same_as?(other_value), "#{value} was not same as #{other_value}."
        else
          send "#{verb}_equal", value, other_value
        end
      else
        send verb, item.same_as?(other_item), "#{item} was not the same as #{other_item}."
      end
    end
  end
  
  def refute_same_content(item, other_item)
    assert_same_content(item, other_item, :refute)
  end
end

class Array
  def same_as?(other_ary)
    cpy = dup
    other_cpy = other_ary.dup
    each do |item|
      case item
      when Array, Hash
        cpy.delete(item) if other_ary.any? { |other_item| other_item.same_as?(item) && other_cpy.delete(other_item) }
      else
        cpy.delete(item) if other_ary.include?(item) && other_cpy.delete(item)
      end
    end
    
    cpy.empty? and other_cpy.empty?
  end
end

class Hash
  def same_as?(other_hsh)
    return false unless self.keys.count == other_hsh.keys.count
    each do |key, value|
      return false unless other_hsh.has_key? key
      
      other_value = other_hsh[key]
      if value.respond_to? :same_as?
        return false unless value.same_as? other_value
      else
        return false unless value == other_value
      end
    end
    
    true
  end
end