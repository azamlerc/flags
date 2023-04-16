//
//  main.swift
//  flags
//
//  Created by Andrew Zamler-Carhart on 4/15/23.
//

import Foundation

var files = initFiles()
var countries = initCountries()
var grandTotal = 0

// GPT: write a program that given an array of the names of files in a folder, and an array of characters, calculates how many times each character occurs in the contents of each file.
func count(countries: [Country], in files: [HTMLFile]) {
    for file in files {
        print(file.name)
        for country in countries {
            let count = file.contents.filter({ $0 == country.char }).count
            file.countryCounts[country.flag] = count
            country.count += count
            file.count += count
            grandTotal += count
        }
    }
}

count(countries: countries, in: files)

countries = countries
    .sorted { $0.count > $1.count }
    .filter { $0.count >= 0 }
files = files
    .sorted { $0.count > $1.count }
    .filter { $0.count >= 3 }

func makeTable(countries: [Country], in files: [HTMLFile]) -> [[String]] {
    var header = ["", ""]
    var totals = ["", String(grandTotal)]
    header.append(contentsOf: countries.map({ tooltip(text: $0.flag, tip: $0.name) }))
    totals.append(contentsOf: countries.map({ String($0.count) }))
    var table = [header, totals]

    for file in files {
        var row = [link(href: file.name, text: file.title), String(file.count)]
        row.append(contentsOf: countries.map({
            let count = file.countryCounts[$0.flag]!
            return count > 0 ? String(count) : "–"
        }))
        table.append(row)
    }
    return table
}

save(table: makeTable(countries: countries, in: files))
