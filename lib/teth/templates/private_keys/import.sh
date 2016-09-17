#!/usr/bin/expect -f

set key [lindex $argv 0];
set geth [lindex $argv 1];

spawn $geth --datadir data account import $key
expect "Passphrase:"
send "123456\r"
expect "Repeat passphrase:"
send "123456\r"
interact
