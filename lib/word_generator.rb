class WordGenerator
  def initialize()
    @word_list = "././google-10000-english-no-swears.txt"
    @word_length_min = 5
    @word_length_max = 12
  end

  def convert_txt_to_arr(txt)
    word_arr = []

    File.open(txt, 'r') do |f|
      f.each_line do |line|
        line = line[0..line.length-2] #Removes \n
        word_arr << line if line.length < @word_length_max && line.length > @word_length_min
      end
    end

    word_arr
  end

  def generate_word()
    word_arr = convert_txt_to_arr(@word_list)
    word_arr.sample
  end

end