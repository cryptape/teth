loadScript('temp/migrations/Token.js');

var balance = Token.getBalance.call(web3.eth.accounts[0], { from: web3.eth.accounts[0] })

console.log("balance is: ", balance);

Token.issue.sendTransaction(web3.eth.accounts[0], 10000, { from: web3.eth.accounts[0] }, function(err, tx){
  if(err){
    console.log("issue error!");
  } else {
    console.log("issue success. tx: ", tx);
  }
})

miner.start();admin.sleepBlocks(2);miner.stop();

balance = Token.getBalance.call(web3.eth.accounts[0], { from: web3.eth.accounts[0] })

console.log("balance is: ", balance);
