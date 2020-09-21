import UIKit

struct TopLevelDictionary: Decodable {
    let count: Int
    let entries: [Entry]
}

struct Entry: Decodable {
    let API: String
    let Description: String
    let Auth: String
    let HTTPS: Bool
    let Cors: String
    let Link: String
    let Category: String
}

class EntryController {
    
    static let baseURL = URL(string: "https://api.publicapis.org/")
    static let categoriesEndpoint = "categories"
    static let entriesEndpoint = "entries"
    
    static func fetchAllCategories(completion: @escaping([String]) -> Void) {
        
        guard let baseURL = baseURL else {return completion([])}
        //https://api.publicapis.org
        
        let finalURL = baseURL.appendingPathComponent(categoriesEndpoint)
        //https://api.publicapis.org/Categories
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion([])
            }
            
            guard let data = data else {return completion([])}
            
            do {
                let categories = try JSONDecoder().decode([String].self, from: data)
                return completion(categories)
            } catch {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion([])
            }
        }.resume()
    }
    
    static func fetchAllEntriesWith(category: String, completion: @escaping([Entry]) -> Void) {
        
        guard let baseURL = baseURL else {return completion([])}
        //https://api.publicapis.org
        
        let entriesURL = baseURL.appendingPathComponent(entriesEndpoint)
        //https://api.publicapis.org/entries
        
        var components = URLComponents(url: entriesURL, resolvingAgainstBaseURL: true)
        let categoryQuery = URLQueryItem(name: "category", value: category)
        components?.queryItems = [categoryQuery]
        
        guard let finalURL = components?.url else {return completion([])}
        //https://api.publicapis.org/entries?category="Animals"

        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
                return completion([])
            }
            
            guard let data = data else {return completion([])}
            
            do {
                let topLevelDictionary = try JSONDecoder().decode(TopLevelDictionary.self, from: data)
                let entries = topLevelDictionary.entries
                return completion(entries)
            } catch {
                print(error)
                print(error.localizedDescription)
                return completion([])
            }
        }.resume()
    }
}//END OF CLASS

EntryController.fetchAllCategories { (categories) in
    EntryController.fetchAllEntriesWith(category: categories.randomElement() ?? categories[0] 
    for category in categories {
        print(category)
    }
}



