//
//  BookManagerJson.swift
//  MyBooks
//
//  Created by Rubens Parente on 04/09/24.
//

import Foundation

class BookManagerJson {
    private let fileName = "books.json"
    
    // Retrieve books from JSON file
    func fetchBooks() -> [Book] {
        let fileManager = FileManager.default
        guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return []
        }
        let fileURL = documentsURL.appendingPathComponent(fileName)
        
        do {
            let jsonData = try Data(contentsOf: fileURL)
            let decoder = JSONDecoder()
            decoder.dateDecodingStrategy = .iso8601
            return try decoder.decode([Book].self, from: jsonData)
        } catch {
            print("Error loading books: \(error)")
            return []
        }
    }
    
    // Save books to JSON file
    func saveBooks(_ books: [Book]) {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        
        do {
            let jsonData = try encoder.encode(books)
            let fileManager = FileManager.default
            guard let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
            let fileURL = documentsURL.appendingPathComponent(fileName)
            try jsonData.write(to: fileURL)
        } catch {
            print("Error saving books: \(error)")
        }
    }
    
    // Create or Update a book
    func createOrUpdateBook(_ book: Book) {
        var books = fetchBooks()
        
        if let index = books.firstIndex(where: { $0.id == book.id }) {
            books[index] = book
        } else {
            books.append(book)
        }
        
        saveBooks(books)
    }
    
    // Delete a book
    func deleteBook(_ book: Book) {
        var books = fetchBooks()
        books.removeAll { $0.id == book.id }
        saveBooks(books)
    }
}
