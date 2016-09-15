require 'minitest/autorun'
require 'ethereum'

module Teth
  class Minitest < ::Minitest::Test
    include Ethereum

    class <<self
      def contract_dir_name(set_val=nil)
        if set_val
          @contract_dir_name = set_val
        else
          @contract_dir_name ||= 'contracts'
        end
      end

      def account_num(set_val=nil)
        if set_val
          @account_num = set_val
        else
          @account_num ||= 10
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
        code = File.read path
        @contract = state.abi_contract code, language: :solidity, sender: privkey
      when /\.se\z/
        raise NotImplemented, "Serpent not supported yet"
      else
        raise "Unknown contract source type: #{path}"
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
