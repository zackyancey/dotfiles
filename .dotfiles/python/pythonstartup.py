"""Python startup file

sets up some conveniences for using the python repl.

set PYTHONSTARTUP to point to this file, and it will execute before
python starts in interactive mode.

What this does:
    * Change the display hook to show integers in dec/hex/bin bases
    * Import some commonly used modules.
"""
import builtins
import ctypes
import sys
from ctypes import c_int, c_size_t, sizeof

__DISPLAY_HEX = True
__IMPORTS = True

if __DISPLAY_HEX:
    def __displayhook(o):
        if o is None:
            return
        builtins._ = None
        c_unsigned = (
            ctypes.c_ubyte,
            ctypes.c_ushort,
            ctypes.c_uint,
            ctypes.c_ulong,
            ctypes.c_ulonglong,
            ctypes.c_size_t,
        )
        c_signed = {
            ctypes.c_byte: ctypes.c_ubyte,
            ctypes.c_short: ctypes.c_ushort,
            ctypes.c_int: ctypes.c_uint,
            ctypes.c_long: ctypes.c_ulong,
            ctypes.c_longlong: ctypes.c_ulonglong,
            ctypes.c_ssize_t: ctypes.c_size_t,
        }
        c_int_types = c_unsigned + tuple(c_signed.keys())
        int_fmt = "{i}  |  0x{i:0X}  |  0b{i:0b}"
        if isinstance(o, c_int_types):
            signed = type(o) not in c_unsigned
            sizeof = ctypes.sizeof(o)
            value = o.value
            if signed:
                bitwise_value = c_signed[type(o)](o.value).value
            else:
                bitwise_value = value

            cint_fmt = "[{sign}{size}]  {i}  |  0x{bi:0%dX}  |  0b{bi:0%db}" % (sizeof*2, sizeof*8)
            print(cint_fmt.format(
                sign= "i" if signed else "u",
                size=sizeof*8,
                i=value,
                bi=bitwise_value,
            ))
        elif isinstance(o, int) and not isinstance(o, bool):
            print(int_fmt.format(i=o))
        else:
            print(o)

        builtins._ = o

    sys.displayhook = __displayhook

if __IMPORTS:
    from binascii import hexlify, unhexlify
