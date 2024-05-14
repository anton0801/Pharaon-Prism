import Foundation

struct LevelItem {
    var id: String
    var num: Int
    var moves: Int
    var starBlock: (Int, Int)
    var gameField: [[Int]]
}

let allLevels = [
    LevelItem(id: "level_1", num: 1, moves: 2, starBlock: (2, 1), gameField: [
        [0,0,0,0,0,0],
        [0,1,0,0,0,0],
        [0,1,0,0,0,0],
        [0,0,0,0,0,0]
    ]),
    LevelItem(id: "level_2", num: 2, moves: 5, starBlock: (3, 1), gameField: [
        [0,0,0,0,0,0],
        [0,0,1,0,0,0],
        [0,1,1,0,0,0],
        [0,1,0,0,0,0]
    ]),
    LevelItem(id: "level_3", num: 3, moves: 7, starBlock: (3, 1), gameField: [
        [0,0,0,0,0,0],
        [1,1,1,0,0,0],
        [1,0,1,0,0,0],
        [1,1,1,0,0,0]
    ]),
    LevelItem(id: "level_4", num: 4, moves: 15, starBlock: (4, 0), gameField: [
       [1,1,1,0,0,0],
       [1,0,1,0,0,0],
       [1,1,1,0,0,0],
       [1,1,1,0,0,0],
       [1,0,1,0,0,0]
   ]),
    LevelItem(id: "level_5", num: 5, moves: 11, starBlock: (3, 1), gameField: [
        [0,1,1,0,0,0],
        [1,1,1,1,0,0],
        [1,1,1,1,0,0],
        [0,1,1,0,0,0]
    ]),
    LevelItem(id: "level_6", num: 6, moves: 16, starBlock: (0, 0), gameField: [
        [1,1,1,0,0,0],
        [1,0,1,1,0,0],
        [1,1,1,1,0,0],
        [1,0,1,1,0,0],
        [1,1,1,1,0,0],
    ]),
    LevelItem(id: "level_7", num: 7, moves: 12, starBlock: (0, 0), gameField: [
        [1,1,1,0,0,0],
        [1,0,1,0,0,0],
        [1,1,1,0,0,0],
        [1,0,1,0,0,0],
        [1,1,1,0,0,0],
    ]),
    LevelItem(id: "level_8", num: 8, moves: 12, starBlock: (0, 0), gameField: [
       [1,1,1,0,0,0],
       [1,1,0,0,0,0],
       [1,0,1,0,0,0],
       [1,0,1,0,0,0],
       [1,1,1,0,0,0],
   ]),
    LevelItem(id: "level_9", num: 9, moves: 11, starBlock: (0, 0), gameField: [
        [1,1,1,0,0,0],
        [1,1,1,0,0,0],
        [1,0,1,0,0,0],
        [1,0,1,0,0,0]
    ]),
    LevelItem(id: "level_10", num: 10, moves: 11, starBlock: (0, 0), gameField: [
        [1,0,1,0,0,0],
        [1,1,1,0,0,0],
        [1,1,1,0,0,0],
        [1,0,1,0,0,0]
    ]),
    LevelItem(id: "level_11", num: 11, moves: 11, starBlock: (0, 0), gameField: [
        [1,1,1,0,0,0],
        [1,0,1,0,0,0],
        [1,0,1,0,0,0],
        [1,0,1,0,0,0]
    ])
]
