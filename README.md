## Introduction
Teth is a Ethereum smart contract test framework in ruby.It provides two testing environments: testing in ruby EVM and testing in geth.You don't need to understand ruby grammar, just enjoy syntactic sugar.

## Dependencies
- Solidity ~> 0.3.6
- Ruby ~> 2.2.2
- Go-ethereum ~> 1.4.11

## Install
```shell
bundle install teth
```

## How to use

Help command:
```
$ teth
```
Create a new Smart Contract application
```shell
$ teth n examples
Creating project examples...
Resolving dependencies...
Using ffi 1.9.14
Using little-plugger 1.1.4
Using multi_json 1.12.1
Using digest-sha3 1.1.0
Using ethash 0.2.0
Using fiddler-rb 0.1.2
Using lru_redux 1.1.0
Using minitest 5.9.0
Using rlp 0.7.3
Using bundler 1.12.5
Using bitcoin-secp256k1 0.4.0
Using logging 2.1.0
Using leveldb 0.1.9
Using block_logger 0.1.2
Using ruby-ethereum 0.9.5
Using teth 0.1.1
Bundle complete! 1 Gemfile dependency, 16 gems now installed.
Use `bundle show [gemname]` to see where a bundled gem is installed.
Done.

$ cd examples
```
Generate new Smart Contract and test files
```shell
$ teth g token
Creating Token contract file...
Creating token test files...
Done.
```
Edit token contract and test file

`contracts/Token.sol`
```javascript
pragma solidity ^0.4.0;

contract Token {
    address issuer;
    mapping (address => uint) balances;

    event Issue(address account, uint amount);
    event Transfer(address from, address to, uint amount);

    function Token() {
        issuer = msg.sender;
    }

    function issue(address account, uint amount) {
        if (msg.sender != issuer) throw;
        balances[account] += amount;
        Issue(account, amount);
    }

    function transfer(address to, uint amount) {
        if (balances[msg.sender] < amount) throw;

        balances[msg.sender] -= amount;
        balances[to] += amount;

        Transfer(msg.sender, to, amount);
    }

    function getBalance(address account) constant returns (uint) {
        return balances[account];
    }
}

```

`tests/token_test.rb`
```ruby
require 'teth/minitest'

class TokenTest < Teth::Minitest
  def test_contract_deployed
    assert_equal false, contract.address.nil?
  end

  def test_issue_balance
    assert_equal 0, contract.getBalance(bob)
    contract.issue bob, 100
    assert_equal 100, contract.getBalance(bob)
  end

  def test_issue_exception
    assert_raises(TransactionFailed) do
      contract.issue bob, 100, sender: eve_privkey
    end
    assert_equal 0, contract.getBalance(bob)
  end

  def test_token_transfer
    contract.issue bob, 100
    contract.transfer carol, 90, sender: bob_privkey
    assert_equal 90, contract.getBalance(carol)

    assert_raises(TransactionFailed) { contract.transfer carol, 90, sender: bob_privkey }
  end
end

```

Run tests in ruby evm
```shell
$ teth t token
Test Token contract...
Run options: --seed 2192

# Running:

....

Finished in 1.935546s, 2.0666 runs/s, 3.6166 assertions/s.

4 runs, 7 assertions, 0 failures, 0 errors, 0 skips
Done.
```

## Unit tests
You can wirte fast, simple tests.
```ruby
require 'teth/minitest'

class TokenTest < Teth::Minitest
  def test_contract_deployed
    assert_equal false, contract.address.nil?
  end

  def test_issue_balance
    assert_equal 0, contract.getBalance(bob)
    contract.issue bob, 100
    assert_equal 100, contract.getBalance(bob)
  end

  def test_issue_exception
    assert_raises(TransactionFailed) do
      contract.issue bob, 100, sender: eve_privkey
    end
    assert_equal 0, contract.getBalance(bob)
  end

  def test_token_transfer
    contract.issue bob, 100
    contract.transfer carol, 90, sender: bob_privkey
    assert_equal 90, contract.getBalance(carol)

    assert_raises(TransactionFailed) { contract.transfer carol, 90, sender: bob_privkey }
  end
end

```
More details:
https://github.com/seattlerb/minitest

## Geth init
```shell
$ teth init
Initialising a new genesis block...
***** Using geth at: geth
I0917 16:01:17.338908 ethdb/database.go:82] Alloted 16MB cache and 16 file handles to /Users/u2/cryptape/teth/examples/data/chaindata
I0917 16:01:17.347151 cmd/geth/main.go:299] successfully wrote genesis block and/or chain rule set: 611596e7979cd4e7ca1531260fa706093a5492ecbdf58f20a39545397e424d04
```
## Geth import keys
```shell
$ teth ik
Importing keys, this will take a while, please be patient......
***** Using geth at: geth
***** Import all pre-funded private keys
Notice: No need to input your password. The default password is 123456
spawn geth --datadir data account import ./private_keys/3ae88fe370c39384fc16da2c9e768cf5d2495b48.key
Your new account is locked with a password. Please give a password. Do not forget this password.
Passphrase:
Repeat passphrase:
Address: {3ae88fe370c39384fc16da2c9e768cf5d2495b48}
Notice: No need to input your password. The default password is 123456
spawn geth --datadir data account import ./private_keys/81063419f13cab5ac090cd8329d8fff9feead4a0.key
Your new account is locked with a password. Please give a password. Do not forget this password.
Passphrase:
Repeat passphrase:
Address: {81063419f13cab5ac090cd8329d8fff9feead4a0}
Notice: No need to input your password. The default password is 123456
spawn geth --datadir data account import ./private_keys/9da26fc2e1d6ad9fdd46138906b0104ae68a65d8.key
Your new account is locked with a password. Please give a password. Do not forget this password.
Passphrase:
Repeat passphrase:
Address: {9da26fc2e1d6ad9fdd46138906b0104ae68a65d8}
***** Done.

```
Notice:*This will take a while, please be patient. No need input your password.*

## Build contract
```shell
$ teth build token
Building contract Token

======= Token =======
Gas estimation:
construction:
   20201 + 73400 = 93601
external:


-------------------------------------
Enter Gas:
400000
Enter Value To Be Transferred:

Enter Input:

Done.
```
Build all contracts if no contract provided.

## Start geth server
```shell
$ teth server
***** Using geth at: geth
Start geth server...
I0917 16:17:16.882572 ethdb/database.go:82] Alloted 128MB cache and 1024 file handles to data/chaindata
I0917 16:17:16.894415 ethdb/database.go:169] closed db:data/chaindata
I0917 16:17:16.895446 ethdb/database.go:82] Alloted 128MB cache and 1024 file handles to data/chaindata
I0917 16:17:16.946341 eth/backend.go:621] upgrading db log bloom bins
I0917 16:17:16.946478 eth/backend.go:629] upgrade completed in 142.276µs
I0917 16:17:16.946513 ethdb/database.go:82] Alloted 16MB cache and 16 file handles to data/dapp
I0917 16:17:16.951072 eth/backend.go:172] Protocol Versions: [63 62], Network Id: 31415926
I0917 16:17:16.951142 eth/backend.go:201] Blockchain DB Version: 3
I0917 16:17:16.953641 core/blockchain.go:206] Last header: #0 [611596e7…] TD=131072
I0917 16:17:16.953667 core/blockchain.go:207] Last block: #0 [611596e7…] TD=131072
I0917 16:17:16.953678 core/blockchain.go:208] Fast block: #0 [611596e7…] TD=131072
I0917 16:17:16.954420 p2p/server.go:313] Starting Server
I0917 16:17:16.955324 p2p/server.go:556] Listening on [::]:30303
I0917 16:17:16.957427 node/node.go:296] IPC endpoint opened: data/geth.ipc
I0917 16:17:16.959797 node/node.go:366] HTTP endpoint opened: http://localhost:8545
I0917 16:17:17.945231 cmd/geth/accountcmd.go:189] Unlocked account 3ae88fe370c39384fc16da2c9e768cf5d2495b48
I0917 16:17:19.158064 p2p/nat/nat.go:111] mapped network port tcp:30303 -> 30303 (ethereum p2p) using UPNP IGDv1-IP1
```
## Migrate
Deploy your contract on geth, must keep teth sever started.
```shell
$ ./bin/migrate.sh token
***** Using geth at: geth
null
Contract transaction send: TransactionHash: 0xafe3911afe2b01aa3028c59c490db3fc773ef6becaccd7f69352f747e4e725d4 waiting to be mined...
Compiled Object : TokenCompiled
Contract : TokenContract
Contract Instance : Token
true
Contract mined! Address: 0x0a6ffcc9aee581c76e3110c93f48f8d078dce645
Done.

```
Deploy all contracts if no contract provided.

## TODO
- Extract test file require and others
- Save migrate address
- Migrate ARGV
- Script for preload
- Easy way to load contract on chain
- Easy way to test on chain
- ES6
