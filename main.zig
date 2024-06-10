const std = @import("std");
const dprint = std.debug.print;

const Player = struct {};

const Cards = enum { One, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King };

pub fn main() void {
    dprint("Game starting...\n", .{});
    // Create player
    // Get bets
    // Shuffle  deck
    // Deal 1 card to each player
    // Deal 2 cards to dealer -> reveal first one dealt
    // Players choose to hit or stay
    // Keep asking until every player standsor busted
    // Reveal dealer second card
    // Calculate who won, bets etc...
}

pub fn getCardScore(card: Cards) u8 {
    _ = card;
}

pub fn getBets() void {}

pub fn shuffle() void {}

pub fn dealCards() void {}

pub fn hit() bool {}

pub fn calcBets() u8 {}
