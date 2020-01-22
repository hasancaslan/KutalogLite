//
//  Reachability.swift
//  KUtalog Lite
//
//  Created by HASAN CAN on 19.01.2020.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import Foundation
import SystemConfiguration

class Utilities {
    func orderCourses(_ rawCourses: [Course]) -> [Course] {
        var orderedCourses = rawCourses
        orderedCourses = assignPoint(orderedCourses)
        orderedCourses = checkList(orderedCourses)
        return orderedCourses
    }
    
    func orderTerms(_ rawCourses: [Course]) -> [[Course]] {
        var terms = coursesToTerms(rawCourses)
        terms = sortTerms(terms)
        return terms
    }
    
    fileprivate func assignPoint(_ courses: [Course]) -> [Course] {
        var gradedCourses = courses
        for index in 0..<courses.count {
            let grade = courses[index].grade
            switch  grade {
            case "A+": gradedCourses[index].point = 4.3
            gradedCourses[index].wunit = courses[index].units
            case "A": gradedCourses[index].point = 4.0
            gradedCourses[index].wunit = courses[index].units
            case "A-": gradedCourses[index].point = 3.7
            gradedCourses[index].wunit = courses[index].units
            case "B+": gradedCourses[index].point = 3.3
            gradedCourses[index].wunit = courses[index].units
            case "B": gradedCourses[index].point = 3.0
            gradedCourses[index].wunit = courses[index].units
            case "B-": gradedCourses[index].point = 2.7
            gradedCourses[index].wunit = courses[index].units
            case "C+": gradedCourses[index].point = 2.3
            gradedCourses[index].wunit = courses[index].units
            case "C": gradedCourses[index].point = 2.0
            gradedCourses[index].wunit = courses[index].units
            case "C-": gradedCourses[index].point = 1.7
            gradedCourses[index].wunit = courses[index].units
            case "D+": gradedCourses[index].point = 1.3
            gradedCourses[index].wunit = courses[index].units
            case "D": gradedCourses[index].point = 1.0
            gradedCourses[index].wunit = courses[index].units
            case "F": gradedCourses[index].point = 0.0
            gradedCourses[index].wunit = courses[index].units
            case "AU": gradedCourses[index].units = 0.0
            case "W": gradedCourses[index].wunit = courses[index].units
            gradedCourses[index].units = 0.0
            default : gradedCourses[index].valid = 0
            gradedCourses[index].wunit = courses[index].units
            }
        }
        return gradedCourses
    }
    
    fileprivate func checkList(_ courses: [Course]) -> [Course] {
        var checkedCourses = courses
        for i in 0 ..< checkedCourses.count {
            for j in 0 ..< checkedCourses.count {
                let namecl = checkedCourses[i].name as NSString
                let namel = checkedCourses[j].name as NSString
                
                if namecl.substring(to: 4) == namel.substring(to: 4) {
                    switch namecl.substring(to: 4) {
                    case "ASIU", "SOSC", "ETHR", "HUMS":
                        if checkedCourses[i].point > checkedCourses[j].point {
                            checkedCourses[j].units = 0.0
                        }
                        
                        if checkedCourses[i].point < checkedCourses[j].point {
                            checkedCourses[i].units = 0.0
                        }
                        
                    default:
                        if checkedCourses[i].name == checkedCourses[j].name {
                            if checkedCourses[i].point > checkedCourses[j].point {
                                checkedCourses[j].units = 0.0
                            }
                            
                            if checkedCourses[i].point < checkedCourses[j].point {
                                checkedCourses[i].units = 0.0
                            }
                        }
                    }
                }
                
                let elc = checkedCourses[j].name as NSString
                if elc.substring(to: 3) == "ELC" {
                    checkedCourses[j].units = 0.0
                }
            }
        }
        return checkedCourses
    }
    
    fileprivate func coursesToTerms(_ courses: [Course]) -> [[Course]] {
        var newTerm = [Course]()
        var tempCourses = courses
        var terms = [[Course]]()
        
        for course in courses {
            for i in 0 ..< tempCourses.count {
                let tempCourse = tempCourses[i]
                let term1 = course.term
                let term2 = tempCourse.term
                
                if term1 == term2 {
                    var newCourse = Course()
                    newCourse = tempCourse
                    tempCourses[i].term = ""
                    newTerm.append(newCourse)
                }
            }
            
            if newTerm.count >= 1 {
                terms.append(newTerm)
                newTerm.removeAll(keepingCapacity: false)
            }
        }
        return terms
    }
    
    func sortTerms(_ termm: [[Course]]) -> [[Course]] {
        var sortedTerms = termm
        for i  in 0..<sortedTerms.count - 1 {
            
            for j in 1..<sortedTerms.count - i {
                let namej = sortedTerms[j][0].term as NSString
                let yearj = Double(namej.substring(from: namej.length - 4))! + self.termNameToDouble(namej.substring(to: namej.length - 5))
                
                let namej1 = sortedTerms[j - 1][0].term as NSString
                let yearj1 = Double(namej1.substring(from: namej1.length - 4))! + self.termNameToDouble(namej1.substring(to: namej1.length - 5))
                if yearj1 < yearj {
                    let temp = sortedTerms[j - 1]
                    sortedTerms[j - 1] = sortedTerms[j]
                    sortedTerms[j] = temp
                }
            }
        }
        return sortedTerms
    }
    
    fileprivate func termNameToDouble(_ name: String) -> Double {
        var toDouble = 0.0
        if name == "Spring" {
            toDouble = 0.1
        } else if name == "Summer" {
            toDouble = 0.2
        } else if name == "Fall" {
            toDouble = 0.3
        }
        return toDouble
    }
    
    func calculateSPA(_ courses: [Course]) -> Double {
        let totalUnits = calculateSemesterCredits(courses)
        var unitByPoint = 0.0
        
        if totalUnits == 0.0 {
            return -1
        }
        
        for course in courses {
            if course.valid == 1 {
                unitByPoint = unitByPoint + (course.units * course.point)
            }
        }
        return unitByPoint / totalUnits
    }
    
    func calculateGPA(_ terms: [[Course]]) -> Double {
        let totalCredits = calculateTotalCredits(terms)
        var totalPoints = 0.0
        if totalCredits == 0.0 {
            return -1
        }
        
        for term in terms {
            let spa = calculateSPA(term)
            if spa >= 0 {
                let credit = calculateSemesterCredits(term)
                totalPoints += spa * credit
            }
        }
        return totalPoints / totalCredits
    }
    
    func calculateSemesterCredits(_ courses: [Course]) -> Double {
        var totalUnits = 0.0
        for course in courses {
            if course.valid == 1 {
                totalUnits = totalUnits + course.units
            }
        }
        return totalUnits
    }
    
    func calculateTotalCredits(_ terms: [[Course]]) -> Double {
        var totalUnits = 0.0
        for term in terms {
            totalUnits += calculateSemesterCredits(term)
        }
        return totalUnits
    }
    
    func toJson(from terms: [[Course]]) -> String {
        var Json = "{"
        
        for i in 0 ..< terms.count {
            Json = Json + "\"" + String(i) + "\":" + "{"
            
            for  j in 0 ..< terms[i].count {
                Json = Json + "\"" + String(j + 10) + "\": {"
                Json = Json + "\"name\":\"" + terms[i][j].name + "\","
                Json = Json + "\"term\":\"" + terms[i][j].term + "\","
                Json = Json + "\"units\":\"" + String(terms[i][j].units) + "\","
                Json = Json + "\"grade\":\"" + terms[i][j].grade + "\","
                Json = Json + "\"point\":\"" + String(terms[i][j].point) + "\","
                Json = Json + "\"wunit\":\"" + String(terms[i][j].wunit) + "\","
                Json = Json + "\"valid\":\"" + String(terms[i][j].valid) + "\","
                Json = Json + "\"indexInCourses\":\"" + String(terms[i][j].indexInCourses) + "\"},"
            }
            
            Json.remove(at: Json.index(before: Json.endIndex))
            Json = Json + "},"
        }
        
        Json.remove(at: Json.index(before: Json.endIndex))
        Json = Json + "}"
        return Json
    }
    
    func readJson(from storage: NSString) -> [[Course]]? {
        var terms = [[Course]]()
        guard let data = storage.data(using: String.Encoding.utf8.rawValue) else {
            return nil
        }
        
        do {
            let dict: [String: Any] = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
            
            for courseDict in  dict.values {
                var tempTerm = [Course]()
                
                for case let course as [String: Any] in (courseDict as! [String: Any]).values {
                    var newCourse = Course()
                    newCourse.name = course["name"] as! String
                    newCourse.grade = course["grade"] as! String
                    newCourse.term =  course["term"] as! String
                    newCourse.point =  Double(course["point"] as! String)!
                    newCourse.units = Double(course["units"] as! String)!
                    newCourse.valid = Int( course["valid"] as! String)!
                    newCourse.wunit = Double(course["wunit"] as! String)!
                    newCourse.indexInCourses = Int( course["indexInCourses"] as! String)!
                    tempTerm.append(newCourse)
                }
                terms.append(tempTerm)
            }
        } catch {
            return nil
        }
        return terms
    }
}
