# comperr zig aio

Compile error only happens with the x86 backend.

## zig 0.14

```
install
└─ install comperr_zig_aio
   └─ zig build-exe comperr_zig_aio Debug native 1 errors
error: undefined symbol: zefi_stack_swap
    note: referenced by main.o:.debug_info
    note: referenced by main.o:coro.zefi.yield
    note: referenced by main.o:coro.zefi.switchTo
    note: referenced by main.o:coro.zefi.init__anon_30095__struct_32200.entry
    note: referenced 1 more times
error: the following command failed with 1 compilation errors:
/usr/lib64/zig/0.14.0/bin/zig build-exe -fno-llvm -ODebug --dep aio --dep coro -Mroot=/home/emneo/programs/proper_projects/comperr_zig_aio/src/main.zig -ODebug --dep minilib --dep build_options -Maio=/home/emneo/.cache/zig/p/aio-0.0.0-776t3qVVBQCS5e6tiQ2qs6ds8N3NaEvbxqLg6womBPI_/src/aio.zig -ODebug --dep minilib --dep aio --dep build_options=build_options0 -Mcoro=/home/emneo/.cache/zig/p/aio-0.0.0-776t3qVVBQCS5e6tiQ2qs6ds8N3NaEvbxqLg6womBPI_/src/coro.zig -ODebug -Mminilib=/home/emneo/.cache/zig/p/aio-0.0.0-776t3qVVBQCS5e6tiQ2qs6ds8N3NaEvbxqLg6womBPI_/src/minilib.zig -Mbuild_options=/home/emneo/programs/proper_projects/comperr_zig_aio/.zig-cache/c/b80002184fde0ca6b12bec996fff20c8/options.zig -Mbuild_options0=/home/emneo/programs/proper_projects/comperr_zig_aio/.zig-cache/c/3a315cc5ffd23a4e8186a94d73ba5b2f/options.zig --cache-dir /home/emneo/programs/proper_projects/comperr_zig_aio/.zig-cache --global-cache-dir /home/emneo/.cache/zig --name comperr_zig_aio --zig-lib-dir /usr/lib64/zig/0.14.0/lib/ --listen=-
Build Summary: 2/5 steps succeeded; 1 failed
install transitive failure
└─ install comperr_zig_aio transitive failure
   └─ zig build-exe comperr_zig_aio Debug native 1 errors
error: the following build command failed with exit code 1:
/home/emneo/programs/proper_projects/comperr_zig_aio/.zig-cache/o/54247db1f73507abe12308c27f59a615/build /usr/lib64/zig/0.14.0/bin/zig /usr/lib64/zig/0.14.0/lib /home/emneo/programs/proper_projects/comperr_zig_aio /home/emneo/programs/proper_projects/comperr_zig_aio/.zig-cache /home/emneo/.cache/zig --seed 0xdf3fa9f3 -Ze53fdb3345e4fc19
```

## zig 0.15

TBD

> Currently compiling it to test, it takes a bit...
