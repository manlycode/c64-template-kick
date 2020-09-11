#!/usr/bin/env bash
debuggerBin="/Applications/C64Debugger.app/Contents/MacOS/C64Debugger -pass"
$debuggerBin -unpause
$debuggerBin -wait 500 -snapshot clean-c64.snap
$debuggerBin -wait 700 -clearsettings -autojmp -snapshot clean-c64.snap -prg $1