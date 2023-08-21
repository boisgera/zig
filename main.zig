const std = @import("std");
const ArrayList = std.ArrayList;
const math = std.math;
const info = std.log.info;

const print = std.debug.print;
const allocator = std.heap.page_allocator;

pub fn typeOfStuff() void {
    print("@TypeOf(std): {}\n", .{@TypeOf(std)});
    print("@TypeOf(std.debug): {}\n", .{@TypeOf(std.debug)});
    print("@TypeOf(std.debug.print): {}\n", .{@TypeOf(std.debug.print)});
    print("@TypeOf(print): {}\n", .{@TypeOf(print)});
}

pub fn testTypes() void {
    const c: u8 = 'A';
    const d: u8 = 127;
    const i: i32 = 1000;
    const f__: f64 = 3.14;
    const pi: f64 = math.pi;

    print("{}\n", .{c});
    print("{}\n", .{d});
    print("{}\n", .{i});
    print("{}\n", .{f__});
    print("{}\n", .{pi});
}

pub fn testPrimitiveValues() void {
    const t = true;
    print("{}: {}\n", .{ t, @TypeOf(t) });
    const n = null;
    print("{}: {}\n", .{ n, @TypeOf(n) });
    const z: ?f64 = null;
    print("{?}: {}\n", .{ z, @TypeOf(z) });
    print("{any}: {}\n", .{ z, @TypeOf(z) });
    const x: f64 = undefined;
    print("{}: {}\n", .{ x, @TypeOf(x) });
}

pub fn testArray() void {
    const array = [4]u8{ 65, 66, 67, 68 };
    const message = "TRULULU"; // string literal map to constant pointers to zero-terminated string
    print("{any}: {}\n", .{ array, @TypeOf(array) });
    print("{s}: {}\n", .{ array, @TypeOf(array) });
    print("{any}: {}\n", .{ message, @TypeOf(message) });
    print("{s}: {}\n", .{ message, @TypeOf(message) });
    const p = &array;
    print("{*}: {}\n", .{ p, @TypeOf(p) });
    print("{s}: {}\n", .{ p, @TypeOf(p) });
}

pub fn testLoop() void {
    var array = [_]u8{ 0, 1, 2, 3 };
    for (&array) |*item| {
        print("{}\n", .{item});
        item.* = item.* * 2;
    }
    print("{any}\n", .{array});
}

pub fn f_(t: f64, x: f64) f64 {
    _ = t;
    return x;
}

const Solution = struct {
    ts: []f64,
    xs: []f64,

    pub fn x(s: Solution, ts: []const f64) !ArrayList(f64) {
        var result = ArrayList(f64).init(allocator);

        for (ts) |t| {
            var j_low: usize = 0;
            var j_high: usize = s.ts.len - 1;
            var t_low = s.ts[j_low];
            var t_high = s.ts[j_high];
            for (0..s.ts.len) |j| {
                if (s.ts[j] <= t and t_low < s.ts[j]) {
                    j_low = j;
                    t_low = s.ts[j];
                }
                if (t <= s.ts[j] and s.ts[j] < t_high) {
                    j_high = j;
                    t_high = s.ts[j];
                }
            }
            info("ind: {}, {}", .{ j_low, j_high });
            const alpha = if (t_low != t_high) (t - t_low) / (t_high - t_low) else 0.0;
            const x_ = s.xs[j_low] + alpha * (s.xs[j_high] - s.xs[j_low]);
            try result.append(x_);
        }
        return result;
    }
};

pub fn solve(f: *const fn (f64, f64) f64) Solution {
    const dt = 0.01;
    const x_0 = 1.0;
    const t_0 = 0.0;
    const t_1 = 1.0;
    var ts: [1000]f64 = undefined;
    var xs: [1000]f64 = undefined;

    var i: usize = 0;
    var t: f64 = t_0;
    var x: f64 = x_0;
    ts[i] = t;
    xs[i] = x;

    while (t < t_1) {
        i += 1;
        t += dt;
        x += dt * f(t, x);
        ts[i] = t;
        xs[i] = x;
    }
    return Solution{ .ts = ts[0 .. i + 1], .xs = xs[0 .. i + 1] };
}

pub fn main() !void {
    // print("Hello, stderr!\n", .{});

    // const stdout = std.io.getStdOut();
    // try stdout.writer().print("Hello, {s}!\n", .{"stdout"});
    // try stdout.writer().print("----------------\n", .{});

    // typeOfStuff();

    // testTypes();

    // testPrimitiveValues();

    // testArray();

    const sol = solve(f_);
    print("{any}\n", .{sol});

    info("{s}", .{"------------------------"});

    const times = [_]f64{ 0.0, 0.5, 1.0 };

    var xs: ArrayList(f64) = undefined;
    xs = try sol.x(&times);

    info("{any}", .{xs.items});
}
