#!/usr/bin/env ruby
require 'erb'

ARGV << "--help" if ARGV.empty?

aliases = {
  "g"  => "generate",
  "t"  => "test",
  "n"  => "new"
}

command = ARGV.shift
command = aliases[command] || command

HELP_MESSAGE = <<-EOF
Usage: eth-fly COMMAND [ARGS]
The most common eth-fly commands are:
 generate    Generate new code (short-cut alias: "g")
 test        Run tests (short-cut alias: "t")
 new         Create a new Rails application. "eth-fly new my_app" creates a
             new application called MyApp in "./my_app"
All commands can be run with -h (or --help) for more information.
EOF

COMMAND_WHITELIST = %w(generate new help test)

CONTRACT_TEMPLATE = ERB.new <<-EOF
contract <%= name.capitalize %> {
}
EOF

TEST_TEMPLATE = ERB.new <<-EOF
require 'minitest/autorun'
require 'ethereum'
require 'json'

class <%=name.capitalize%>Test < Minitest::Test
  include Ethereum

  def setup
    @state = Tester::State.new
    @solidity_code = File.read('./contracts/<%= name.capitalize %>.sol')
    @c = @state.abi_contract @solidity_code, language: :solidity
  end
end
EOF

def run_command!(command)
  command = parse_command(command)

  if COMMAND_WHITELIST.include?(command)
    send(command)
  else
    help
  end
end

def generate
  name = ARGV.shift
  if name
    contract = CONTRACT_TEMPLATE.result(binding)
    File.open("./contracts/#{name.capitalize}.sol", "w+") {|f| f.write(contract) }
    test = TEST_TEMPLATE.result(binding)
    File.open("./tests/#{name.capitalize}_test.rb", "w+") {|f| f.write(test) }
  else
    puts "Need contract name!"
  end
end

def test
end

def help
  write_help_message
end

def write_help_message
  puts HELP_MESSAGE
end

def parse_command(command)
  case command
  when "--help", "-h"
    "help"
  else
    command
  end
end

run_command!(command)
