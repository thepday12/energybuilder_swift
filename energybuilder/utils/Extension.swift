//
//  Utils.swift
//  LocateMyLot
//
//  Created by Thep To Kim on 2/6/17.
//  Copyright © 2017 ThepTK. All rights reserved.
//

import Foundation
import UIKit

extension String {
    
//    var floatValue: Float {
//        let nf = NumberFormatter()
//        nf.decimalSeparator = "."
//        if let result = nf.number(from: self) {
//            return result.floatValue
//        } else {
//            nf.decimalSeparator = ","
//            if let result = nf.number(from: self) {
//                return result.floatValue
//            }
//        }
//        return 0
//    }
    
    var formatDecimalValue:String{
        let formatter = NumberFormatter()
        formatter.allowsFloats = true // Default is true, be explicit anyways
        let decimalSeparator = formatter.decimalSeparator ?? "."
        return self.replacingOccurrences(of: decimalSeparator, with: ".")
    }
    
    var formatDecimalValueWithLocation:String{
        let formatter = NumberFormatter()
        formatter.allowsFloats = true // Default is true, be explicit anyways
        let decimalSeparator = formatter.decimalSeparator ?? "."
        return self.replacingOccurrences(of: ".", with: decimalSeparator)
    }
    
    
    var toDate:Date{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = MY_DATE_FORMAT
        var date = Date()
        if let value = dateFormatter.date(from: self) {
            date = value
        }
        return date
    }
    var getHidenPhone:String{
        
        let length = self.characters.count
        var result = ""
        for _ in 0..<length - 3 {
            result += "*"
        }
        var data = self
        if length > 3 {
            let index = self.index(self.startIndex, offsetBy: length - 3)
            data = self.substring(from: index)
        }
        result += data
        return result
    }
    var floatValue: Float {
        if (self ).isEmpty{
            return 0
        }else{
            return (self as NSString).floatValue
        }
    }
    
    var intValue: Int {
        if (self ).isEmpty{
            return 0
        }else{
            return (self as NSString).integerValue
        }
    }
    
    var boolValue: Bool {
        if (self ).isEmpty{
            return false
        }else{
            return (self as NSString).boolValue
        }
    }
    
    var doubleValue: Double {
        if (self ).isEmpty{
            return 0
        }else{
            return (self as NSString).doubleValue
        }
    }
    
    var  formatPhone:String {
        if (!self.isEmpty) {
            if (self.hasPrefix("+")) {
                return self
            } else {
                return "+65" + self
            }
        } else {
            return self;
        }
    }
    
    var isValidEmail: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    var isValidNumber: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[0-9]*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    var isValidPhoneNumber: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[+0-9][0-9]*$", options: .caseInsensitive)
            return regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil
        } catch {
            return false
        }
    }
    
    
    var isValidPassword: Bool {
        do {
            let regex = try NSRegularExpression(pattern: "^[a-zA-Z_0-9\\-_,;.:#+*?=!§$%&/()@]+$", options: .caseInsensitive)
            if(regex.firstMatch(in: self, options: NSRegularExpression.MatchingOptions(rawValue: 0), range: NSMakeRange(0, self.characters.count)) != nil){
                
                if(self.characters.count>=6 && self.characters.count<=20){
                    return true
                }else{
                    return false
                }
            }else{
                return false
            }
        } catch {
            return false
        }
    }
    
    //To check text field or String is blank or not
    var isBlank: Bool {
        get {
            let trimmed = trimmingCharacters(in: CharacterSet.whitespaces)
            return trimmed.isEmpty
        }
    }
    
    func containtsString(string:String)->Bool{
        if string.range(of:"Swift") != nil{
            return true
        }else{
            return false
        }
    }
    
    func containtsStringNotCaseSensitive(string:String) -> Bool{
        // alternative: not case sensitive
        if self.lowercased().range(of:string.lowercased()) != nil {
            return true
        }else{
            return false
        }
    }
}

extension Int {
    var stringValue: String {
        return  String(self)
    }
    var format2Character:String{
        if self > 9 {
            return "\(self)"
        }else{
            return "0\(self)"
        }
    }
}

extension Float {
    var stringValue: String {
        return  String(self)
    }
    
    var getValueRadius:String{
        var distance = ""
        let radius:Int = Int(self)
        if self < 1000 {
            distance = "\(radius) m"
        } else {
            let km:Int = Int(radius / 1000)
            let afterDot:Int = Int((radius - (km * 1000)) / 100)
            if (afterDot > 0) {
                distance = "\(km).\(afterDot) km"
            } else {
                distance = "\(km) km"
            }
        }
        return distance
    }
    
}

extension Double {
    var stringValue: String {
        return  String(self)
    }
    
    var getTextRatesFormat:String{
        let doubleStr = String(format: "%.2f", self)
        return doubleStr
    }
    var getTextDateTimeFormat:String{
        var result = ""
        let date:Date = Date(timeIntervalSince1970: self)
        //            NSDate(timeIntervalSince1970: self)
        let calendar = Calendar.current
        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date).format2Character
        let day = calendar.component(.day, from: date).format2Character
        let hour = calendar.component(.hour, from: date).format2Character
        let minute = calendar.component(.minute, from: date).format2Character
        let second = calendar.component(.second, from: date).format2Character
        
        result = "\(year)/\(month)/\(day) \(hour):\(minute):\(second)"
        
        return result
    }
    var getTextFormatEntryTime:String {
        var result = ""
        let date:Date = Date(timeIntervalSince1970: self)
        //            NSDate(timeIntervalSince1970: self)
        let calendar = Calendar.current
        //        let year = calendar.component(.year, from: date)
        let month = calendar.component(.month, from: date).format2Character
        let day = calendar.component(.day, from: date).format2Character
        let hour = calendar.component(.hour, from: date).format2Character
        let minute = calendar.component(.minute, from: date).format2Character
        
        
        result = "Entry time \(day)/\(month) \(hour):\(minute)"
        
        return result
    }
    
    
    
    func addMin(mins:Double)->Double{
        let result = self + mins * 60
        return result
    }
}

extension Date {
    func addMin(mins:Double) -> Date{
        var date:Date = self
        let time:Double = 60 * mins
        date.addTimeInterval(time)
        return date
    }
}
extension UIColor {
    static let colorPrimary:String = "#2dcc70"
    static let colorPrimaryDark:String = "#26b161"
    static let colorBlue:String = "#3498db"
    static let tintColorPrimary:UIColor = UIColor.white
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(netHex:Int) {
        self.init(red:(netHex >> 16) & 0xff, green:(netHex >> 8) & 0xff, blue:netHex & 0xff)
    }
    
    convenience init(hex:String) {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            self.init(red:1, green:1, blue:1,alpha:1)
        }else{
            
            var rgbValue:UInt32 = 0
            Scanner(string: cString).scanHexInt32(&rgbValue)
            self.init(
                red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
                green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
                blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
                alpha: CGFloat(1.0)
            )
            
        }
    }
    
    func hexStringToUIColor (hex:String) -> UIColor {
        var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
        
        if (cString.hasPrefix("#")) {
            cString.remove(at: cString.startIndex)
        }
        
        if ((cString.characters.count) != 6) {
            return UIColor.gray
        }
        
        var rgbValue:UInt32 = 0
        Scanner(string: cString).scanHexInt32(&rgbValue)
        
        return UIColor(
            red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
            green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
            blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
            alpha: CGFloat(1.0)
        )
    }
    
    
    
    
}

extension UIImageView {
    
    
    
    func calculateRectOfImageInImageView() -> CGRect {
        let imageViewSize = self.frame.size
        let imgSize = self.image?.size
        
        guard let imageSize = imgSize, imgSize != nil else {
            return CGRect.zero
        }
        
        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHeight = imageViewSize.height / imageSize.height
        let aspect = fmin(scaleWidth, scaleHeight)
        
        var imageRect = CGRect(x: 0, y: 0, width: imageSize.width * aspect, height: imageSize.height * aspect)
        // Center image
        imageRect.origin.x = (imageViewSize.width - imageRect.size.width) / 2
        imageRect.origin.y = (imageViewSize.height - imageRect.size.height) / 2
        
        // Add imageView offset
        imageRect.origin.x += self.frame.origin.x
        imageRect.origin.y += self.frame.origin.y
        
        return imageRect
    }
    
    func getScale()->CGFloat{
        let imageViewSize = self.frame.size
        let imgSize = self.image?.size
        guard let imageSize = imgSize, imgSize != nil else {
            return 1
        }
        let scaleWidth = imageViewSize.width / imageSize.width
        let scaleHeight = imageViewSize.height / imageSize.height
        let aspect = fmin(scaleWidth, scaleHeight)
        return aspect;
    }
    
    func setAvatar(image:UIImage){
        if image.size.width == image.size.height {
            self.contentMode = .scaleAspectFit
        }else{
            self.contentMode = .scaleAspectFill
            
        }
        self.image = image
    }
}
extension UIImage {
    func imageTintWithColor(tintColor: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(self.size, false, self.scale)
        tintColor.setFill()
        
        let context = UIGraphicsGetCurrentContext()! as CGContext
        context.translateBy(x: 0, y: self.size.height)
        context.scaleBy(x: 1.0, y: -1.0);
        context.setBlendMode(CGBlendMode.normal)
        
        let rect = CGRect(x:0, y:0, width:self.size.width, height:self.size.height)
        context.clip(to: rect, mask: self.cgImage!)
        context.fill(rect)
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()! as UIImage
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
    
}

extension UIView {
    
    func setBackgroundDropdown(){
        self.setRadiusForView(backGroundColor: UIColor.init(hex: "#EEEEEE").cgColor)
    }
    
    func setBackgroundDate(){
        self.setRadiusForView(backGroundColor: UIColor.init(hex: "#FAFAFA").cgColor)
    }
    
    func setRadiusForView(radius:CGFloat?=5,backGroundColor:CGColor?=UIColor.white.cgColor){
        self.layer.cornerRadius = radius!
        self.clipsToBounds = true
        self.layer.backgroundColor = backGroundColor
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.gray.cgColor
    }
    
    func drawLine(_ rect: CGRect) {
        let aPath = UIBezierPath()
        
        aPath.move(to: CGPoint(x:20, y:50))
        
        aPath.addLine(to: CGPoint(x:300, y:600))
        
        //Keep using the method addLineToPoint until you get to the one where about to close the path
        
        aPath.close()
        
        //If you want to stroke it with a red color
        UIColor.red.set()
        aPath.stroke()
        //If you want to fill it as well
        aPath.fill()
    }
    
    func drawLineFromPoint(start : CGPoint, toPoint end:CGPoint) {
        //        self.layer.sublayers = nil
        //design the path
        let path = UIBezierPath()
        path.move(to: start)
        path.addLine(to: end)
        //         path.addLine(to: CGPoint(x: 200, y: 100))
        
        //        let dashes: [CGFloat] = [path.lineWidth * 0, path.lineWidth * 2]
        //        path.setLineDash(dashes, count: dashes.count, phase: 0)
        //        path.lineCapStyle = CGLineCap.round
        //design path in layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.path = path.cgPath
        shapeLayer.strokeColor = UIColor.init(hex: "#3498db").cgColor
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.lineWidth = 2.0
        shapeLayer.lineCap = "round"
        
        self.layer.addSublayer(shapeLayer)
    }
    
    func circleView(){
        self.layer.borderWidth = 1.0
        self.layer.masksToBounds = false
        self.layer.borderColor = UIColor.white.cgColor
        self.layer.cornerRadius = self.frame.size.width/2
        self.clipsToBounds = true
    }
    func clickListener(myTarget: Any, myAction: Selector){
        let tapGestureRecognizer = UITapGestureRecognizer(target:myTarget, action:myAction)
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(tapGestureRecognizer)
        
    }
    
    func setRadius(radius:CGFloat){
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
    }
    
    
    
    func isSelected()->Bool{
        if  self.backgroundColor == UIColor.init(hex: UIColor.colorBlue) {
            return true
        }
        return false
    }
    func setSelected(){
        self.backgroundColor = UIColor.init(hex: UIColor.colorBlue)
    }
    
    func setUnSelected(){
        self.backgroundColor = UIColor.clear
    }
    
    func move(x:CGFloat, y:CGFloat){
        
        if !x.isNaN && !y.isNaN{
            self.frame = CGRect(x: x, y: y, width: self.frame.size.width, height: self.frame.size.height)
        }
        //        self.transform = CGAffineTransform( translationX: x, y: y )
        
        // Or modify existing transform
        //        self.transform = self.transform.translatedBy( x: x, y: y  )
    }
    
    func setLocationInMap(imageViewMap:UIImageView, imageFile:UIImage, beaconX:Double, beaconY:Double){
        if imageFile != UIImage() {
            let rectOfMap = imageViewMap.calculateRectOfImageInImageView()
            let minX = rectOfMap.minX
            let minY = rectOfMap.minY
            let width = imageFile.size.width
            let currentWidth = rectOfMap.maxX-minX
            let scaleOfCurrentImage:CGFloat =  currentWidth/width//ivMap.getScale()
            let scaleOfX = width/720
            
            
            
            let x = CGFloat(beaconX) * scaleOfCurrentImage * scaleOfX  + minX - self.frame.width/2
            let y = CGFloat(beaconY) * scaleOfCurrentImage * scaleOfX + minY - self.frame.height/2
            
            
            self.move(x: x, y: y)
        }
    }
    
    func getScaleOfX (imageViewMap:UIImageView, imageFile:UIImage)->CGFloat{
        let width = imageFile.size.width
        let scaleOfX = width/720
        return scaleOfX * getScaleOfCurrentImage(imageViewMap:imageViewMap,imageFile:imageFile)
    }
    
    func getScaleOfCurrentImage(imageViewMap:UIImageView, imageFile:UIImage)->CGFloat{
        let rectOfMap = imageViewMap.calculateRectOfImageInImageView()
        let minX = rectOfMap.minX
        let width = imageFile.size.width
        let currentWidth = rectOfMap.maxX-minX
        let scaleOfCurrentImage:CGFloat =  currentWidth/width
        return scaleOfCurrentImage
    }
    
    func getMinY(imageViewMap:UIImageView)->CGFloat{
        let rectOfMap = imageViewMap.calculateRectOfImageInImageView()
        let minY = rectOfMap.minY
        return minY
    }
    
    func getMinX(imageViewMap:UIImageView)->CGFloat{
        let rectOfMap = imageViewMap.calculateRectOfImageInImageView()
        let minX = rectOfMap.minX
        return minX
    }
}
extension UIButton{
    func setRadiusForButton(backGroundColor:CGColor?=UIColor.white.cgColor){
        
        self.setRadiusForView(radius:10, backGroundColor:backGroundColor)
        self.setBackgroundImage(#imageLiteral(resourceName: "bg_button_press"), for: .highlighted)
    }
    
}
extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
}


