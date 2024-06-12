const std = @import("std");
const dprint = std.debug.print;

const Player = struct {
    Name: u8,
    Money: f16,
    CurrentBet: u8,
    TotalScore: u8,
    Stand: bool,
    Wins: u8,
    Losses: u8,
};

const Dealer = struct {
    TotalScore: u8,
};

const Cards = enum { One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King };

pub fn main() !void {
    dprint("Game starting...\n", .{});

    var deck = [_]Cards{
        Cards.One,   Cards.One,   Cards.One,   Cards.One,
        Cards.Two,   Cards.Two,   Cards.Two,   Cards.Two,
        Cards.Three, Cards.Three, Cards.Three, Cards.Three,
        Cards.Four,  Cards.Four,  Cards.Four,  Cards.Four,
        Cards.Five,  Cards.Five,  Cards.Five,  Cards.Five,
        Cards.Six,   Cards.Six,   Cards.Six,   Cards.Six,
        Cards.Seven, Cards.Seven, Cards.Seven, Cards.Seven,
        Cards.Eight, Cards.Eight, Cards.Eight, Cards.Eight,
        Cards.Nine,  Cards.Nine,  Cards.Nine,  Cards.Nine,
        Cards.Ten,   Cards.Ten,   Cards.Ten,   Cards.Ten,
        Cards.Jack,  Cards.Jack,  Cards.Jack,  Cards.Jack,
        Cards.Queen, Cards.Queen, Cards.Queen, Cards.Queen,
        Cards.King,  Cards.King,  Cards.King,  Cards.King,
    };

    var dealer = Dealer{
        .TotalScore = 0,
    };

    // Create player
    var player1: Player = Player{
        .Name = 1,
        .Money = 100.0,
        .CurrentBet = undefined,
        .TotalScore = 0,
        .Stand = false,
        .Wins = 0,
        .Losses = 0,
    };

    var player2: Player = Player{
        .Name = 2,
        .Money = 100.0,
        .CurrentBet = undefined,
        .TotalScore = 0,
        .Stand = false,
        .Wins = 0,
        .Losses = 0,
    };

    var player3: Player = Player{
        .Name = 3,
        .Money = 150.0,
        .CurrentBet = undefined,
        .TotalScore = 0,
        .Stand = false,
        .Wins = 0,
        .Losses = 0,
    };

    const players = [3]*Player{
        &player1,
        &player2,
        &player3,
    };

    // Get bets
    for (players) |player| {
        try getBets(player);
    }

    // Shuffle  deck
    var prng = std.rand.DefaultPrng.init(blk: {
        var seed: u64 = undefined;
        try std.posix.getrandom(std.mem.asBytes(&seed));
        break :blk seed;
    });
    //shuffle(deck, prng);
    const random = prng.random();
    std.rand.shuffle(random, Cards, &deck);

    // Deal 1 card to each player
    for (players) |player| {
        player.TotalScore += getCardScore(dealCard(&deck, prng.random()));
    }
    dprint("Player1:{d}\nPlayer2:{d}\nPlayer3:{d}\n", .{ player1.TotalScore, player2.TotalScore, player3.TotalScore });

    // Deal 2 cards to dealer -> reveal first one dealt
    dealer.TotalScore += getCardScore(dealCard(&deck, prng.random()));
    dprint("Dealer Card #1: {d}\n\n", .{dealer.TotalScore});
    dealer.TotalScore += getCardScore(dealCard(&deck, prng.random()));

    // Players choose to hit or stay
    while (allPlayersStand(&players) == false) {
        for (players) |player| {
            try hitOrStand(player, &deck, prng.random());
        }
    }

    // Reveal dealer second card
    dprint("Dealer Card Score: {d}\n\n", .{dealer.TotalScore});
    // Calculate who won, bets etc...
    for (players) |player| {
        calcBets(player, &dealer);
        dprint("Player{d}'s winnings: {d:.2}\n\n", .{ player.Name, player.Money });
    }
}

fn allPlayersStand(players: *const [3]*Player) bool {
    for (players) |player| {
        if (player.Stand == false) {
            return false;
        }
    }
    return true;
}

fn get_input() ![]u8 {
    const stdin = std.io.getStdIn().reader();
    var buf: [10]u8 = undefined;

    if (try stdin.readUntilDelimiterOrEof(&buf, '\n')) |input| {
        return input;
    } else {
        return error.InvalidParam;
    }
}

pub fn getCardScore(card: Cards) u8 {
    switch (card) {
        Cards.One => {
            return 1;
        },
        Cards.Two => {
            return 2;
        },
        Cards.Three => {
            return 3;
        },
        Cards.Four => {
            return 4;
        },
        Cards.Five => {
            return 5;
        },
        Cards.Six => {
            return 6;
        },
        Cards.Seven => {
            return 7;
        },
        Cards.Eight => {
            return 8;
        },
        Cards.Nine => {
            return 9;
        },
        else => {
            return 10;
        },
    }
}

pub fn getBets(player: *Player) !void {
    // Get input from users to enter their bets
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Enter your bet: ", .{});
    // Need better error handling
    const bet: []u8 = try get_input();
    //player.CurrentBet = try std.fmt.parseUnsigned(u8, bet, 10);
    player.CurrentBet = 10 * (bet[0] - '0') + (bet[1] - '0');
    dprint("{d}\n", .{player.CurrentBet});
}

pub fn shuffle(deck: *const [52]Cards, prng: std.rand.Xoshiro256) [52]Cards {
    // Shuffle the main deck of cards
    const temp = [52]Cards{};
    for (deck) |card| {
        const rand = prng.random();
        const rand_num = std.rand.intRangeAtMost(rand, u8, 0, 51);
        _ = rand_num;
        temp[0] = card;
    }
}

pub fn dealCard(deck: *const [52]Cards, rand: std.Random) Cards {
    const rand_num = std.rand.intRangeAtMost(rand, u8, 0, 51);
    return deck[rand_num];
}

pub fn hitOrStand(player: *Player, deck: *const [52]Cards, rand: std.Random) !void {
    // Get user input to hit or stand
    if (player.Stand == false) {
        const stdout = std.io.getStdOut().writer();
        try stdout.print("Player{d}, Hit or stand? ", .{player.Name});
        // Need better error handling
        const user_choice: []u8 = try get_input();
        if (std.mem.eql(u8, user_choice, "hit")) {
            player.TotalScore += getCardScore(dealCard(deck, rand));
            dprint("Player{d}'s score: {d}\n\n", .{ player.Name, player.TotalScore });
        } else {
            player.Stand = true;
        }
    }
}

pub fn calcBets(player: *Player, dealer: *Dealer) void {
    // Calculate bets after done with round.
    // If blackjack for player and beat dealer bet * 1.5
    // If lost, lose bet
    if (player.TotalScore == 21 and player.TotalScore > dealer.TotalScore) {
        player.Money *= 1.5;
    } else if (player.TotalScore < dealer.TotalScore or player.TotalScore > 21) {
        player.Money -= @floatFromInt(player.CurrentBet);
    }
}
