require 'minitest/autorun'
require 'ethereum'

module Teth
  class Minitest < ::Minitest::Test
    include Ethereum

    class <<self
      def contract_dir_name(set_val=nil)
        if set_val.nil?
          @contract_dir_name ||= 'contracts'
        else
          @contract_dir_name = set_val
        end
      end

      def account_num(set_val=nil)
        if set_val.nil?
          @account_num ||= 10
        else
          @account_num = set_val
        end
      end

      def print_events(set_val=nil)
        if set_val.nil?
          return true if @print_events.nil?
          @print_events
        else
          @print_events = set_val
        end
      end

      def print_logs(set_val=nil)
        if set_val.nil?
          return true if @print_logs.nil?
          @print_logs
        else
          @print_logs = set_val
        end
      end
    end

    def setup
      path = find_contract_source
      raise "Cannot find corresponding contract source" unless path
      setup_contract(path)
    end

    def teardown
      @state = nil
      @account = nil
      @contract = nil
    end

    def setup_contract(path)
      case path
      when /\.sol\z/
        type = :solidity
      when /\.se\z/
        raise NotImplemented, "Serpent not supported yet"
      else
        raise "Unknown contract source type: #{path}"
      end

      code = File.read path
      log_listener = ->(log) do
        if log.instance_of?(Log) # unrecognized event
          if self.class.print_logs
            topics = log.topics.map {|t| heuristic_prettify Utils.int_to_big_endian(t) }
            data = heuristic_prettify(log.data)
            puts "[Log] #{Utils.encode_hex(log.address)} >>> topics=#{topics} data=#{data}"
          end
        else # user defined event
          if self.class.print_logs && self.class.print_events
            from = log.delete '_from'
            name = log.delete '_event_type'
            s = log.keys.map {|k| "#{k}=#{log[k]}" }.join(' ')
            puts "[Event] #{from} #{name} >>> #{s}"
          end
        end
      end
      @contract = state.abi_contract code,
        language: type, sender: privkey, log_listener: log_listener
    end

    def heuristic_prettify(bytes)
      dry_bytes = bytes.gsub(/\A(\x00)+/, '')
      dry_bytes = dry_bytes.gsub(/(\x00)+\z/, '')
      if (bytes.size - dry_bytes.size) > 3
        # there's many ZERO bytes in the head or tail of bytes, it must be padded
        if dry_bytes.size == 20 # address
          Utils.encode_hex(dry_bytes)
        else
          dry_bytes
        end
      else
        Utils.encode_hex(bytes)
      end
    end

    def contract
      @contract
    end

    def find_contract_source
      name = self.class.name[0...-4]
      dir = find_contracts_directory
      find_source(dir, name, 'sol') || find_source(dir, name, 'se')
    end

    def find_contracts_directory
      last = nil
      cur = ENV['PWD']
      while cur != last
        path = File.join cur, self.class.contract_dir_name
        return path if File.directory?(path)
        last = cur
        cur = File.dirname cur
      end
      nil
    end

    def find_source(dir, name, ext)
      name = "#{name}.#{ext}"
      list = Dir.glob File.join(dir, "**/*.#{ext}")
      list.find {|fn| File.basename(fn) =~ /\A#{name}\z/i }
    end

    ##
    # Fixtures
    #

    @@privkeys = account_num.times.map do |i|
      Utils.keccak256 rand(Constant::TT256).to_s
    end

    def privkey
      account[0]
    end

    def pubkey
      account[1]
    end

    def address
      account[2]
    end

    def account
      return @account if @account

      i = rand(self.class.account_num)
      @account = [privkeys[i], pubkeys[i], addresses[i]]
    end

    def privkeys
      @privkeys ||= @@privkeys
    end

    def pubkeys
      @pubkeys ||= privkeys.map {|k| PrivateKey.new(k).to_pubkey }
    end

    def addresses
      @addresses ||= privkeys.map {|k| PrivateKey.new(k).to_address }
    end

    def state
      @state ||= Tester::State.new privkeys: privkeys
    end

    def head
      state.head
    end

  end
end
