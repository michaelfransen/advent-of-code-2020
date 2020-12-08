#!/usr/bin/env swift
import Foundation

let fileManager = FileManager.default

var stringArray: [String]

do {
    let contents = try String(contentsOfFile: "./input.txt")
    stringArray = contents.components(separatedBy: "\n")
}

struct Bag {
    let color: String
    let subColors: [String]
}

var bags = [Bag]()
let regex = try! NSRegularExpression(pattern: "(.+) bags contain (.+)[,.]{0,}", options: NSRegularExpression.Options.caseInsensitive)
let childBagRegEx = try! NSRegularExpression(pattern: "(\\d+) (.+) (\\w+)", options: NSRegularExpression.Options.caseInsensitive)

stringArray.forEach { processRow(for: $0) }

func processRow(for string: String) {
    var color: String?
    var childrenString: String?
    var children = [String]()

    let matches = regex.matches(in: string, options: [], range: NSRange(location: 0, length: string.utf16.count))
    guard let match = matches.first else { return }
    
    if let swiftRange = Range(match.range(at: 1), in: string) {
        color = String(string[swiftRange])
    }

    if let swiftRange = Range(match.range(at: 2), in: string) {
        childrenString = String(string[swiftRange])
    }

    if childrenString != "no other bags" {
        childrenString = String(childrenString!.dropLast())
        let childrenStrings = childrenString!.components(separatedBy: ", ")
        for childString in childrenStrings {
            let childMatches = childBagRegEx.matches(in: childString, options: [], range: NSRange(location: 0, length: childString.utf16.count))
            guard let match = childMatches.first else { continue }
            var color: String? 
            var number: Int?

            if let swiftRange = Range(match.range(at: 1), in: childString) {
                number = Int(String(childString[swiftRange]))
            }

            if let swiftRange = Range(match.range(at: 2), in: childString) {
                color = String(childString[swiftRange])
            }

            if let color = color, let number = number {
                (0..<number).forEach { _ in children.append(color) }
            }
        }
    }

    let bag = Bag(color: color!, subColors: children)
    bags.append(bag)
}

func bagCount(for bag: Bag) -> Int {
    if bag.subColors.count == 0 {
        return 0
    } else {
        var total = 0
        for bagColor in bag.subColors {
            let bag = bags.first { $0.color == bagColor }!
            total += bagCount(for: bag) + 1
        }
        return total
    }
}

func containsShinyGold(color: String) -> Bool {
    guard let bag = bags.first(where: { $0.color == color }) else { return false }
    if bag.color == "shiny gold" { 
        return true
    } else {
        var containsColor = false
        for subColor in bag.subColors {
            if containsShinyGold(color: subColor) {
                containsColor = true
                break
            }
        }
        return containsColor
    }
}


let goldBag = bags.first(where: { $0.color == "shiny gold" })!
let totalBags = bagCount(for: goldBag)
print(totalBags)

