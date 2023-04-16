//
//  main.swift
//  flags
//
//  Created by Andrew Zamler-Carhart on 4/15/23.
//

import Foundation

var files = initFiles()
var countries = initCountries(names: countryNames)
let flags = countryNames.keys
let characters = flags.map({ $0.first! })
var grandTotal = 0

let maxCountries = 0
let maxFiles = 0
let minCountryCount = 0
let minFileCount = 3

if maxCountries > 0 { countries = Array(countries.prefix(maxCountries)) }
if maxFiles > 0 { files = Array(files.prefix(maxFiles)) }

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
    .filter { $0.count >= minCountryCount }
files = files
    .sorted { $0.count > $1.count }
    .filter { $0.count >= minFileCount }

var header = ["", ""]
var totals = ["", String(grandTotal)]
header.append(contentsOf: countries.map({ tooltip(text: $0.flag, tip: $0.name) }))
totals.append(contentsOf: countries.map({ String($0.count) }))
var table = [header, totals]

// Print the data rows
for file in files {
    let link = "<a href=\"\(file.name)\">\(file.title)</a>"
    var row = [link, String(file.count)]
    row.append(contentsOf: countries.map({
        let count = file.countryCounts[$0.flag]!
        return count > 0 ? String(count) : "–"
    }))
    table.append(row)
}

save(data: table)
