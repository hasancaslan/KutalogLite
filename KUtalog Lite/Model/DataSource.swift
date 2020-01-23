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
    func termListLoaded(termList: [[Course]])
}

class DataSource {
    var delegate: DataSourceDelegate?
    let utility = Utilities()
    typealias loginFuncHandler = (_ completionHandler: @escaping (Error?) -> Void) -> Void

    fileprivate func courseHistoryDataCheck(_ data: Data, completionHandler: @escaping (Error?) -> Void) -> Bool {
        guard let html = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
            completionHandler(ClassError.urlError)
            return false
        }

        do {
            let doc = try Kanna.HTML(html: html as String, encoding: .utf8)
            if doc.xpath("/html/head/title")[0].text == "My Course History" {
                completionHandler(nil)
                return true
            } else {
                completionHandler(nil)
                return false
            }
        } catch {
            completionHandler(error)
            return false
        }
    }

    fileprivate func dataParsing(_ data: Data) -> [Course]? {
        guard let html = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
            return nil
        }

        guard let doc = try? Kanna.HTML(html: html as String, encoding: .utf8) else {
            return nil
        }

        var continueValue: Bool = true
        var index: Int = 0

        var course = Course()
        var courses = [Course]()

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
                        course.indexInCourses = index
                        courses.append(course)
                    }
                }
            }

            if courses.endIndex != index + 1 {
                continueValue = false
            }

            index += 1
        }
        return courses
    }

    fileprivate func fetchCourseHistory(completionHandler: @escaping (Error?) -> Void) {
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
                    guard var courses = self.dataParsing(data) else {
                        completionHandler(ClassError.missingData)
                        return
                    }
                    courses = self.utility.orderCourses(courses)
                    let terms = self.utility.orderTerms(courses)
                    self.delegate?.termListLoaded(termList: terms)
                } else {
                    completionHandler(ClassError.missingData)
                    return
                }
            })
        })
        completionHandler(nil)
        courseHistoryTask.resume()
    }

    fileprivate func login(name: String, password: String, task: @escaping loginFuncHandler, completionHandler: @escaping (Error?) -> Void) {
        if !Reachability.shared.isConnectedToNetwork() {
            completionHandler(ClassError.networkUnavailable)
            return
        }

        guard let loginRequest = URLRequests.PrepareLoginRequest(name: name, password: password, completionHandler: { error in
            if let error = error {
                completionHandler(error)
                return
            }
        }) else {
            completionHandler(ClassError.missingData)
            return
        }

        let loginTask = URLSession.shared.dataTask(with: loginRequest, completionHandler: { (_, _, _) -> Void in
            DispatchQueue.main.async(execute: {
                task({ error in
                    if let error = error {
                        completionHandler(error)
                        return
                    }
                })
            })
        })
        completionHandler(nil)
        loginTask.resume()
    }

    func loadCourseHistory(name: String, password: String, completionHandler: @escaping (Error?) -> Void) {
        login(name: name, password: password, task: fetchCourseHistory(completionHandler:), completionHandler: completionHandler)
    }
}
