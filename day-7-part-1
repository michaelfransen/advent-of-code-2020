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
    let childColors: [String]
}

var bags = [Bag]()
let regex = try! NSRegularExpression(pattern: "(.+) bags contain (.+)[,.]{0,}", options: NSRegularExpression.Options.caseInsensitive)
let childBagRegEx = try! NSRegularExpression(pattern: "\\d+ (.+) (\\w+)", options: NSRegularExpression.Options.caseInsensitive)

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
            if let swiftRange = Range(match.range(at: 1), in: childString) {
                children.append(String(childString[swiftRange]))
            }
        }
    }

    bags.append(Bag(color: color!, childColors: children))
}

func canContainGoldBag(for selectedBag: Bag) -> Bool {
    if selectedBag.color == "shiny gold" {
        return true
    } else if selectedBag.childColors.count > 0 {
        var returnValue = false
        for color in selectedBag.childColors {
            guard let bag = bags.first(where: { $0.color == color } )else { continue }
            if canContainGoldBag(for: bag) {
                returnValue = true
            }
        }
        return returnValue
    } else { 
        return false
    }
}

var goldBagCarrierCount = 0

for bag in bags {
    // Exclude shiny gold bag
    guard bag.color != "shiny gold" else { continue }
    if canContainGoldBag(for: bag) {
        goldBagCarrierCount += 1
    }
}

print(goldBagCarrierCount)

