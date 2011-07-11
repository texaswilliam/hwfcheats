require_relative 'easycmp/easycmp'

class Word
  attr_accessor :val,:uniq,:word
  easy_cmp :@uniq,:@val,:@word

  def initialize word
    larr=letterfy(word)

    @word=word
    @val=larr.collect{|c,n| n*$points[c]}.inject{|sum,val| sum+val}
    @uniq=larr.length
  end

  def to_s
    @word
  end
end
