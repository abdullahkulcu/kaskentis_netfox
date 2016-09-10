//
//  NFXListCell_OSX.swift
//  netfox
//
//  Copyright © 2016 netfox. All rights reserved.
//

#if os(OSX)
    
import Cocoa

class NFXListCell_OSX: NSTableCellView 
{
    
    @IBOutlet var statusView: NSView!
    @IBOutlet var requestTimeLabel: NSTextField!
    @IBOutlet var timeIntervalLabel: NSTextField!
    
    @IBOutlet var URLLabel: NSTextField!
    @IBOutlet var methodLabel: NSTextField!
    @IBOutlet var typeLabel: NSTextField!
    
    @IBOutlet var circleView: NSView!

    let padding: CGFloat = 5
    
    // MARK: Life cycle
        
    override func awakeFromNib() {
        layer?.backgroundColor = NFXColor.clear.cgColor
        
        self.circleView.layer?.backgroundColor = NSColor.NFXGray44Color().cgColor
        self.circleView.layer?.cornerRadius = 4
        self.circleView.alphaValue = 0.2
        
        self.requestTimeLabel.font = NSFont.NFXFontBold(13)
        self.timeIntervalLabel.font = NSFont.NFXFont(12)
        self.URLLabel.font = NSFont.NFXFont(12)
        self.methodLabel.font = NSFont.NFXFont(12)
        self.typeLabel.font = NSFont.NFXFont(12)
        
    }
        
    func isNew()
    {
        self.circleView.isHidden = false
    }
    
    func isOld()
    {
        self.circleView.isHidden = true
    }
    
    func configForObject(_ obj: NFXHTTPModel)
    {
        setURL(obj.requestURL ?? "-")
        setStatus(obj.responseStatus ?? 999)
        setTimeInterval(obj.timeInterval ?? 999)
        setRequestTime(obj.requestTime ?? "-")
        setType(obj.responseType ?? "-")
        setMethod(obj.requestMethod ?? "-")
        isNewBasedOnDate(obj.responseDate ?? Date())
    }
    
    func setURL(_ url: String)
    {
        self.URLLabel.stringValue = url
    }
    
    func setStatus(_ status: Int)
    {
        if status == 999 {
            self.statusView.layer?.backgroundColor = NFXColor.NFXGray44Color().cgColor //gray
            self.timeIntervalLabel.textColor = NFXColor.white
            
        } else if status < 400 {
            self.statusView.layer?.backgroundColor = NFXColor.NFXGreenColor().cgColor //green
            self.timeIntervalLabel.textColor = NFXColor.NFXDarkGreenColor()
            
        } else {
            self.statusView.layer?.backgroundColor = NFXColor.NFXRedColor().cgColor //red
            self.timeIntervalLabel.textColor = NFXColor.NFXDarkRedColor()
            
        }
    }
    
    func setRequestTime(_ requestTime: String)
    {
        self.requestTimeLabel.stringValue = requestTime
    }
    
    func setTimeInterval(_ timeInterval: Float)
    {
        if timeInterval == 999 {
            self.timeIntervalLabel.stringValue = "-"
        } else {
            self.timeIntervalLabel.stringValue = NSString(format: "%.2f", timeInterval) as String
        }
    }
    
    func setType(_ type: String)
    {
        self.typeLabel.stringValue = type
    }
    
    func setMethod(_ method: String)
    {
        self.methodLabel.stringValue = method
    }
    
    func isNewBasedOnDate(_ responseDate: Date)
    {
        if responseDate.isGreaterThanDate(NFX.sharedInstance().getLastVisitDate()) {
            self.isNew()
        } else {
            self.isOld()
        }
    }
    
}

#endif
