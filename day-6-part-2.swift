// Day 6
#!/usr/bin/env swift
import Foundation

let fileManager = FileManager.default

var stringArray: [String]

do {
    let contents = try String(contentsOfFile: "./input.txt")
    stringArray = contents.components(separatedBy: "\n")
}

var totalCount = 0
var groupSets = [Set<Character>]()

for string in stringArray {
    if string.isEmpty {
        processRow()
        continue
    }

    var currentSet = Set<Character>()
    for character in Array(string) {
        currentSet.insert(character)
    }

    groupSets.append(currentSet)
    print(groupSets)
}

processRow()

print(totalCount)

func processRow() {
    var combinedSet = groupSets[0]

    if groupSets.count > 1 {
        for i in 1..<groupSets.count {
            combinedSet = combinedSet.intersection(groupSets[i])
        }
    }

    totalCount += combinedSet.count
    groupSets = [Set<Character>]()
}
