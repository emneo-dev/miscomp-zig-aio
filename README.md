# comperr zig aio

I just use this repo to show issues in zig-aio, the name does not correspond.

## Bug

Using dynamic work queues will never yield cancelled tasks.

To reproduce:
- Launch with `zig build test`
- Connect to the server with anything on port 2105 `nc 127.0.0.1 2105`
- Send some data on the socket or stdin of the server process
- See that both the socket and stdin read tasks are success, no cancelled

This also happens with every other tasks I have tested for now (especially
`accept` which has been a pretty big problem when implementing
[knoopunt](https://github.com/emneo-dev/knoopunt)).


> See here the output you should get, with `stdin_len` being undefined
```
$ zig build run
debug: res (aio.CompletionResult{ .num_completed = 1, .num_errors = 0 })
debug: cli err(error.Success) len(1)
debug: stdin err(error.Success) len(12297829382473034410)
```
