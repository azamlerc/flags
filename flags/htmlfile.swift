//
//  htmlfile.swift
//  flags
//
//  Created by Andrew Zamler-Carhart on 4/15/23.
//

import Foundation

let folderPath = "/Users/andrew/Library/Mobile Documents/com~apple~CloudDocs/Documents/Website/"
let skippedFiles = ["dictionary.html", "subway.html", "allthethings.html", "flags.html", "travel.html", "hiroshima.html", "america-2022.html", "america-2023.html", "iron-curtain.html"]
let outputFile = "flags.html"

let htmlTop = "<!DOCTYPE html><html><head><title>🏳️ Flags</title><meta charset=\"UTF-8\"><link rel=\"stylesheet\" href=\"styles.css\"></head><body><div class=\"headline\">🏳️ Flags</div><div class=\"caption\"><div class=\"flags-container\">"
let htmlBottom = "</div></div></body></html>"

class HTMLFile {
    var name: String
    var path: String

    var contents = ""
    var title = ""
    var count = 0
    var countryCounts = [String: Int]()
    
    init(folder: String, name: String) {
        self.name = name
        self.path = folder + name
    }
}

func initFiles() -> [HTMLFile] {
    let files = getHTMLFileNames(in: folderPath).map { HTMLFile(folder: folderPath, name: $0) }
    for file in files {
        if let contents = try? String(contentsOfFile: file.path) {
            file.title = getTitle(html: contents)
            file.contents = filterAlphanumeric(contents)
        }
    }
    
    return files
}

// GPT: given the path to a folder, return the names of all the html files in the folder
func getHTMLFileNames(in folderPath: String) -> [String] {
    let fileManager = FileManager.default
    var fileNames: [String] = []
    
    do {
        let folderContents = try fileManager.contentsOfDirectory(atPath: folderPath)
        for fileName in folderContents {
            if !skippedFiles.contains(fileName) && fileName.hasSuffix(".html") {
                fileNames.append(fileName)
            }
        }
    } catch {
        print("Error: \(error.localizedDescription)")
    }
    
    return fileNames.sorted()
}

// GPT: get the title from an HTML document
func getTitle(html: String) -> String {
    if let range = html.range(of: "<title>(.+?)</title>",
        options: [.caseInsensitive, .regularExpression]) {
        return String(html[range].dropFirst(7).dropLast(8))
    } else {
        return ""
    }
}

// GPT: filter alphanumeric characters out of a string
func filterAlphanumeric(_ string: String) -> String {
    return String(string.filter { !($0.isLetter || $0.isNumber) })
}

func tooltip(text: String, tip: String) -> String {
    return "<div class=\"tooltip\">\(text)<span class=\"tooltiptext\">\(tip)</span></div>"
}

// GPT: take a two dimensional array of strings and output an HTML table
func htmlTable(_ data: [[String]]) -> String {
    var html = "<table class=\"flags\">\n"
    var tag = "th"
    
    for row in data {
        html += "<tr>\n"
        for cell in row {
            html += "<\(tag)>\(cell)</\(tag)>\n"
        }
        html += "</tr>\n"
        tag = "td"
    }
    
    html += "</table>"
    return html
}

// GPT: take a string and write it to a file
func write(string: String, to filePath: String) {
    do {
        try string.write(toFile: filePath, atomically: true, encoding: .utf8)
    } catch {
        print("Error writing string to file: \(error)")
    }
}

func save(data: [[String]]) {
    let contents = htmlTop + htmlTable(data) + htmlBottom
    write(string: contents, to: folderPath + outputFile)
}

