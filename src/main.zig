const builtin = @import("builtin");
const std = @import("std");
const aio = @import("aio");
const coro = @import("coro");
const log = std.log.scoped(.coro_aio);

var gpa: std.heap.GeneralPurposeAllocator(.{}) = .{};

pub const std_options: std.Options = .{
    .log_level = .debug,
};

fn app() !void {
    var srv_sock: std.posix.socket_t = undefined;
    try coro.io.single(.socket, .{
        .domain = std.posix.AF.INET,
        .flags = std.posix.SOCK.STREAM | std.posix.SOCK.CLOEXEC,
        .protocol = std.posix.IPPROTO.TCP,
        .out_socket = &srv_sock,
    });

    const address = std.net.Address.initIp4(.{ 0, 0, 0, 0 }, 2105);
    try std.posix.setsockopt(srv_sock, std.posix.SOL.SOCKET, std.posix.SO.REUSEADDR, &std.mem.toBytes(@as(c_int, 1)));
    if (@hasDecl(std.posix.SO, "REUSEPORT")) {
        try std.posix.setsockopt(srv_sock, std.posix.SOL.SOCKET, std.posix.SO.REUSEPORT, &std.mem.toBytes(@as(c_int, 1)));
    }
    try std.posix.bind(srv_sock, &address.any, address.getOsSockLen());
    try std.posix.listen(srv_sock, 0);

    var cli_sock: std.posix.socket_t = undefined;
    try coro.io.single(.accept, .{
        .socket = srv_sock,
        .out_socket = &cli_sock,
    });

    var read_buffer_cli: [64]u8 = undefined;
    var read_len_cli: usize = undefined;
    var read_error_cli: aio.Recv.Error = undefined;
    const stdin = std.io.getStdIn();
    var read_buffer_stdin: [64]u8 = undefined;
    var read_len_stdin: usize = undefined;
    var read_error_stdin: aio.Read.Error = undefined;
    while (true) {
        const max_operations = 64;
        var work = try aio.Dynamic.init(gpa.allocator(), max_operations);
        defer work.deinit(gpa.allocator());

        try work.queue(.{
            aio.op(.recv, .{ .socket = cli_sock, .buffer = &read_buffer_cli, .out_read = &read_len_cli, .out_error = &read_error_cli }, .unlinked),
            aio.op(.read, .{ .file = stdin, .buffer = &read_buffer_stdin, .out_read = &read_len_stdin, .out_error = &read_error_stdin }, .unlinked),
        }, {});

        const res = try work.complete(.blocking, {});

        std.log.debug("res ({})", .{res});
        std.log.debug("cli err({}) len({})", .{ read_error_cli, read_len_cli });
        std.log.debug("stdin err({}) len({})\n", .{ read_error_stdin, read_len_stdin });
    }
}

pub fn main() !void {
    if (builtin.target.os.tag == .wasi) return error.UnsupportedPlatform;
    // var mem: [4096 * 1024]u8 = undefined;
    // var fba = std.heap.FixedBufferAllocator.init(&mem);
    defer _ = gpa.deinit();
    var scheduler = try coro.Scheduler.init(gpa.allocator(), .{});
    defer scheduler.deinit();

    _ = try scheduler.spawn(app, .{}, .{});

    try scheduler.run(.wait);
}
