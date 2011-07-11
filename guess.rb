#!/usr/bin/env ruby
require 'optparse'

blank=?_

num_to_print=10
all=false
OptionParser.new do |opts|
  opts.banner=<<-BANNER
    Usage: build [options] WORD KNOWN-NOT
    WORD is the word in HWF, with _ in the appropriate places for blanks.
    KNOWN-NOT are letters already guessed and shown in red.
  BANNER

  opts.on('-n','--num INT',Integer,'Print top INT of letters.') do |n|
    num=n
  end

  opts.on('-a','--all','Display all letters.') { all=true }

  opts.on_tail('-h','--help','Show this message') do
    puts opts
    exit
  end
end.parse!

word=ARGV[0].delete('^a-z'+blank).chars.collect{|c| c==blank ? nil : c}
nots=(ARGV[1..-1].join.delete('^a-z').chars.to_a+word.compact).uniq.join
regex=Regexp.compile("^#{word.collect{|c| c.nil? ? "[^#{nots}]" : c}.join}$")

letters=Hash.new(0)
num_of_matches=0

File.open('enable1.txt') {|f| f.each do |line|
    line.chomp!
    if regex.match(line)
      already_added=[]
      word.zip(line.chars.to_a).each do |orig,guess|
        if orig.nil? and not already_added.include?(guess)
          letters[guess]+=1
          already_added << guess
        end
      end
      num_of_matches+=1
    end
end}

unless letters.length == 0
  letters.sort{|a,b| (b[1]<=>a[1]).nonzero? || a[0]<=>b[0]}
    .collect{|el| el[0]+('%3.1f' % (el[1]*100.0/num_of_matches)).rjust(6)+'%'}
    .each do |str|
      unless all
        exit unless num_to_print>0
        num_to_print-=1
      end
      puts str
    end
else
  puts 'Either you\'ve gotten the word or it\'s not in the dictionary. :|'
end
