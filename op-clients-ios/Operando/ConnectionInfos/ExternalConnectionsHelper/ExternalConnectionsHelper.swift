//
//  ExternalConnectionsHelper.swift
//  Operando
//
//  Created by Costin Andronache on 6/13/16.
//  Copyright © 2016 Operando. All rights reserved.
//

import UIKit

struct IPInfo
{
    let hostname: String?
    let city: String?
    let country: String?
    let locationCoordinates: String?
    let organization: String?
    let postalCode: String?
    let region: String?
}


class ExternalConnectionInfo
{
    let connectionPair: ConnectionPair
    let connectionIPInfo: IPInfo
    init(connectionPair: ConnectionPair, connectionIPInfo: IPInfo)
    {
        self.connectionIPInfo = connectionIPInfo;
        self.connectionPair = connectionPair;
    }
}

typealias ExternalConnectionsCompletion = ((result: [ExternalConnectionInfo]?) -> Void)

class ExternalConnectionsHelper: NSObject
{
    static let loopBackAddress = "127.0.0.1"
    
    static var globalDataTask: NSURLSessionDataTask?
    
    class func getCurrentConnectionsInfoWithCompletion(completion: ExternalConnectionsCompletion?)
    {
        
        let tcpConnections = ConnectionInfoHelper.printTCPConnections()
        print(tcpConnections);
        
        let destination = NSMutableArray()
        ExternalConnectionsHelper.retrieveInfoAboutConnectionAtIndex(0, fromSource: tcpConnections, placeResultInDestination: destination) { (result) in
            
            var result: [ExternalConnectionInfo] = [];
            for i in 0 ..< destination.count
            {
                result.append(destination[i] as! ExternalConnectionInfo);
            }
            
            completion?(result: result);
        }
        
    }
    
    
    private class func retrieveInfoAboutConnectionAtIndex(index: Int, fromSource source: [ConnectionInfo],
                                                          placeResultInDestination destination: NSMutableArray,
                                                          withCompletion completion: ((result: NSArray) -> Void))
    {
        guard index >= 0 && index < source.count else {completion(result: destination); return}
        
        let foreignConnectionPair = source[index].foreignConnection;
        
        guard var ip = foreignConnectionPair.address else
        {
            retrieveInfoAboutConnectionAtIndex(index+1, fromSource: source, placeResultInDestination: destination, withCompletion: completion);
            return;
        }
        
        guard !ip.containsString(ExternalConnectionsHelper.loopBackAddress) else
        {
            retrieveInfoAboutConnectionAtIndex(index+1, fromSource: source, placeResultInDestination: destination, withCompletion: completion);
            return;
        }
        
        guard let url = NSURL(string: "http://ipinfo.io/\(ip)/json") else
        {
            retrieveInfoAboutConnectionAtIndex(index+1, fromSource: source, placeResultInDestination: destination, withCompletion: completion);
            return;
        }
        
        
        globalDataTask = NSURLSession.sharedSession().dataTaskWithRequest(NSURLRequest(URL: url)) { (data: NSData?, response:NSURLResponse?, error: NSError?) in
            
            if let ipInfo = convertToIpInfoData(data)
            {
                destination.addObject(ExternalConnectionInfo(connectionPair: foreignConnectionPair, connectionIPInfo: ipInfo));
            }
            
            dispatch_async(dispatch_get_main_queue(), { 
                retrieveInfoAboutConnectionAtIndex(index+1, fromSource: source, placeResultInDestination: destination, withCompletion: completion);
            })
        }
        
        globalDataTask?.resume()
    }
    
    
    private class func convertToIpInfoData(data: NSData?) -> IPInfo?
    {
        guard let jsonData = data else {return nil;}
        
        do
        {
           if let jsonObject = try NSJSONSerialization.JSONObjectWithData(jsonData, options: .AllowFragments) as? NSDictionary
           {
             return IPInfo(hostname: jsonObject["hostname"] as? String,
                           city: jsonObject["city"] as? String,
                           country: jsonObject["country"] as? String,
                           locationCoordinates: jsonObject["loc"] as? String,
                           organization: jsonObject["org"] as? String,
                           postalCode: jsonObject["postal"] as? String,
                           region: jsonObject["region"] as? String);
            }
            return nil
        }
        catch _
        {
            return nil;
        }
        
    }
}
