//
//  ViewController.swift
//  TCPremoteControl
//
//  Created by Ethan Schoen on 4/15/16.
//  Copyright © 2016 Ethan Schoen. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NSStreamDelegate {
    @IBOutlet var ipLabelVert: UILabel?
    @IBOutlet var ipLabelHori: UILabel?
    @IBOutlet var ipTextField: UITextField?
    @IBOutlet var portTextField: UITextField?
    var ip: String?
    var port: String?
    var inputStream: NSInputStream?
    var outputStream: NSOutputStream?
    var connected: Bool = false
    
    func connect(host: String, port: Int) {
        NSStream.getStreamsToHostWithName(host, port: port, inputStream: &inputStream, outputStream: &outputStream)
        if inputStream != nil && outputStream != nil {
            // Set delegate
            inputStream!.delegate = self
            outputStream!.delegate = self
            // Schedule
            inputStream!.scheduleInRunLoop(.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            outputStream!.scheduleInRunLoop(.mainRunLoop(), forMode: NSDefaultRunLoopMode)
            print("Start open()")
            // Open!
            inputStream!.open()
            outputStream!.open()
            connected = true
        }
    }
    
    
    @IBAction func tap(sender: AnyObject) {
        self.view.endEditing(true)
    }
    
    func stream(aStream: NSStream, handleEvent eventCode: NSStreamEvent) {
        if aStream === inputStream {
            switch eventCode {
            case NSStreamEvent.ErrorOccurred:
                print("input: ErrorOccurred: \(aStream.streamError?.description)")
            case NSStreamEvent.OpenCompleted:
                print("input: OpenCompleted")
            case NSStreamEvent.HasBytesAvailable:
                print("input: HasBytesAvailable")
            default:
                break
            }
        }
        else if aStream === outputStream {
            switch eventCode {
            case NSStreamEvent.ErrorOccurred:
                print("output: ErrorOccurred: \(aStream.streamError?.description)")
            case NSStreamEvent.OpenCompleted:
                print("output: OpenCompleted")
            case NSStreamEvent.HasSpaceAvailable:
                print("output: HasSpaceAvailable")
            default:
                break
            }
        }
    }
    
    @IBAction func ipButton(button: UIButton){
        if ipTextField!.text != nil{
            ip = ipTextField?.text
        }
        if portTextField!.text != nil{
            port = portTextField?.text
        }
        if (ip != nil) && (port != nil){
            let temp: String = ip! + " " + port!
            ipLabelHori!.text = temp
            ipLabelVert!.text = temp
            connect(ip!, port: Int(port!)!)
        }
    }
    
    @IBAction func upButton(button: UIButton){
        if !connected {
            let temp: String = "Please connect to a socket"
            ipLabelHori!.text = temp
            ipLabelVert!.text = temp
        } else if outputStream!.hasSpaceAvailable {
            let data: NSData = "UP\n".dataUsingEncoding(NSUTF8StringEncoding)!
            outputStream!.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        }
    }
    @IBAction func rightButton(button: UIButton){
        if !connected {
            let temp: String = "Please connect to a socket"
            ipLabelHori!.text = temp
            ipLabelVert!.text = temp
        } else if outputStream!.hasSpaceAvailable {
            let data: NSData = "RIGHT\n".dataUsingEncoding(NSUTF8StringEncoding)!
            outputStream!.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        }
    }
    @IBAction func downButton(button: UIButton){
        if !connected {
            let temp: String = "Please connect to a socket"
            ipLabelHori!.text = temp
            ipLabelVert!.text = temp
        } else if outputStream!.hasSpaceAvailable {
            let data: NSData = "DOWN\n".dataUsingEncoding(NSUTF8StringEncoding)!
            outputStream!.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        }
    }
    @IBAction func leftButton(button: UIButton){
        if !connected {
            let temp: String = "Please connect to a socket"
            ipLabelHori!.text = temp
            ipLabelVert!.text = temp
        } else if outputStream!.hasSpaceAvailable {
            let data: NSData = "LEFT\n".dataUsingEncoding(NSUTF8StringEncoding)!
            outputStream!.write(UnsafePointer<UInt8>(data.bytes), maxLength: data.length)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

