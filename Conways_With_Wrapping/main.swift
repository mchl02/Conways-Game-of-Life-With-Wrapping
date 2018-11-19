//
//  main.swift
//  Conways_With_Wrapping
//
//  Created by ws on 11/16/18.
//  Copyright © 2018 ws. All rights reserved.
//

import Foundation

class Coor: Hashable {
    let row: Int
    let column: Int
    
    init(_ x_coor: Int, _ y_coor: Int) {
        self.row = x_coor
        self.column = y_coor
    }
    
    var hashValue: Int {
        return(pair(row, column))
    }
    func pair(_ row: Int, _ column: Int) -> Int {
        return (((row + column) * (row + column + 1) / 2) + column)
    }
    static func == (lhs: Coor, rhs: Coor) -> Bool {
        return (lhs.row == rhs.row) && (lhs.column == rhs.column)
    }
}

class Colony: CustomStringConvertible {
    var s = Set<Coor>()
    var colonySize: Int
    var gen = 0
    
    init() {
        self.colonySize = 20
        self.s = Set<Coor>()
    }
    //This works 
    func setCellAlive(xCoor: Int, yCoor: Int) {
        s.insert(Coor(xCoor%colonySize, yCoor%colonySize))
    }
    
    func setCellDead(xCoor: Int, yCoor: Int) {
        s.remove(Coor(xCoor, yCoor))
    }
    
    func isCellAlive(xCoor: Int, yCoor: Int) -> Bool {
        return s.contains(Coor(xCoor%colonySize, yCoor%colonySize))
    }
    
    func neighboring(xCoor: Int, yCoor: Int) -> Set<Coor> {
        var neighbor = Set<Coor>()
        neighbor.insert(Coor((xCoor-1)%colonySize, (yCoor-1)%colonySize))
        neighbor.insert(Coor(xCoor%colonySize, (yCoor-1)%colonySize))
        neighbor.insert(Coor((xCoor+1)%colonySize, (yCoor-1)%colonySize))
        neighbor.insert(Coor((xCoor-1)%colonySize, yCoor%colonySize))
        neighbor.insert(Coor((xCoor+1)%colonySize, yCoor%colonySize))
        neighbor.insert(Coor((xCoor-1)%colonySize, (yCoor+1)%colonySize))
        neighbor.insert(Coor(xCoor%colonySize, (yCoor+1)%colonySize))
        neighbor.insert(Coor((xCoor+1)%colonySize, (yCoor+1)%colonySize))
        return neighbor
        
    /*
         FIRST TEST
         var neighbor = Set<Coor>()
         neighbor.insert(Coor((xCoor-1)%20, (yCoor-1)%20))
         neighbor.insert(Coor(xCoor%20, (yCoor-1)%20))
         neighbor.insert(Coor((xCoor+1)%20, (yCoor-1)%20))
         neighbor.insert(Coor((xCoor-1)%20, yCoor%20))
         neighbor.insert(Coor((xCoor+1)%20, yCoor%20))
         neighbor.insert(Coor((xCoor-1)%20, (yCoor+1)%20))
         neighbor.insert(Coor(xCoor%20, (yCoor+1)%20))
         neighbor.insert(Coor((xCoor+1)%20, (yCoor+1)%20))
         return neighbor
         
         SECOND TEST
         var neighbor = Set<Coor>()
         neighbor.insert(Coor(xCoor%colonySize-1, yCoor%colonySize-1))
         neighbor.insert(Coor(xCoor%colonySize, yCoor%colonySize-1))
         neighbor.insert(Coor(xCoor%colonySize+1, yCoor%colonySize-1))
         neighbor.insert(Coor(xCoor%colonySize-1, yCoor%colonySize))
         neighbor.insert(Coor(xCoor%colonySize+1, yCoor%colonySize))
         neighbor.insert(Coor(xCoor%colonySize-1, yCoor%colonySize+1))
         neighbor.insert(Coor(xCoor%colonySize, yCoor%colonySize+1))
         neighbor.insert(Coor(xCoor%colonySize+1, yCoor%colonySize+1))
         return neighbor
         
         THIRD TEST
         var neighbor = Set<Coor>()
         neighbor.insert(Coor((xCoor-1)%colonySize, (yCoor-1)%colonySize))
         neighbor.insert(Coor(xCoor%colonySize, (yCoor-1)%colonySize))
         neighbor.insert(Coor((xCoor+1)%colonySize, (yCoor-1)%colonySize))
         neighbor.insert(Coor((xCoor-1)%colonySize, yCoor%colonySize))
         neighbor.insert(Coor((xCoor+1)%colonySize, yCoor%colonySize))
         neighbor.insert(Coor((xCoor-1)%colonySize, (yCoor+1)%colonySize))
         neighbor.insert(Coor(xCoor%colonySize, (yCoor+1)%colonySize))
         neighbor.insert(Coor((xCoor+1)%colonySize, (yCoor+1)%colonySize))
         return neighbor
        */
    }
   
    func neighboringCount(_ x: Int, _ y: Int) -> Int {
        return neighboring(xCoor: x, yCoor: y).filter( {isCellAlive(xCoor: $0.row, yCoor: $0.column)} ).count
    }
    
    func decide(_ row: Int, _ col: Int) -> Bool {
        let count = neighboringCount(row%colonySize, col%colonySize)
        if count == 3 {
            return true
        } else if count == 2 && isCellAlive(xCoor: row%colonySize, yCoor: col%colonySize) {
            return true
        } else {
            return false
        }
    }
    
    func resetColony(){
        s = Set<Coor>()
        gen = 0
    }
    
    var description: String {
        var result = ""
        result += "Generation #\(gen)\n"
        for row in 0..<colonySize {
            for col in 0..<colonySize {
                result += isCellAlive(xCoor: row, yCoor: col) ? "*" : " "
            }
            result += "\n"
        }
        return result
    }
    
    
    func evolve() {
        var s1 = Set<Coor>()
        s1 = Set( s.map( { neighboring(xCoor: $0.row%colonySize, yCoor: $0.column%colonySize) })
            .flatMap({$0}) )
        
        s = Set( s1.filter( {decide($0.row%colonySize, $0.column%colonySize)} ) )
        gen += 1
        
    }
}

var c = Colony()

c.setCellAlive(xCoor: 5, yCoor: 5)
c.setCellAlive(xCoor: 5, yCoor: 6)
c.setCellAlive(xCoor: 5, yCoor: 7)
c.setCellAlive(xCoor: 6, yCoor: 6)
c.setCellAlive(xCoor: 17, yCoor: 17)
c.setCellAlive(xCoor: 17, yCoor: 18)
c.setCellAlive(xCoor: 17, yCoor: 19)
c.setCellAlive(xCoor: 18, yCoor: 18)







print(c)

for _ in 0..<10{
    c.evolve()
    print(c)
}

