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

     fileprivate func termSorter(_ courses: [Course]) -> [[Course]] {
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

    func calculateGpa(_ courses: [Course]) -> Double {
        let totalUnits = calculateCredits(courses)
        var unitByPoint = 0.0

        for course in courses {
            if course.valid == 1 {
                unitByPoint = unitByPoint + (course.units * course.point)
            }
        }

        return unitByPoint / totalUnits
    }

     func calculateCredits(_ courses: [Course]) -> Double {
        var totalUnits = 0.0

        for course in courses {
            if course.valid == 1 {
                totalUnits = totalUnits + course.units
            }
        }

        return totalUnits
    }
}
