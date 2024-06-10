const std = @import("std");
const dprint = std.debug.print;

const Player = struct {
    Name: u8,
    Money: u8,
    CurrentBet: u8,
    TotalScore: u8,
    Wins: u8,
    Losses: u8,
};

const Cards = enum { One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King };

pub fn main() void {
    dprint("Game starting...\n", .{});

    const deck = [_]Cards{
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

    var player1: Player = Player{
        .Name = 1,
        .Money = 100,
        .CurrentBet = undefined,
        .TotalScore = 0,
        .Wins = 0,
        .Losses = 0,
    };

    var player2: Player = Player{
        .Name = 2,
        .Money = 100,
        .CurrentBet = undefined,
        .TotalScore = 0,
        .Wins = 0,
        .Losses = 0,
    };

    var player3: Player = Player{
        .Name = 3,
        .Money = 150,
        .CurrentBet = undefined,
        .TotalScore = 0,
        .Wins = 0,
        .Losses = 0,
    };

    const players = [3]*Player{
        &player1,
        &player2,
        &player3,
    };
    // Create player
    // Get bets
    // Shuffle  deck
    // Deal 1 card to each player
    var i: u8 = deck.len - 1;
    for (players) |player| {
        player.TotalScore += getCardScore(dealCard(&deck, i));
        i -= 10;
    }
    dprint("Player1:{d}\nPlayer2:{d}\nPlayer3:{d}\n", .{ player1.TotalScore, player2.TotalScore, player3.TotalScore });
    // Deal 2 cards to dealer -> reveal first one dealt
    // Players choose to hit or stay
    // Keep asking until every player standsor busted
    // Reveal dealer second card
    // Calculate who won, bets etc...
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

pub fn getBets() void {
    // Get input from users to enter their bets
}

pub fn shuffle() void {
    // Shuffle the main deck of cards
}

pub fn dealCard(deck: *const [52]Cards, idx: u8) Cards {
    return deck[idx];
}

pub fn hit() bool {}

pub fn calcBets() u8 {}
