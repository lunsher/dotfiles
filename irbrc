#!/usr/bin/ruby
#require 'irb/completion'
require "rubygems"
require 'bond'
require "awesome_print"
require 'hirb'

begin
  require 'wirble'

  # init wirble
  Wirble.init
  Wirble.colorize
rescue LoadError => err
  $stderr.puts "Couldn't load Wirble: #{err}"
end

unless IRB.version.include?('DietRB')
  IRB::Irb.class_eval do
    def output_value
      ap @context.last_value
    end
  end
else # MacRuby
  IRB.formatter = Class.new(IRB::Formatter) do
    def inspect_object(object)
      object.ai
    end
  end.new
end



#Hirb.enable

Bond.start
# For users using a pure ruby readline
#Bond.start :readline => :ruby

#require 'irb/ext/save-history'

#IRB.conf[:SAVE_HISTORY] = 1000
#IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb_history"


unless RUBY_PLATFORM.include?('darwin')
  require 'irb/ext/save-history'
  ARGV.concat [ "--readline"]
end
IRB.conf[:SAVE_HISTORY] = 100    
IRB.conf[:HISTORY_FILE] = "#{ENV['HOME']}/.irb-save-history"
IRB.conf[:PROMPT_MODE] = :SIMPLE

%w[rubygems looksee/shortcuts wirble].each do |gem|
  begin
    require gem
  rescue LoadError
  end
end

class Object
  # list methods which aren't in superclass
  def local_methods(obj = self)
    (obj.methods - obj.class.superclass.instance_methods).sort
  end
  
  # print documentation
  #
  #   ri 'Array#pop'
  #   Array.ri
  #   Array.ri :pop
  #   arr.ri :pop
  def ri(method = nil)
    unless method && method =~ /^[A-Z]/ # if class isn't specified
      klass = self.kind_of?(Class) ? name : self.class.name
      method = [klass, method].compact.join('#')
    end
    system 'ri', method.to_s
  end
end

def copy(str)
  IO.popen('pbcopy', 'w') { |f| f << str.to_s }
end

def copy_history
  history = Readline::HISTORY.entries
  index = history.rindex("exit") || -1
  content = history[(index+1)..-2].join("\n")
  puts content
  copy content
end

def paste
  `pbpaste`
end

load File.dirname(__FILE__) + '/.railsrc' if $0 == 'irb' && ENV['RAILS_ENV']
