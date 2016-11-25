#!/bin/sh

cli=/Applications/Karabiner.app/Contents/Library/bin/karabiner

$cli set remap.commandL2fn 1
/bin/echo -n .
$cli set remap.fn_fkeys_to_consumer_f10 1
/bin/echo -n .
$cli set repeat.initial_wait 150
/bin/echo -n .
$cli set repeat.wait 20
/bin/echo -n .
/bin/echo
