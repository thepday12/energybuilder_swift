//
//  Route.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/17/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import Foundation
class Route{
    var key = ""
    var id = ""
    var name = ""
    var complete = 0
    var total = "0"
    init() {
        
    }
    init(json:[String:Any]) {
        if let value = json["key"] as? String{
            self.key = value
        }
        if let value = json["id"] as? String{
            self.id = value
        }
        if let value = json["name"] as? String{
            self.name = value
        }
        if let value = json["complete"] as? String{
            self.complete = value.intValue
        }
        if let value = json["total"] as? String{
            self.total = value
        }
    }
    
    func getIntTotal()->Int{
        return total.intValue
    }
    
}

class Point{
    var key = ""
    var id = ""
    var routeId = ""
    var name = ""
    var complete = false
    var objects = [String]()
    var fl = TotalDataCapture()
    var eu = TotalDataCapture()
    var ta = TotalDataCapture()
    var eq = TotalDataCapture()
    
    init() {
        
    }
    init(json:[String:Any]) {
        if let value = json["key"] as? String{
            self.key = value
        }
        if let value = json["id"] as? String{
            self.id = value
        }
        if let value = json["route_id"] as? String{
            self.routeId = value
        }
        if let value = json["name"] as? String{
            self.name = value
        }
        if let value = json["complete"] as? Bool{
            self.complete = value
        }
        if let value = json["FL"] as? String{
            self.fl = TotalDataCapture(name: "FLOW", total: value.intValue,type:"FL")
        }
        if let value = json["EU"] as? String{
            self.eu = TotalDataCapture(name: "ENERGY UNIT", total: value.intValue,type:"EU")
        }
        if let value = json["TA"] as? String{
            self.ta = TotalDataCapture(name: "TANK", total: value.intValue,type:"TA")
        }
        if let value = json["EQ"] as? String{
            self.eq = TotalDataCapture(name: "EQUIPMENT", total: value.intValue,type:"EQ")
        }
        
        
        if let objects = json["objects"] as? [String]{
            self.objects = objects
        }
    }
}

class TotalDataCapture{
    var name = ""
    var total = 0
    var type = ""
    init(){
        
    }
    init(name:String,total:Int,type:String) {
        self.name = name
        self.total = total
        self.type = type
    }
}

class ObjectData{
    var key = ""
    var id = ""
    var name = ""
    var type = ""
    var listPhase = [PhaseObject]()
    init(){
        
    }
    init(key:String,json:[String:Any],listValues:[String:Any]) {
        self.key =  key
        if let value = json["id"] as? String{
            self.id = value
        }
        if let value = json["name"] as? String{
            self.name = value
        }
        if let value = json["type"] as? String{
            self.type = value
        }
        
        if isEU(){
            if let value = json["event_phases"] as? [String:Any]{
//            if let value = try? JSONSerialization.jsonObject(with: "{\"1\":[\"1\",\"3\"],\"2\":[\"2\",\"6\"]}".data(using: .utf8)!) as! [String:Any]{
                let eventTypes =  listValues["CODE_EVENT_TYPE"] as! [[String:String]]
                let phaseTypes = listValues["CODE_FLOW_PHASE"] as!  [[String:String]]
                
                for item in value {//Duyet danh sach cac key
                    let idEvent = item.key
                    
                    var nameEvent = ""
                    //Lay ten event
                    for event in eventTypes{
                        if idEvent == event["value"]{
                            nameEvent = event["text"]!
                            break
                        }
                    }
                    //Duyet danh sach value(id phase) ung voi key event
                    for item2  in item.value as! [String]{
                        let idFlow = item2
                        
                        var nameFlow = ""
                        //Lay ten phase
                        for phase in phaseTypes{
                            if idFlow == phase["value"]{
                                nameFlow = phase["text"]!
                                break
                            }
                        }
                        
                        listPhase.append(PhaseObject(idEvent: idEvent, nameEvent: nameEvent, idFlow: idFlow, nameFlow: nameFlow))
                       
                    }
                }
            }
        }
    }
    
    func isEU()->Bool{
        return type=="EU";
    }
}

class ObjectAttrs{
    var key = ""
    var name = ""
    var dataType = ""
    var controlType = ""
    var enable = true
    var mandatory = false
    //var list = [String:String]()
    var listObjectVisible =  [String]()
    var listObject = [ListObject]()
    var value = ""
    var objectData = ObjectData()
    init(){
        
    }
    
    init(name:String,dataType:String,controlType:String) {
        self.name = name
        self.dataType = dataType
        self.controlType = controlType
        self.value = getCurrentDate()
    }
    
    init(name:String,dataType:String,controlType:String,objectData:ObjectData) {
        self.name = name
        self.dataType = dataType
        self.controlType = controlType
        self.objectData = objectData
        
        for item in objectData.listPhase{
            listObjectVisible.append(item.getName())
            listObject.append(ListObject(key: item.getPhaseCode(),name: item.getName()))
        }
        self.value = listObject[0].key
//        list = [String:String]()
//        for i in 0..<objectData.listPhase.count {
//            list[objectData.listPhase[i].getPhaseCode()] = objectData.listPhase[i].getName()
//        }
        
    }
    
    init(json:[String:Any],listValues:[String:Any]) {
        if let value = json["field"] as? String{
            self.key = value
        }
        
        if let value = json["name"] as? String{
            self.name = value
        }
        if let value = json["data_type"] as? String{
            self.dataType = value
        }
        if let value = json["control_type"] as? String{
            self.controlType = value
        }
        
        if let value = json["enable"] as? Bool{
            self.enable = value
        }
        if let value = json["mandatory"] as? Bool{
            self.mandatory = value
        }
        
        if let value = json["list"] as? String{
            if let list = listValues[value] as? [[String:Any]]{
//                self.list = list
                for i in 0..<list.count{
                    let item = list[i] as! [String:String]
                    listObject.append(ListObject(key: item["value"]!, name: item["text"]!))
                    
                    listObjectVisible.append(item["text"]!)
                    
                }
            }
        }
        
    }
    
    func getJsonValue()->String{
        if self.controlType == "n"{
            return "\"" + self.key + "\":\"" + self.value.formatDecimalValue + "\""
        }else{
              return "\"" + self.key + "\":\"" + self.value + "\""
        }
    }
}

class ListObject{
    var key = ""
    var name = ""
    init(){
        
    }
    init(key:String,name:String) {
        self.key =  key
        self.name = name
    }
}


class PhaseObject{
    var idEvent = ""
    var idFlow = ""
    var nameEvent = ""
    var nameFlow = ""
    init(){
        
    }
    init(idEvent:String,nameEvent:String,idFlow:String,nameFlow:String) {
        self.idEvent = idEvent
        self.nameEvent = nameEvent
        self.idFlow = idFlow
        self.nameFlow = nameFlow
    }
    
    func getName()->String{
        return nameEvent+" - "+nameFlow
    }
    func getPhaseCode()->String{
        return idFlow+"_"+idEvent
    }
}

class ObjectNumber{
    var value = ""
    var occurDate = ""
    init(value:String,occurDate:String) {
        self.value = value
        self.occurDate = occurDate
    }
    
}
