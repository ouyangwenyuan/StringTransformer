//
//  XmlParseHelper.swift
//  XmlToPlist
//
//  Created by ouyang wenyuan on 26/02/2018.
//  Copyright © 2018 robotman. All rights reserved.
//

import Cocoa
public protocol ParserFinishDelegate {
    func parseFinish(dict:NSMutableDictionary)
    
    
//    func xmlCreateFinish(xml:XMLDocument)
    
    
    func parseError(message:String)
}

class XmlParseHelper: NSObject, XMLParserDelegate {

//    var dict:NSMutableDictionary = NSMutableDictionary()
//    var currentNodeName:String?
//    var keyName:String?
    var delegate: ParserFinishDelegate?

   
    
    /**
     生成只有key的xml，value也为key
     */
    func createxml(strArray:[String])  -> XMLDocument{
        return self.createXmlByTwoArray(strArray: strArray, transArray: nil)
    }
    
    /**
     用翻译的文本替换原有的xml
     */
    func transXML(strArray:[String],doc:XMLDocument) -> XMLDocument {

        let array = NSMutableArray()
        
        for str in strArray {
            if !str.isEmpty {
                array.add(str)
            }
        }
        let rootelement:XMLElement =  doc.rootElement()!
        if rootelement.children?.count != array.count {
            delegate?.parseError(message: "解析错误，请检查翻译文件和原文件的单词和数量")
            return doc
        }
        if rootelement.name == "resources" {
            let children:[XMLNode] =  rootelement.children!
            for child in children {
                child.setStringValue(array[child.index] as! String, resolvingEntities: false)
            }
        }
        return doc
        
    }
    
    /**
     xml文件从文件中获取
     */
    func modifyXML(strArray:[String], fileUrl:URL) -> XMLDocument {
        var doc:XMLDocument = XMLDocument()
        do {
            doc = try  XMLDocument.init(contentsOf: fileUrl, options: XMLNode.Options.documentTidyXML)
            return transXML(strArray: strArray, doc: doc)
        } catch  {
            print("\(error)")
            delegate?.parseError(message: error.localizedDescription)
        }
        return doc
    }
    


    
    /**
     通过俩个字符串数组合成xml文件
     */
    func createXmlByTwoArray(strArray:[String],transArray:[String]?) -> XMLDocument {
        let rootelement = XMLElement(name: "resources")
        let doc:XMLDocument = XMLNode.document(withRootElement: rootelement) as! XMLDocument
        
        let array:NSMutableArray = NSMutableArray()
 
        for str in strArray {
            if !str.isEmpty {
                array.add(str)
            }
        }
        var array1:NSMutableArray = NSMutableArray()
        if transArray == nil {
            array1 = array
        } else {
            for str in transArray! {
                if !str.isEmpty {
                    array1.add(str)
                }
            }
        }
        
        if array1.count != array.count {
            delegate?.parseError(message: "解析错误，请检查翻译文件和原文件的单词和数量")
            return doc
        }
        
        for i in 0 ..< array.count {
            let node = XMLElement(name: "string", stringValue: array1[i] as? String)
            node.addAttribute(XMLNode.attribute(withName: "name", stringValue: array[i] as! String ) as! XMLNode)
            rootelement.addChild(node)
        }
      
//        delegate?.xmlCreateFinish(xml: doc)
        return doc;
    }
    
    /**
     plist 转 xml
     */
    func plistToXml(dict:NSDictionary) -> XMLDocument {
        let array:NSMutableArray = NSMutableArray()
        let array1:NSMutableArray = NSMutableArray()
        for (key,value) in dict {
            array.add(key)
            array1.add(value)
        }
        let rootelement = XMLElement(name: "resources")
        let doc:XMLDocument = XMLNode.document(withRootElement: rootelement) as! XMLDocument
        for i in 0 ..< array.count {
            let node = XMLElement(name: "string", stringValue: array1[i] as? String)
            node.addAttribute(XMLNode.attribute(withName: "name", stringValue: array[i] as! String ) as! XMLNode)
            rootelement.addChild(node)
        }
        
        //        delegate?.xmlCreateFinish(xml: doc)
        return doc;
    }
    
    /**
     通过俩个字符串数组合成plist文件
     */
    func createDict(strArray:[String],transArray:[String]?)   -> NSMutableDictionary?{

        let array:NSMutableArray = NSMutableArray()
        for str in strArray {
            if !str.isEmpty {
                array.add(str)
            }
        }
        
        var array1:NSMutableArray = NSMutableArray()
        if transArray == nil {
            array1 = array
        } else {
            for str in transArray! {
                if !str.isEmpty {
                    array1.add(str)
                }
            }
        }
        if array1.count != array.count {
            delegate?.parseError(message: "解析错误，请检查翻译文件和原文件的单词和数量")
            return nil
        }
        
        let dict:NSMutableDictionary = NSMutableDictionary()
        for i in 0 ..< array.count {
            dict.setValue(array1[i], forKey: array[i] as! String)
        }
        delegate?.parseFinish(dict: dict)
        return dict
    }
    

    /**
     内存中xml文本 转成plist 字典
     */
    public func xmlDocToPlist(doc:XMLDocument)  -> NSMutableDictionary{
        let wordDict:NSMutableDictionary = NSMutableDictionary()
        let rootelement:XMLElement =  doc.rootElement()!
        if rootelement.name == "resources" {
            let children:[XMLNode] =  rootelement.children!
            for child in children {
                let c:XMLElement = child as! XMLElement
                let key = c.attribute(forName: "name")?.stringValue
                wordDict.setValue(child.stringValue, forKey: key!)
            }
            delegate?.parseFinish(dict: wordDict)
        } else {
            delegate?.parseError(message: "解析错误，请检查文件格式")
        }
        return wordDict
    }
    
    /**
     将xml文件转化成plist 文件
     */
    func xmlToPlist(_ fileUrl: URL) -> NSMutableDictionary {
        var doc:XMLDocument = XMLDocument()
        do {
            doc = try  XMLDocument.init(contentsOf: fileUrl, options: XMLNode.Options.documentTidyXML)
            return xmlDocToPlist(doc: doc)
        } catch  {
            print("\(error)")
            delegate?.parseError(message: error.localizedDescription)
        }
        return NSMutableDictionary()
    }
    
    
//    public func startParse(url: URL)  {
//        let parser = XMLParser(contentsOf: url)
//        parser?.delegate = self
//        parser?.parse()
//    }
//
//    public func parserDidStartDocument(_ parser: XMLParser) {
////        print("clumnumber= \(parser.columnNumber),linenumber= \(parser.lineNumber)")
//        dict.removeAllObjects()
//    }
//
//
//    public func parserDidEndDocument(_ parser: XMLParser) {
//
//        delegate?.parseFinish(dict: dict)
//    }
//
//    public func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
//        currentNodeName = elementName;
//        if(elementName.isEqual("string")) {
//            keyName = attributeDict["name"]
//        }
//    }
//
//
//    public func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
//
//        if(elementName.isEqual("string")) {
//            currentNodeName = nil
//            keyName = nil
//        }
//    }
//
//    public func parser(_ parser: XMLParser, foundCharacters string: String) {
////         let str = string.trimmingCharacters(in: CharacterSet.newlines)
////          print("clumnumber= \(parser.columnNumber),linenumber= \(parser.lineNumber)")
//        if(keyName != nil) {
//            dict.setValue(string, forKey: keyName!)
//        }
//    }
}
