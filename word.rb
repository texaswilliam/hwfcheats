require_relative 'easycmp/easycmp'

class Word
  attr_accessor :val,:uniq,:word
  easy_cmp :@uniq,:@val,:@word

  def initialize word
    larr=Word.letterfy(word)

    @word=word
    @val=larr.collect{|c,n| n*$points[c]}.inject{|sum,val| sum+val}
    @uniq=larr.length
  end

  def self.letterfy str
    h=Hash.new(0)
    str.each_char{|c| h[c]=(h[c].nil? ? 1 : h[c]+1)}
    return h
  end

  def to_s
    @word
  end
end
