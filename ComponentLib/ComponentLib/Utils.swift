//
//  Util.swift
//  MobileERP
//
//  Created by Sunil Luitel on 9/3/15.
//  Copyright (c) 2015 Sunil Luitel. All rights reserved.
//

import Foundation

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func < <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l < r
  case (nil, _?):
    return true
  default:
    return false
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func > <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l > r
  default:
    return rhs < lhs
  }
}

// FIXME: comparison operators with optionals were removed from the Swift Standard Libary.
// Consider refactoring the code to use the non-optional operators.
fileprivate func >= <T : Comparable>(lhs: T?, rhs: T?) -> Bool {
  switch (lhs, rhs) {
  case let (l?, r?):
    return l >= r
  default:
    return !(lhs < rhs)
  }
}


class Utils {
    
    class func makeDefaultWhere(_ defaultArr:[[String]])-> String {
        let size = defaultArr.count;
        var result = "";
        if size > 0 {
            for i in 0 ..< size {
                let tmp:[String] = defaultArr[i];
                if (i == 0) {
                    result = tmp[0] + " = '" + tmp[1] + "'";
                } else {
                    result += " AND " + tmp[0] + " = '" + tmp[1] + "'";
                }
            }
        }
        return result
    }
    
    class func trimString(_ originalString:String)->String {
        return  originalString.trimmingCharacters(in: CharacterSet.whitespaces);
    }
    
    class func getYYYYMMDDValue(_ text:String)->String {
        var rawValue: String?
        if (text.count == 16 || text.count == 14 ) {
            let inputDateFormat = DateFormatter()
            inputDateFormat.dateFormat = "yyyy-MM-dd (E)"
            inputDateFormat.locale = Locale.current
            inputDateFormat.timeZone = TimeZone(abbreviation: "GMT")
            
            let outputDateFormat = DateFormatter()
            outputDateFormat.dateFormat = "yyyyMMdd"
            outputDateFormat.locale = Locale.current
            rawValue = outputDateFormat.string(from: inputDateFormat.date(from: text)!)
        }
        
        if rawValue != nil {
            return rawValue!
        }else{
            return text
        }
        
    }
    
    class func getYYYYMMDDText(_ value:String)->String {
        // if value is in yyyyMMdd format (value comes from dataSet) then change
        // to yyyy-MM-dd (E) for displaying
        // else show as it is
        var rawValue: String?
        if value.count == 8 {
            let inputDateFormat = DateFormatter()
            inputDateFormat.dateFormat = "yyyyMMdd"
            inputDateFormat.locale = Locale.current
            inputDateFormat.timeZone = TimeZone(abbreviation: "GMT")
            
            // checked nil value because sometimes data has value like 20160230
            if inputDateFormat.date(from: value) != nil {
                let outputDateFormat = DateFormatter()
                outputDateFormat.dateFormat = "yyyy-MM-dd (E)"
                outputDateFormat.locale = Locale.current
                
                rawValue = outputDateFormat.string(from: inputDateFormat.date(from: value)!)
            }
        }
        //        return rawValue
        
        if rawValue != nil {
            return rawValue!
        }else{
            return value
        }
    }
    
    
    class func getYYYYMMValue(_ text:String)->String {
        var rawValue: String?
        if text.count == 7 {
            let inputDateFormat = DateFormatter()
            inputDateFormat.dateFormat = "yyyy-MM"
            inputDateFormat.locale = Locale.current
            inputDateFormat.timeZone = TimeZone(abbreviation: "GMT")
            
            let outputDateFormat = DateFormatter()
            outputDateFormat.dateFormat = "yyyyMM"
            outputDateFormat.locale = Locale.current
            rawValue = outputDateFormat.string(from: inputDateFormat.date(from: text)!)
        }
        if rawValue != nil {
            return rawValue!
        }else{
            return text
        }
        
    }
    
    class func getYYYYMMText(_ value:String)->String {
        // if value is in yyyyMM format (value comes from dataSet) then change
        // to yyyy-MM (E) for displaying
        // else show as it is
        var rawValue: String?
        if value.count == 6 {
            let inputDateFormat = DateFormatter()
            inputDateFormat.dateFormat = "yyyyMM"
            inputDateFormat.locale = Locale.current
            inputDateFormat.timeZone = TimeZone(abbreviation: "GMT")
            
            let outputDateFormat = DateFormatter()
            outputDateFormat.dateFormat = "yyyy-MM"
            outputDateFormat.locale = Locale.current
            rawValue = outputDateFormat.string(from: inputDateFormat.date(from: value)!)
        }
        if rawValue != nil {
            return rawValue!
        }else{
            return value
        }
    }
    
    class func getTodayWithFormat(format:String="yyyyMMdd")->String{
        let dateFormatter : DateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        
        let newDate = Date()
        let newDateString = dateFormatter.string(from: newDate)
        
        return newDateString
    }
    
    class func getYYYYMMHHMMSSValue(text:String) -> String {
        var rawValue: String?
        if text.count == 19 {
            let inputDateFormat = DateFormatter()
            inputDateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
            inputDateFormat.locale = Locale.current
            inputDateFormat.timeZone = TimeZone(abbreviation: "GMT")
            
            let outputDateFormat = DateFormatter()
            outputDateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
            outputDateFormat.locale = Locale.current
            
            if let date = inputDateFormat.date(from: text) {
                rawValue = outputDateFormat.string(from: date )
            } else {
                inputDateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
                if let date = inputDateFormat.date(from: text) {
                    rawValue = outputDateFormat.string(from: date )
                }
            }
        }
        
        if rawValue != nil {
            return rawValue!
        }else{
            return text
        }
    }
    
    //180725 hwon.kim
    //앱코
    //    1. '수주주문조회(Web)'
    //    2. '수주조회'
    //    3. '출하의뢰조회'
    //    4. '판매보관품출고요청조회'
    //    5. '거래명세서조회' 화면의 '거래명세서번호'의 최종저장시간 컬럼 추가(YYYY-MM-DD HH:MM:ss) 된 것의 표시값이
    //    YYYY-MM-DD 'T' HH-MM-SS.SSS 의 방식으로 표시되고 있습니다.
    
    //WBS 수주조회
    //    YYYY-MM-DD 'T' HH-MM-SS 의 방식으로 표시되고 있습니다.
    class func getYYYYMMHHMMSSText(text:String) -> String {
        // if value is in yyyyMM format (value comes from dataSet) then change
        // else show as it is
        var rawValue: String?
        
        let inputDateFormat = DateFormatter()
        inputDateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSS"
        inputDateFormat.locale = Locale.current
        
        let outputDateFormat = DateFormatter()
        outputDateFormat.dateFormat = "yyyy-MM-dd HH:mm:ss"
        outputDateFormat.locale = Locale.current
        
        if let date = inputDateFormat.date(from: text) {
            rawValue = outputDateFormat.string(from: date )
        }
        else {
            inputDateFormat.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
            if let date = inputDateFormat.date(from: text) {
                rawValue = outputDateFormat.string(from: date )
            }
        }
        
        if rawValue != nil {
            return rawValue!
        }else{
            return text
        }
    }
    
    
    class func getPWExpiredDayCount(_ userPwdChgDate:String) -> Int{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMdd"
        dateFormatter.timeZone = TimeZone(abbreviation: "GMT")
        let chgDate = dateFormatter.date(from: userPwdChgDate)
        let currDate = Date()
        
        let calendar = NSCalendar.current
        let date1 = calendar.startOfDay(for: chgDate!)
        let date2 = calendar.startOfDay(for: currDate)
        let components = calendar.dateComponents([.day], from: date1, to:date2)
        return components.day ?? 0
//        return 90
    }
    
    // Firebase Companity
    class func encodeAsFirebaseKey(_ encodeStr : String) -> String{
        return encodeStr.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: ".", with: "%2E").replacingOccurrences(of: "$", with: "%24").replacingOccurrences(of: "[", with: "%5B").replacingOccurrences(of: "]", with: "%5D").replacingOccurrences(of: "/", with: "%2F")
    }
    class func decodeAsFirebaseKey(_ decodeStr : String) -> String {
        return decodeStr.replacingOccurrences(of: " ", with: "").replacingOccurrences(of: "%2E", with: ".").replacingOccurrences(of: "%24", with: "$").replacingOccurrences(of: "%5B", with: "[").replacingOccurrences(of: "%5D", with: "]").replacingOccurrences(of: "%2F", with: "/")
    }
    class func makeFormOfXmlParam(VariableValues: [[String]],DataBlockName: String,  WorkingTagValue: String) -> String {
        
        var combineBaseAndDynamicValues: [[String]] = []
        combineBaseAndDynamicValues.append(["WorkingTag", WorkingTagValue])// @workingTag
        combineBaseAndDynamicValues.append(["IDX_NO", "1"])
        combineBaseAndDynamicValues.append(["Status", "0"])
        combineBaseAndDynamicValues.append(["DataSeq", "1"])
        combineBaseAndDynamicValues.append(["Selected", "1"])
        combineBaseAndDynamicValues.append(["TABLE_NAME", DataBlockName])
        combineBaseAndDynamicValues.append(["IsChangedMst", "0"])
        combineBaseAndDynamicValues.append(contentsOf: VariableValues)
        
        var testString = ""
        for keyData in combineBaseAndDynamicValues {
            testString = testString + makeXmlForm(keyName: keyData[0], isOpen: true) + keyData[1] + makeXmlForm(keyName: keyData[0], isOpen: false)
        }
        
        var xmlDocString = ""
        xmlDocString = makeXmlForm(keyName: "ROOT", isOpen: true)
        xmlDocString = xmlDocString + makeXmlForm(keyName: DataBlockName, isOpen: true)
        xmlDocString = xmlDocString + testString
        xmlDocString = xmlDocString + makeXmlForm(keyName: DataBlockName, isOpen: false)
        xmlDocString = xmlDocString + makeXmlForm(keyName: "ROOT", isOpen: false)
        
        return xmlDocString
    }
    
   class func makeXmlForm( keyName: String, isOpen: Bool) -> String {
        var xmlKey = ""
        
        if (isOpen) {
            xmlKey = "<\(keyName)>"
        } else {
            xmlKey = "</\(keyName)>"
        }
        return xmlKey
    }
    
    class func erpServiceArrList(XmlDoc: String,companySeq: Int, LanguageSeq: Int, UserSeq: Int) -> [String] {
        var serviceArrList: [String] = []
        
        serviceArrList.append(XmlDoc)
        serviceArrList.append("")// @xmlFlags
        serviceArrList.append("")// @ServiceSeq
        serviceArrList.append("")// @WorkingTag
        serviceArrList.append(String(companySeq))// @CompanySeq
        serviceArrList.append(String(LanguageSeq))// @LanguageSeq
        serviceArrList.append(String(UserSeq))// @UserSeq
        serviceArrList.append("")// @PgmSeq
        
        return serviceArrList;
    }
}
    
    
extension String {
    func beginsWith (_ str: String) -> Bool {
        if let range = self.range(of: str) {
            return range.lowerBound == self.startIndex
        }
        return false
    }
    func endsWith (_ str: String) -> Bool {
        if let range = self.range(of: str, options: NSString.CompareOptions.backwards) {
            return range.upperBound == self.endIndex
        }
        return false
    }
    subscript(integerIndex: Int) -> Character {
        let index = self.index(startIndex, offsetBy: integerIndex)
        return self[index]
    }
    
    subscript(integerRange: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: integerRange.lowerBound)
        let end = index(startIndex, offsetBy: integerRange.upperBound)
        let range = start..<end
        return String(self[range])
    }
    
    //0919 change password
    func filledLeftWith(_ filledWith:String = "0") -> String{
        var str = self
        while str.count < 5 {
            str = filledWith + str
        }
        return str
    }
    static func compareAppVersion(basic_version:String,compare_version:String)->Bool{
        guard basic_version != "-1" else {
            return true
        }
        var isSmaller = false
        //. split -> 하나씩 비교
        let basic_version_arr = basic_version.components(separatedBy: ".")
        let compare_version_arr = compare_version.components(separatedBy: ".")

        guard compare_version_arr.count > 2 else {
            return false
        }
        
        if basic_version_arr.count > 2 {
            var i = 0
            repeat {
                if let basic_version_first = Int(basic_version_arr[i]) {
                    if let compare_version_first = Int(compare_version_arr[i]) {
                        if basic_version_first < compare_version_first {
                            isSmaller = true
                        }
                        else if basic_version_first > compare_version_first {
                            break;
                        }
                    }
                }
                i += 1
            } while (i < 3) && !isSmaller
        }
        return isSmaller
    }
}
