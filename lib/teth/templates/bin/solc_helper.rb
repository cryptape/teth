#!/usr/bin/env ruby

require 'json'
def library_code
  'function create(abiDefinition) {  return web3.eth.contract(abiDefinition);}/*function deploy(account, value, gas, contract, code, input) */function deploy() {  var account = arguments[0];  var value = arguments[1];  var gas = arguments[2];  var contract = arguments[3];  var code = arguments[4];  var codeString = "contract.new(inputMarker,{from:\'accountMarker\', value: valueMarker,  data: \'codeMarker\', gas: gasMarker}, function (e, contract) {    if(!e) {      if(!contract.address) {        console.log(\"Contract transaction send: TransactionHash: \" + contract.transactionHash + \" waiting to be mined...\");      } else {        console.log(\"Contract mined! Address: \" + contract.address);      }    } else {      console.log(e)    }  })";  codeString = codeString.replace("accountMarker", account);  codeString = codeString.replace("valueMarker", value);  codeString = codeString.replace("codeMarker", code);  codeString = codeString.replace("gasMarker", gas);  input = "null";  if (arguments.length > 5) {    if (arguments[5] != null) {      var args = [];      for (var i = 5;i < arguments.length; i++) {        var val = arguments[i];        if (typeof(val) === \'string\') {          val = "\"" + val + "\"";        }        args.push(val);      }      input = args.join(",");    }  }  codeString = codeString.replace("inputMarker", input);  console.log(input);  var instance = eval(codeString);  return instance;}function watcher(error, result) {  if (!error) {    console.log("Result");    console.log(JSON.stringify(result));    return;  }  console.log("Error" + error);}/*function call(account, gas, func, input) */function call() {  var account = "eth.accounts["+arguments[0]+"]";  var gas = arguments[1];  var func = arguments[2];  input = "null";  if (arguments.length > 3) {    if (arguments[3] != null) {      var args = Array.prototype.slice.call(arguments, 3);      input = args.join(",");    }  }  codeString = "func.sendTransaction(inputMarker, gasMarker, {from:accountMarker}, watcher);";  codeString = codeString.replace("accountMarker",account);  codeString = codeString.replace("gasMarker",gas);  codeString = codeString.replace("inputMarker",input);  eval(codeString);}function send(from_index, to, value, gas){ return eth.sendTransaction({from:eth.accounts[from_index], to:to, value:web3.toWei(value,\'ether\'), gas:gas});}function bal() {  for (var i = 0; i < eth.accounts.length; i++) {    account = eth.accounts[i];    balance = web3.fromWei(eth.getBalance(eth.accounts[i]), \'ether\');    console.log("Index : " + i);    console.log("Account : "+ account);    console.log("Balance : "+ balance);    console.log("\n");  }}'
end

def compile_solidity(file)
  json_string = `solc --add-std --optimize --combined-json abi,bin,userdoc,devdoc #{file}`
  json_string = json_string.gsub("\\n","")
  begin
    json_object = JSON.parse(json_string)
    throw if json_object.nil?
    puts `solc --optimize --gas #{file}`
    puts "\n\n"
    puts "-------------------------------------"
    json_object["contracts"]
  rescue
    puts "Failed to Compile."
    abort
  end
end

def process_code(contracts)
  contracts.keys.each.with_index do |key, i|
    contracts[key]["bin"] = "0x" + contracts[key]["bin"]
    contracts[key]["abi"] = JSON.parse(contracts[key]["abi"])
    contracts[key]["devdoc"] = JSON.parse(contracts[key]["devdoc"])
    contracts[key]["userdoc"] = JSON.parse(contracts[key]["userdoc"])
  end
  return contracts
end


def javascript_file_name(file_name)
  file_name = file_name.split('/')[-1]
  file_name.split('.')[0] + '_compiled.js'
end

def get_contract_to_deploy(compiled_object)
  return compiled_object.keys[0] if compiled_object.keys.count == 1
  puts "Which contract do you want to deploy?"
  choice = 0
  while choice <= 0 || choice > compiled_object.keys.count
    compiled_object.keys.each.with_index do |key, i|
      puts "#{(i+1)}. "+key
    end
    choice = $stdin.gets.to_i
  end
  return compiled_object.keys[choice - 1]
end

def get_input
  puts "Enter Input: "
  input = $stdin.gets
  input.strip.chomp == "" ? "null" : input
end

def get_gas
  gas = 0
  while gas == 0
    puts "Enter Gas: "
    gas = $stdin.gets.to_i
  end
  gas
end

def get_value
  gas = -1
  while gas < 0
    puts "Enter Value To Be Transferred: "
    gas = $stdin.gets.to_i
  end
  gas
end

file_name = ARGV[0]

compiled_object = compile_solidity(file_name)
compiled_object = process_code(compiled_object)
javascript_file_name = javascript_file_name(file_name)

current_contract = get_contract_to_deploy(compiled_object)

compiled_variable_name = "#{current_contract}Compiled"
contract_variable_name = "#{current_contract}Contract"
contract_instance_variable_name = "#{current_contract}"

gas = get_gas
value = get_value
input = get_input

File.open(javascript_file_name, 'w') do |f|
  f.write("#{library_code};\nvar #{compiled_variable_name} = #{compiled_object.to_json};")
  f.write("#{contract_variable_name} = create(#{compiled_variable_name}.#{current_contract}.abi);")
  f.write("#{contract_instance_variable_name} = deploy(eth.coinbase,#{value},#{gas},#{contract_variable_name},#{compiled_variable_name}.#{current_contract}.bin,#{input});")
  f.write("console.log('Compiled Object : #{compiled_variable_name}');")
  f.write("console.log('Contract : #{contract_variable_name}');")
  f.write("console.log('Contract Instance : #{contract_instance_variable_name}');")
end
