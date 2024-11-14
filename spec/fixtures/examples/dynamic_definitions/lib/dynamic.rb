class Dynamic
  ['hoge', 'fuga'].each do |x|
    define_method("print_#{x}") do
      puts x
    end
  end
end

# d = Dynamic.new
# d.print_hoge
# d.print_fuga
