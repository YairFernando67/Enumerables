# frozen_string_literal: true

# rubocop:disable Metrics/ModuleLength,
module Enumerable
  # rubocop:disable Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity
  def my_each
    self_item = self
    if block_given?
      self_item.size.times do |i|
        yield(self_item[i])
      end
      self
    else
      to_enum(:my_each)
    end
  end

  def my_each_with_index
    self_item = self
    if block_given?
      i = 0
      while self_item.size > i
        yield(self_item[i], i)
        i += 1
      end
      self_item
    else
      to_enum(:my_each_with_index)
    end
  end

  def my_select
    self_item = self
    if block_given?
      rst = []
      self_item.my_each { |i| rst.push(i) if yield(i) }
      rst
    else
      to_enum(:my_select)
    end
  end

  def my_all?(pattern = nil)
    y = true
    self_item = self
    if block_given?
      self_item.my_each { |x| y = false unless yield(x) }
    elsif !pattern.nil?
      if pattern.is_a? Class
        self_item.my_each { |x| y = false unless x.is_a? pattern }
      elsif pattern.is_a? Regexp
        self_item.my_each { |x| y = false unless x =~ pattern }
      else
        self_item.my_each { |x| y = false unless pattern == x }
      end
    else
      self_item.my_each { |x| y = false unless x }
    end
    y
  end

  def my_any?(pattern = nil)
    y = false
    self_item = self
    if block_given?
      self_item.my_each { |x| y = true if yield(x) }
    elsif pattern.is_a? Regexp
      self_item.my_each { |x| y = true if x =~ pattern }
    elsif pattern.is_a? Class
      self_item.my_each { |x| y = true if x.is_a? pattern }
    elsif pattern
      self_item.my_each { |x| y = true if pattern == x }
    else
      self_item.my_each { |x| y = true if x }
    end
    y
  end

  def my_none?(pattern = nil)
    y = true
    self_item = self
    if block_given?
      self_item.my_each { |x| y = false if yield(x) }
    elsif pattern.is_a? Regexp
      self_item.my_each { |x| y = false if x =~ pattern }
    elsif pattern.is_a? Class
      self_item.my_each { |x| y = false if x.is_a? pattern }
    elsif pattern
      self_item.my_each { |x| y = false if pattern == x }
    else
      self_item.my_each { |x| y = false if x }
    end
    y
  end

  def my_count(args = nil)
    count = 0
    self_item = self
    if args
      self_item.my_each { |x| count += 1 if x == args }
    elsif block_given?
      self_item.my_each { |x| count += 1 if yield(x) }
    else
      count = self_item.size
    end
    count
  end

  def my_map
    arr = []
    my_each do |x|
      return to_enum(:my_map) unless block_given?

      arr << yield(x) || arr << proc.call(i) if block_given?
    end
    arr
  end

  def my_inject(*args)
    rst, sym = inj_param(*args)
    arr = rst ? to_a : to_a[1..-1]
    rst ||= to_a[0]
    if block_given?
      arr.my_each { |i| rst = yield(rst, i) }
    elsif sym
      arr.my_each { |i| rst = rst.public_send(sym, i) }
    end
    rst
  end

  def inj_param(*args)
    rst, sym = nil
    args.my_each do |arg|
      rst = arg if arg.is_a? Numeric
      sym = arg unless arg.is_a? Numeric
    end
    [rst, sym]
  end

  def multiply_els(arr)
    arr.my_inject(:*)
  end
end

p [1,2,3,4,5].my_select{|x,i| x == i}
p [:ses,:s,:att,:red,2,"w"].my_select{|i| i.is_a? Symbol}
p [1,2,3,4,5].my_select{|i| i > 2}
p [1,2,3,4,5].my_select{|i| i < 2}
p [1,2,3,4,5].my_select{|i| i == 2}

p ["MXM", "USA", "RUS", "POR", "hello"].my_select{|i| i == i.upcase}
p ["MXM", "USA", "RUS", "POR", "hello", "heolloeh"].my_select{|i| i == i.reverse}
p ["MXM", "USA", "RUS", "POR", "hello", "heolloeh"].select{|i| i.include? "R"}


ses = "a".to_sym
p s = "a".to_sym
p [ses,s,:att,:red,2,"w"].my_select{|i| i == :a}



# rubocop:enable Metrics/PerceivedComplexity,Metrics/CyclomaticComplexity
# rubocop:enable Metrics/ModuleLength
