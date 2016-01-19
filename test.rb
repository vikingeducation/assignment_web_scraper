require 'pp'
pp ['kit','kelsey','erik','chris'].combination(2).to_a.combination(2).to_a.reject { |pair| pair.flatten.uniq.size < 4}

# >> [[["kit", "kelsey"], ["erik", "chris"]],
# >>  [["kit", "erik"], ["kelsey", "chris"]],
# >>  [["kit", "chris"], ["kelsey", "erik"]]]
