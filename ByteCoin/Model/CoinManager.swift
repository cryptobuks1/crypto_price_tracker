//
//  CoinManager.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import Foundation

//Delegate method 1: create protocol
// we are only concerned w/ price & currency variables
protocol CoinManagerDelegate {
    func didUpdateCurrency (price: String, currency: String)
    func didFailWithError(error: Error)
}

struct CoinManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate/BTC"
    let apiKey = "DBE81404-334E-49C8-A655-4EF414D22448"
    
    //Delegate method step 3: Initialize delegate variable in CoinManager (CM is facilitator/handler) w/i struct
    var delegate: CoinManagerDelegate?
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    //passing currency selected from VC here when called in pickerView function
    //'for' is external parameter name, 'currency' is internal parameter name
    func getCoinPrice(for currency: String){
        
        //the following 4 steps complete API data retrieval using urlString
        // add returned currency from UIpicker into API string
        let urlString = "\(baseURL)/\(currency)?apikey=\(apiKey)"
          
        //1. Create a url
        if let url = URL(string: urlString) {
        
        //2. Create URL session
            let session = URLSession(configuration: .default)

        //3. Give URLSession a task
        //simplify using completion handler closure
            let task = session.dataTask(with: url) {(data, response, error) in
             
                if error != nil {
                //If data can’t be decoded, b/c JSON doesn’t match or issue with coinData structure setup --> catch error & pass error to delegate
                self.delegate?.didFailWithError(error: error!)
                return
                }
                
                if let safeData = data {
                    //let dataString = String(data: safeData, encoding: .utf8)
                    
                    // pass safeData in to "data" parameter
                    // coinData assumes value of "lastPrice" via parseJSON
                    if let coinData = self.parseJSON(safeData){
                        
                        //create priceString double to represent string
                        let priceString = String(format: "%.2f", coinData)
                        //Delegate method step 4: create delegate method to pass data from parsed JSON to receiver of delegate (viewcontroller)
                        self.delegate?.didUpdateCurrency(price: priceString, currency: currency)
                }
            }
                
        }
                     
        //4. Start the task to fetch data
            task.resume()
        }
    }
    

// this will decode CoinData structure & return a double value for price
//declare function with parameter name "data" & type Data, no external parameter name
func parseJSON(_ data: Data) -> Double? {
    
    //create a decoder (standard object)
    let decoder = JSONDecoder()
    
    // wrap in do block to try running function
    do{
        // Decode output in CoinData structure - capture in constant "decodedData"
        // decodedData assumes value of JSON info
        let decodedData = try decoder.decode(CoinData.self, from: data)
                
        //grab last rate as double - declared as double in CoinData
        //rate is the only value we are interested from JSON
        let lastPrice = decodedData.rate
        
        //return last retreived Price as double out of function
        return lastPrice
        
    //Use catch block to catch error if does occur.
    } catch {
        print(error)
         return nil
    }
    
}

}


