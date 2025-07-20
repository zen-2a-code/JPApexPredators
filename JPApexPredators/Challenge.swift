import Foundation

class SortAndFilterExercise {
    /**
     Filters the input array and returns only the strings whose first letter is not a vowel,
     then sorts the filtered array in descending order.
     
     - Parameter stringArray: An array of strings to be filtered and sorted
     - Returns: A new array containing only the strings that do not start with a vowel, sorted descending.
     */
    func sortAndFilter(_ stringArray: [String]) -> [String] {
        // Define the vowels we want to check for
        let vowels: Set<Character> = ["a", "e", "i", "o", "u"]
        
        // Use .filter to keep only the strings whose first letter is NOT a vowel
        var filteredArray = stringArray.filter { currentString in
            // Get the first character of the string and check if it's not a vowel
            let firstCharCurrentString = currentString[currentString.startIndex].lowercased()
            return !vowels.contains(firstCharCurrentString.first!)
        }
        
        // Sort: descending alphabetically ignoring case; if equal ignoring case, uppercase wins
        filteredArray.sort { lhs, rhs in
            let lhsLower = lhs.lowercased()
            let rhsLower = rhs.lowercased()
            
            // Primary compare: case-insensitive descending
            if lhsLower != rhsLower {
                return lhsLower > rhsLower
            }
            // Secondary compare: literal (ASCII) ascending so "A" < "a"
            return lhs.compare(rhs, options: .literal) == .orderedAscending
        }
        
        
        // Return the filtered result
        return filteredArray
    }
}
