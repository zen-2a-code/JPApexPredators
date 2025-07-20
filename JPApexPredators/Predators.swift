//
//  Predotors.swift
//  JPApexPredators
//
//  Created by Stoyan Hristov on 17.06.25.
//

import Foundation  // Brings in Apple’s core Swift APIs (Data, JSONDecoder, URL, …)

class Predators {  // Declares a reference type named ‘Predotors’
    var allApexPredators: [ApexPredator] = []
    var apexPredators: [ApexPredator] = []  // Stored property – a mutable array of ApexPredator objects statring with an empty array
    var allMovies: Set<String> = []
    init(){ // runs each time when the an instance of the class Predators is created
        decodeApexPredotorsData()
    }
    
    /// Loads “jpapexpredotors.json” from the app bundle into `apexPredators`
    func decodeApexPredotorsData() {  // Method (no parameters, no return value)
        if let jsonURL =  // Optional binding: executes body only if the URL exists
            Bundle.main.url(
                forResource:  // Ask the main app-bundle
                "jpapexpredators",
                withExtension: "json"
            )
        {
            do {  // Start a *do–catch* error-handling scope
                let data = try Data(contentsOf: jsonURL)  // Read file → Data; `try` because it throws
                let decoder = JSONDecoder()  // JSONDecoder can turn Data → Swift types
                
                decoder.keyDecodingStrategy = .convertFromSnakeCase  // Map snake_case keys → camelCase
                allApexPredators = try decoder.decode(  // Decode → Array<ApexPredator>
                    [ApexPredator].self,  // Type object for “[ApexPredator]” - meaning list(array) of ApexPredtors
                    from: data
                )
                apexPredators = allApexPredators
                
                allMovies = Set(apexPredators.flatMap{$0.movies})
                allMovies.insert("All Movies")
            } catch {  // Runs only if *any* `try` above threw an error
                print("Eror decoding the JSON data: \(error)")
            }
        }
    }
    
    func search(for searchText: String) -> [ApexPredator] {
        guard !searchText.isEmpty else {
            return apexPredators
        }
            apexPredators = apexPredators.filter {
                $0.name.localizedCaseInsensitiveContains(searchText)
            }
        
        return apexPredators
        }
    
    @discardableResult
    func sort(by alphabetical: Bool) -> Predators {
        apexPredators.sort { (predator1, predator2) -> Bool in
            if alphabetical {
                predator1.name < predator2.name
            } else {
                predator1.id < predator2.id
            }
        }
        return self
    }
    
    @discardableResult
    func filterByType(by type: APType) -> Predators {
        if type == .all {
            apexPredators = allApexPredators
        } else {
            apexPredators =  allApexPredators.filter { predator in
                predator.type == type
            }
        }
        return self
    }
    
    
    func filterByMovie(by movie: String) -> Predators{
        if movie != "All Movies" {
            apexPredators = apexPredators.filter {
                 $0.movies.contains(movie)
            }
        }
        return self
    }
}
