//
//  DataSource.swift
//  KUtalog Lite
//
//  Created by HASAN CAN on 19.01.2020.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import Foundation
import Kanna

protocol DataSourceDelegate {
    func courseListLoaded(courseList: [Course])
    func courseDetailLoaded()
}

extension DataSourceDelegate {
    func courseListLoaded(courseList: [Course]) { }
    func courseDetailLoaded() { }
}

class DataSource {
    var delegate: DataSourceDelegate?
    
    func assignPoint(courses: [Course]) -> [Course] {
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
    
    func courseHistoryDataCheck(_ data: Data, completionHandler: @escaping (Error?) -> Void) -> Bool {
        guard let html = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
            completionHandler(ClassError.urlError)
            return false
        }
        
        do {
            let doc = try Kanna.HTML(html: html as String, encoding: .utf8)
            if doc.xpath("/html/head/title")[0].text == "My Course History" {
                return true
            } else {
                return false
            }
        } catch {
            completionHandler(error)
            return false
        }
    }
    
    func dataParsing(_ data: Data, completionHandler: @escaping (Error?) -> Void) {
        guard let html = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
            completionHandler(ClassError.urlError)
            return
        }
        
        guard let doc = try? Kanna.HTML(html: html as String, encoding: .utf8) else {
            completionHandler(ClassError.urlError)
            return
        }
        
        var continueValue: Bool = true
        var index: Int = 0
        
        var course = Course()
        var courses = [Course]()
        var terms = [[Course]]()
        
        while continueValue {
            for node in (doc.xpath("//span[@id='CRSE_NAME$\(index)']")) {
                if let text = node.text {
                    if text != "" {
                        course.name = text
                    }
                }
            }
            
            for node in (doc.xpath("//span[@id='CRSE_TERM$\(index)']")) {
                if let text = node.text {
                    if text != "" {
                        course.term = text
                    }
                }
            }
            
            for node in (doc.xpath("//span[@id='CRSE_UNITS$\(index)']")) {
                if let text = node.text {
                    if text != "" {
                        course.units = (text as NSString).doubleValue
                    }
                }
            }
            
            for node in (doc.xpath("//span[@id='CRSE_GRADE$\(index)']")) {
                if let text = node.text {
                    if text != "" {
                        course.grade = text
                        course.indexInDersler = index
                        courses.append(course)
                    }
                }
            }
            
            if courses.endIndex != index + 1 {
                continueValue = false
            }
            
            index += 1
        }
        courses = self.assignPoint(courses: courses)
        self.delegate?.courseListLoaded(courseList: courses)
    }
    
    func login(name: String, password: String, completionHandler: @escaping (Error?) -> Void) {
        guard let loginRequest = URLRequests.PrepareLoginRequest(name: name, password: password, completionHandler: { error in
            if let error = error {
                completionHandler(error)
                return
            }
        }) else {
            completionHandler(ClassError.missingData)
            return
        }
        
        let loginTask = URLSession.shared.dataTask(with: loginRequest, completionHandler: { (data, _, _) -> Void in
            DispatchQueue.main.async(execute: {
                guard let courseHistoryRequest = URLRequests.PrepareCourseHistoryRequest(completionHandler: { error in
                    if let error = error {
                        completionHandler(error)
                        return
                    }
                }) else {
                    completionHandler(ClassError.missingData)
                    return
                }
                
                let courseHistoryTask = URLSession.shared.dataTask(with: courseHistoryRequest, completionHandler: { (data, _, _) -> Void in
                    guard let data = data else {
                        completionHandler(ClassError.missingData)
                        return
                    }
                    
                    DispatchQueue.main.async(execute: {
                        let isDataCorrect = self.courseHistoryDataCheck(data, completionHandler: { error in
                            if let error = error {
                                completionHandler(error)
                                return
                            }
                        })
                        
                        if isDataCorrect {
                            self.dataParsing(data, completionHandler: { error in
                                
                            })
                        } else {
                            completionHandler(ClassError.missingData)
                            return
                        }
                        
                        Reachability.CheckList()
                        Reachability.TermSorter()
                        Reachability.CalculateGpa(Dersler)
                        self.AfterCalculation()
                        
                    })
                })
                courseHistoryTask.resume()
            })
        })
        loginTask.resume()
    }
}
