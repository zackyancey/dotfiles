#!/usr/bin/env python
"""Basic command line calculator.

usage: xc <expression> [$<format>]

This script interprets the rest of the entered line as a python expression and returns the result.
Multiple lines of code can be entered separated by semicolons, they will all be executed and the
output of the last expression will be printed. the last expression will be evaluated and returned.
Output can be formatted by including :<format> at the end of the input, where <format> is a python
format code.

Note: this script sends its input through `eval` (in fact that's about all it does), so don't go
running it with data from an unknown source.
"""
import sys
import os

# Import modules that may be useful
import datetime
from math import *
from binascii import hexlify, unhexlify
from ctypes import *
from fractions import Fraction
import statistics

# Nicer ctypes names
u8 = c_ubyte
i8 = c_byte
u16 = c_uint16
i16 = c_int16
u32 = c_uint32
i32 = c_int32
u64 = c_uint64
i64 = c_int64

# exec-ing PYTHONSTARTUP may replace __doc__, so we need to save it
doc = __doc__

try:
    if os.environ.get("PYTHONSTARTUP"):
        with open(os.environ["PYTHONSTARTUP"]) as f:
            exec(f.read())
except:
    print("Error running PYTHONSTARTUP")

if len(sys.argv)==1 or sys.argv[1] in ["-h","--help"]:
    print (doc)
    sys.exit()

# Look for a format argument and pull it out of the args
fmt = None
if (sys.argv[-1][0]) == ':':
    fmt = sys.argv[-1][1:]
    del sys.argv[-1]

# Put back the spaces that the shell parsed out
arg = " ".join(sys.argv[1:])

# Execute
if ';' in arg:
    args = arg.split(";")
    for a in args[:-1]: exec(a)
    arg = args[-1]

# Evaluate the passed in code and format it for printing
result = format(eval(arg), fmt) if fmt else eval(arg)
sys.displayhook(result)
