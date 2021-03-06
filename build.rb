#!/usr/bin/env ruby
require 'optparse'
require_relative 'points'
require_relative 'word'

num=10
all=false
OptionParser.new do |opts|
  opts.banner=<<-BANNER
Usage: build [options] LETTERS
LETTERS are the letters you have in your rack for building words.
  BANNER

  opts.on('-n','--num INT',Integer,'Print given number of solutions.') do |n|
    num=n
  end

  opts.on('-a','--all','Display all solutions.') { all=true }

  opts.on_tail('-h','--help','Show this message') do
    puts opts
    exit
  end
end.parse!

list=[]
letters=Word.letterfy(ARGV.join.downcase.delete('^a-z'))
exit if letters.length < 4
File.open("enable1.txt") do |f| f.each do |line|
    line.chomp!
    next if line.length < 4 or line.length > 8
    larr=Word.letterfy(line)
    list << Word.new(line) if larr.all?{|c,n| n<=letters[c]}
  end
end

begin
  list.sort!
  (all ? list : list.first(num)).each do |word|
    print (word.to_s+'.').ljust(11),word.val.to_s.ljust(6)
    puts word.uniq
  end
rescue Errno::EPIPE
  exit
end
