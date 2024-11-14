class Bird; end

class Duck < Bird
  def cry; puts "Quack"; end
end

class Goose < Bird
  def cry; puts "Gabble"; end
end

def make_sound(bird)
  bird.cry
end

# make_sound(Duck.new)
# make_sound(Goose.new)
