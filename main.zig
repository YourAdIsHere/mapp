const std = @import("std");
pub fn main() !void {
    var closed: usize = 0;
    var open: usize = 0;
    for (1..1000) |port| {
        const stream = std.net.tcpConnectToAddress(std.net.Address.initIp4([4]u8{ 127, 0, 0, 1 }, @intCast(port))) catch |err| {
            switch (err) {
                error.ConnectionRefused => closed += 1,
                error.PermissionDenied => std.debug.print("Permission Denied for port {any}\n", .{port}),
                else => std.debug.print("Error: {any}", .{err}),
            }
            continue;
        };
        var buf: [100]u8 = undefined;
        open += 1;
        std.debug.print("Port {any} OPEN\n", .{port});
        std.debug.print("{0s: <7}{1s: <10}{2s: <20}\n", .{ "PORT", "STATE", "SERVICE" });
        std.debug.print("{0any: <5}{1s: <5}{2?s: <20}\n", .{ port, "open", try stream.reader().readUntilDelimiterOrEof(&buf, '\n') });
    }
    std.debug.print("Not shown: {any} closed tcp ports\n", .{closed});
}
