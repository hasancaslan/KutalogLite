//
//  URLRequests.swift
//  KUtalog Lite
//
//  Created by HASAN CAN on 19.01.2020.
//  Copyright © 2020 hasancanaslan. All rights reserved.
//

import Foundation

class URLRequests {
    class func PrepareLoginRequest(name: String, password: String, completionHandler: @escaping (Error?) -> Void) -> URLRequest? {
        guard let url = URL(string: "https://kusis.ku.edu.tr/psp/ps/?cmd=login&languageCd=ENG") else {
            completionHandler(ClassError.urlError)
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/x-www-form-urlencoded;charset=utf-8", forHTTPHeaderField: "Content-Type")
        let user_data = "userid=\(name)&pwd=\(password)"
        
        guard let userData = user_data.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
            completionHandler(ClassError.missingData)
            return nil
        }
        
        request.httpBody = userData.data(using: String.Encoding.utf8)
        completionHandler(nil)
        return request
    }
    
    class func PrepareCourseHistoryRequest(completionHandler: @escaping (Error?) -> Void) -> URLRequest? {
        let courseHistoryURLString="https://kusis.ku.edu.tr/psc/ps/EMPLOYEE/HRMS/c/SA_LEARNER_SERVICES.SSS_MY_CRSEHIST.GBL?PORTALPARAM_PTCNAV=HC_SSS_MY_CRSEHIST_GBL&EOPP.SCNode=HRMS&EOPP.SCPortal=EMPLOYEE&EOPP.SCName=CO_EMPLOYEE_SELF_SERVICE&EOPP.SCLabel=Self%20Service&EOPP.SCPTfname=CO_EMPLOYEE_SELF_SERVICE&FolderPath=PORTAL_ROOT_OBJECT.CO_EMPLOYEE_SELF_SERVICE.HCCC_ACADEMIC_RECORDS.HC_SSS_MY_CRSEHIST_GBL&IsFolder=false&PortalActualURL=https%3a%2f%2fkusis.ku.edu.tr%2fpsc%2fps%2fEMPLOYEE%2fHRMS%2fc%2fSA_LEARNER_SERVICES.SSS_MY_CRSEHIST.GBL&PortalContentURL=https%3a%2f%2fkusis.ku.edu.tr%2fpsc%2fps%2fEMPLOYEE%2fHRMS%2fc%2fSA_LEARNER_SERVICES.SSS_MY_CRSEHIST.GBL&PortalContentProvider=HRMS&PortalCRefLabel=My%20Course%20History&PortalRegistryName=EMPLOYEE&PortalServletURI=https%3a%2f%2fkusis.ku.edu.tr%2fpsp%2fps%2f&PortalURI=https%3a%2f%2fkusis.ku.edu.tr%2fpsc%2fps%2f&PortalHostNode=HRMS&NoCrumbs=yes&PortalKeyStruct=yes"

        guard let url = URL(string: courseHistoryURLString) else {
            completionHandler(ClassError.urlError)
            return nil
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return request
    }
}

