//
//  ViewController.swift
//  XmlToPlist
//
//  Created by ouyang wenyuan on 26/02/2018.
//  Copyright © 2018 robotman. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, ParserFinishDelegate {

    
    @IBOutlet  var inputEn:NSTextView!
    @IBOutlet  var inputZh:NSTextView!
    @IBOutlet  var outputText:NSTextView!
    @IBOutlet  var resultView:NSTextField!
    @IBOutlet var openEnFile:NSButton!
    @IBOutlet var openZhFile:NSButton!
    @IBOutlet var transEnXmlFile:NSButton!
    @IBOutlet var transZhXmlFile:NSButton!
    @IBOutlet var transPlistFile:NSButton!
    @IBOutlet var openSavePanel:NSButton!
    @IBOutlet weak var saveEnXmlFile: NSButton!
    @IBOutlet var saveZhXmlFile:NSButton!
    @IBOutlet weak var transStringsBtn: NSButton!
    @IBOutlet weak var saveStringsBtn: NSButton!
    @IBOutlet var localStringsText: NSTextView!
    @IBOutlet weak var saveStringPlist: NSButton!
    @IBOutlet weak var reverseStringsBtn: NSButton!
    @IBOutlet weak var reverseKeyBtn: NSButton!
    @IBOutlet weak var reversePlistBtn: NSButton!
    @IBOutlet weak var reverseValueBtn: NSButton!
    
    var wordDict:NSMutableDictionary?
    var rootDict:NSMutableDictionary?
    
    var xmlFilePath:URL?
    var txtFilePath:URL?
    var transFilePath:URL?
    let xmlhelper:XmlParseHelper = XmlParseHelper()
    var enxmlDoc:XMLDocument?
    
    func parseFinish(dict: NSMutableDictionary) {
        print("dict = \(dict.count)")
        self.rootDict = dict;
        var  i:Int = 0
        let arr:NSMutableArray = NSMutableArray(capacity: dict.count / 8)
        var subDict:NSMutableDictionary = NSMutableDictionary(capacity: 8)
        for (key,value) in dict {
            if  i % 8 == 0 {
                subDict = NSMutableDictionary(capacity: 8)
                subDict.setValue(value, forKey: key as! String)
                arr.add(subDict)
            }else{
                subDict.setValue(value, forKey: key as! String)
            }
            i = i + 1
        }
        wordDict = NSMutableDictionary()
        wordDict?.setValue(arr, forKey: "Days")
        self.resultView?.stringValue = "xml 转化 plist文件成功"
        outputText.string = (wordDict?.description)!
    }
    
    func parseError(message: String) {
        self.resultView?.stringValue = message
    }
    
    
    @objc
    func wordToPlist(words:NSArray, wordsTrans:NSArray) {
        let dict:NSMutableDictionary = NSMutableDictionary()
        for i in 0 ..< words.count {
            dict.setValue(wordsTrans[i], forKey: words[i] as! String)
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        xmlhelper.delegate = self

        // Do any additional setup after loading the view.
        let bgView = NSView(frame: view.frame)
        bgView.layer?.backgroundColor = NSColor.cyan.cgColor
        self.view.addSubview(bgView)
        let logoView = NSImageView(frame: NSRect(x: bgView.frame.width - 50, y:  0, width: 50, height: 50))
        logoView.image = NSImage.init(imageLiteralResourceName: "g6")
        bgView.addSubview(logoView)
        
        resultView?.textColor = NSColor.red
        let readme:String = """
        xml 转化 plist 小软件  主要为学单词词库开发； 将anrdoid格式的string.xml,转成ios格式的plist文件；使用方法：readme.pdf ； Create by ouyang。
        """
        resultView?.stringValue = readme

//        bgView.addSubview(resultView!)
//        NSWorkspace.shared.open(URL(fileURLWithPath: "/System/Library/PreferencePanes/Security.prefPane"))
        
        openEnFile.tag = 1
        openEnFile.action = #selector(openFile(sender: ))
        
        openZhFile.tag = 3
        openZhFile.action = #selector(openFile(sender: ))
        
        saveZhXmlFile.tag = 3
        saveZhXmlFile.action = #selector(openSavePanel(sender: ))
        saveEnXmlFile.tag = 1
        saveEnXmlFile.action = #selector(openSavePanel(sender: ))
        openSavePanel.tag = 2
        openSavePanel.action = #selector(openSavePanel(sender: ))
        
        transEnXmlFile.action = #selector(transEnXml(sender:))
        transZhXmlFile.action = #selector(transZhXml(sender:))
        transPlistFile.action = #selector(transToPlist(sender:))
        
        
        transStringsBtn.action = #selector(transToStrings(sender:))
        saveStringsBtn.tag = 5
        saveStringsBtn.action = #selector(openSavePanel(sender:))
        
        saveStringPlist.tag = 4
        saveStringPlist.action = #selector(openSavePanel(sender:))
       
        reverseStringsBtn.tag = 4
        reverseStringsBtn.action = #selector(openFile(sender: ))
    }
    
    @objc
    func transEnXml(sender:NSButton)  {
        if self.inputEn.string .isEmpty  {
            self.resultView?.stringValue = "请先导入 key 文件"
            return
        }
        
        if !self.inputEn.string.starts(with: "<resources>") {
            let newstrs:[String] = inputEn.string.components(separatedBy: CharacterSet.newlines)
            self.enxmlDoc = xmlhelper.createxml(strArray: newstrs)
            inputEn.string = (self.enxmlDoc?.description)!
        }
    }
    
    @objc
    func transZhXml(sender:NSButton)  {
        if self.inputEn.string .isEmpty  {
              self.resultView?.stringValue = "请先导入 key 文件"
            return
        }
//                if self.enxmlDoc == nil  {
//                    print("no en xml")
//                    self.resultView?.stringValue = "请先生成 英文的xml 文件"
//                    return
//                }
        if !self.inputEn.string.starts(with: "<resources>") {
            let newstrs:[String] = inputEn.string.components(separatedBy: CharacterSet.newlines)
            var zhstrs:[String]?
            if !self.inputZh.string .isEmpty && !self.inputZh.string.starts(with: "<resources>") {
                  zhstrs = inputZh.string.components(separatedBy: CharacterSet.newlines)
                 self.enxmlDoc = xmlhelper.createXmlByTwoArray(strArray: newstrs, transArray: zhstrs)
            } else if !self.inputZh.string .isEmpty && self.inputZh.string.starts(with: "<resources>") {
                 self.resultView?.stringValue = "已经转化完成"
            } else {
                 self.enxmlDoc = xmlhelper.createxml(strArray: newstrs)
            }
           
            inputZh.string = (self.enxmlDoc?.description)!
        }else {
            if !self.inputZh.string .isEmpty && !self.inputZh.string.starts(with: "<resources>") {
               let zhstrs = inputZh.string.components(separatedBy: CharacterSet.newlines)
                self.enxmlDoc = xmlhelper.transXML(strArray: zhstrs, doc: self.enxmlDoc!)
                inputZh.string = (self.enxmlDoc?.description)!
            
            } else {
                  self.resultView?.stringValue = "请先导入 翻译 文件"
            }
 
        }
   
      
    }
    
    @objc
    func transToPlist(sender:NSButton)  {
        if self.inputZh.string.isEmpty {
            openFinderPanel(tag: 2)
            return
        }
        
        if self.enxmlDoc == nil  {
            print("no en xml")
//            self.resultView?.stringValue = "请先生成 英文的xml 文件"
            if !self.inputEn.string .isEmpty && !self.inputEn.string.starts(with: "<resources>")  &&  !self.inputZh.string .isEmpty && !self.inputZh.string.starts(with: "<resources>"){
                xmlhelper.createDict(strArray: inputEn.string.components(separatedBy: CharacterSet.newlines), transArray: inputZh.string.components(separatedBy: CharacterSet.newlines))
            }
            return
        }

        xmlhelper.xmlDocToPlist(doc: self.enxmlDoc!)
    }
    
    @objc
    func transToStrings(sender:NSButton)  {

        
            //            self.resultView?.stringValue = "请先生成 英文的xml 文件"
            if !self.inputEn.string .isEmpty && !self.inputEn.string.starts(with: "<resources>")  &&  !self.inputZh.string .isEmpty && !self.inputZh.string.starts(with: "<resources>"){
//                xmlhelper.createDict(strArray: inputEn.string.components(separatedBy: CharacterSet.newlines), transArray: inputZh.string.components(separatedBy: CharacterSet.newlines))
                let multiStrs:NSMutableString = NSMutableString()
                 let newstrs:[String] = inputEn.string.components(separatedBy: CharacterSet.newlines)
                 let zhstrs:[String] = inputZh.string.components(separatedBy: CharacterSet.newlines)
                let array:NSMutableArray = NSMutableArray()
                let array1:NSMutableArray = NSMutableArray()
    
                for str in newstrs {
                    if !str.isEmpty {
                        array.add(str)
                    }
                }
                for str in zhstrs {
                    if !str.isEmpty {
                        array1.add(str)
                    }
                }
                for i in 0 ..< array.count {
                    multiStrs.append("\(array[i])=\"\(array1[i])\";")
                    multiStrs.append("\n")
                }
                self.localStringsText.string = multiStrs as String
            }
        
    }
    
    
    
//    @objc
//    func transPlist() -> Bool {
//        if xmlFilePath != nil {
//            self.readxml(url: xmlFilePath!)
//            return true
//        }
//        self.resultView?.stringValue = "请先选择xml文件"
//        return false
//    }
//
//    func readxml(url: URL) {
//        print("read xml")
//        xmlhelper.startParse(url: url)
//        NotificationCenter.default.addObserver(self, selector: #selector(reloadView), name: NSNotification.Name(rawValue: "reloadViewNotification"), object: nil)
//    }
    
     @objc
    func openSavePanel(sender:NSButton) {
        print("open save panel")
        self.saveFinderPanel(tag: sender.tag)
    }
    
    func saveFinderPanel(tag: Int)  {
        print("tag= \(tag)")
        let savePanel:NSSavePanel = NSSavePanel.init()
        savePanel.title = "保存文件"
        savePanel.message = "选择存储路径"
        savePanel.directoryURL = URL.init(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
//        savePanel.nameFieldStringValue = (tag == 1 || tag == 3) ? "words.xml" : "words.plist"
        if tag == 5 {
            savePanel.nameFieldStringValue = "local.strings"
        } else if (tag == 2 || tag == 4) {
            savePanel.nameFieldStringValue = "words.plist"
        } else if tag == 1 {
            if (!self.inputEn.string .isEmpty && self.inputEn.string.starts(with: "<resources>")) {
                savePanel.nameFieldStringValue = "words.xml"
            } else {
                savePanel.nameFieldStringValue = "keys.txt"
            }
        } else if tag == 3 {
            if  !self.inputZh.string .isEmpty && self.inputZh.string.starts(with: "<resources>") {
                savePanel.nameFieldStringValue = "words.xml"
            } else {
                savePanel.nameFieldStringValue = "values.txt"
            }
        }
        savePanel.allowsOtherFileTypes = true
//        savePanel.allowedFileTypes = ["plist","xml","txt","strings"]
        savePanel.isExtensionHidden = false
        savePanel.canCreateDirectories = true
        savePanel.begin { (result) in
            if result == NSApplication.ModalResponse.OK {
                //                let path:String = (savePanel.url?.path)!
                if tag == 1 {
                    if !self.inputEn.string .isEmpty  {
                        
                        do {  try self.inputEn.string.write(to: savePanel.url!, atomically: true, encoding: String.Encoding.utf8)
                        } catch  {
                            print("error \(error)")
                        }
                    }
        
                    return
                } else if tag == 2 {
                    //                    self.transPlist()
                    if self.wordDict != nil {
                        self.wordDict?.write(to: savePanel.url!, atomically: true)
                        self.resultView?.stringValue = "存储plist文件成功"
                    }
                } else if tag == 3 {
                    if !self.inputZh.string .isEmpty  {
                        do {  try self.inputZh.string.write(to: savePanel.url!, atomically: true, encoding: String.Encoding.utf8)
                        } catch  {
                            print("error \(error)")
                        }
                    }
                  
                } else if tag == 4 {
                    if self.rootDict != nil {
                        self.rootDict?.write(to: savePanel.url!, atomically: true)
                        self.resultView?.stringValue = "存储plist文件成功"
                    }
                    
                } else if tag == 5 {
                    if !self.localStringsText.string .isEmpty {
                        do {  try self.localStringsText.string.write(to: savePanel.url!, atomically: true, encoding: String.Encoding.utf8)
                        } catch  {
                            print("error \(error)")
                        }
                    }
                }
            }
        }
    }
    @objc
    func openFile(sender:NSButton) {
       openFinderPanel(tag: sender.tag)
    }
    
    func openFinderPanel(tag:Int)  {
        let panel:NSOpenPanel = NSOpenPanel.init()
        panel.allowsMultipleSelection = true
        panel.directoryURL = URL.init(fileURLWithPath: NSHomeDirectory(), isDirectory: true)
        panel.begin { (result) in
            if result == NSApplication.ModalResponse.OK {
                //                self.readxml(url: panel.url!)
                if tag == 1 {
                    print("txturl = \(panel.url!)")
                    self.txtFilePath = panel.url!
                    self.resultView?.stringValue = "读取txt文件成功"
                    self.inputEn.string = try! String(contentsOf: panel.url!, encoding: String.Encoding.utf8)
                    if (!self.inputEn.string.isEmpty && self.inputEn.string.starts(with: "<resources>")) {
                        self.enxmlDoc = try! XMLDocument.init(contentsOf: panel.url!, options: XMLNode.Options.documentTidyXML)
                    }
                }else if tag == 2 {
                    self.xmlFilePath = panel.url!
                    self.resultView?.stringValue = "读取xml文件成功"
                    self.inputZh.string = try! String(contentsOf: panel.url!, encoding: String.Encoding.utf8)
                    if (!self.inputZh.string.isEmpty && self.inputZh.string.starts(with: "<resources>")) {
                        self.enxmlDoc = try! XMLDocument.init(contentsOf: panel.url!, options: XMLNode.Options.documentTidyXML)
                    }
                    self.xmlhelper.xmlToPlist(panel.url!)
                } else if tag == 3 {
                    self.transFilePath = panel.url!
                    self.resultView?.stringValue = "读取txt文件成功"
                    self.inputZh.string = try! String(contentsOf: panel.url!, encoding: String.Encoding.utf8)
                    if (!self.inputZh.string.isEmpty && self.inputZh.string.starts(with: "<resources>")) {
                         self.enxmlDoc = try! XMLDocument.init(contentsOf: panel.url!, options: XMLNode.Options.documentTidyXML)
                    }
                } else if tag == 4 {
                    self.resultView?.stringValue = "读取strings文件成功"
                    self.localStringsText.string = try! String(contentsOf: panel.url!, encoding: String.Encoding.utf8)
                    self.decomposition(str: self.localStringsText.string)
                } else if tag == 5 {
                
                    self.rootDict = NSMutableDictionary.init(contentsOf: panel.url!)
                    self.outputText.string = (self.rootDict?.description)!
                    self.enxmlDoc = self.xmlhelper.plistToXml(dict: self.rootDict!)
                    self.inputZh.string = (self.enxmlDoc?.description)!
                    
                }
            }
        }
    }
   
    /**
     localizable.strings format:
     key="value";
     to keys Array and values Array
    */
    func decomposition(str:String)  {
        let newstrs:[String] = str.components(separatedBy: CharacterSet.newlines)
        let reg: NSRegularExpression = try! NSRegularExpression(pattern: "(.{1,})=\"([^\"]{0,})\"", options: NSRegularExpression.Options.allowCommentsAndWhitespace)
        let keyStrs = NSMutableString()
        let valueStrs = NSMutableString()
        
        let newline = "\n"
        for item in newstrs {
            if !item.isEmpty {
                let range = NSRange(location: 0, length: item.count)
                let itemsub = reg.firstMatch(in: item, options: NSRegularExpression.MatchingOptions.reportCompletion, range: range)
//                print("item count \(item.count), subitem = \(itemsub?.range(at: 2)) \(itemsub?.range(at: 1))")
                keyStrs.append((item as NSString).substring(with: itemsub?.range(at: 1) as! NSRange))
                keyStrs.append(newline)
                valueStrs.append((item as NSString).substring(with: itemsub?.range(at: 2) as! NSRange))
                valueStrs.append(newline)
            }
        }
        self.inputEn.string = keyStrs as String
        self.inputZh.string = valueStrs as String
    }
    
   
    func combineXml() -> XMLDocument {
        do {
        let strs:String = try String(contentsOf: self.transFilePath!, encoding: String.Encoding.utf8)
        let newstrs:[String] = strs.components(separatedBy: CharacterSet.newlines)
           return xmlhelper.modifyXML(strArray: newstrs, fileUrl: self.xmlFilePath!)
        }catch {
            print("error= \(error)")
        }
        return XMLDocument()
    }
    
    
    func transToXml() -> XMLDocument{
//        var strArray:NSMutableArray = NSMutableArray()
       
        do {
//            let data:NSData = try NSData(contentsOf: fileUrl)
            let strs:String = try String(contentsOf: self.txtFilePath!, encoding: String.Encoding.utf8)
            let newstrs:[String] = strs.components(separatedBy: CharacterSet.newlines)
            //            strArray.addObjects(from: newstrs)
//            var savepath:String = fileUrl.relativePath
//            savepath = (savepath as NSString).replacingOccurrences(of: ".txt", with: ".xml")
//            let fm:FileManager = FileManager.default
//            if !fm.fileExists(atPath: savepath as String) {
//                fm.createFile(atPath: savepath, contents: nil, attributes: nil)
//            }
//            let newUrl = URL(fileURLWithPath: savepath)
//
//            print("savepath =\(savepath)")
            //            newUrl.appendPathExtension(".xml")
            return xmlhelper.createxml(strArray: newstrs)
        } catch  {
            print("exception\(error)")
        }
        return XMLDocument()

    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @objc
    func reloadView()  {
        print("reload view")
    }
    
    @IBAction func reveseXml(_ sender: Any) {
        
        if self.inputZh.string.isEmpty {
            openFinderPanel(tag: 3)
            return
        }
        let rootelement:XMLElement =  self.enxmlDoc!.rootElement()!
        
        let keyStrs = NSMutableString()
        let valueStrs = NSMutableString()
         let newline = "\n"
        if rootelement.name == "resources" {
            let children:[XMLNode] =  rootelement.children!
            for child in children {
                let c:XMLElement = child as! XMLElement
                let key = c.attribute(forName: "name")?.stringValue
//                wordDict.setValue(child.stringValue, forKey: key!)
                keyStrs.append(key!)
                keyStrs.append(newline)
                valueStrs.append(child.stringValue!)
                valueStrs.append(newline)
            }
            self.inputEn.string = keyStrs as String
            self.inputZh.string = valueStrs as String
        } else {
           self.resultView?.stringValue = "文本格式错误"
        }
    }
    
    @IBAction func revesePlist(_ sender: Any) {
        openFinderPanel(tag: 5)
    }
    /**
     clear content
     */
     @objc
    func clearContent()  {
        let nullstr = ""
        self.inputEn.string = nullstr
        self.inputZh.string = nullstr
        self.localStringsText.string = nullstr
        self.outputText.string = nullstr
        self.rootDict?.removeAllObjects()
        self.wordDict?.removeAllObjects()
        self.enxmlDoc = nil
        self.resultView?.stringValue = "清除内存成功"
    }
    
    @IBAction func cleanClear(_ sender: Any) {
        self.clearContent()
    }
    
    
    

}

