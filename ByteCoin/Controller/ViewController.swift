//
//  ViewController.swift
//  ByteCoin
//
//  Created by Angela Yu on 11/09/2019.
//  Copyright © 2019 The App Brewery. All rights reserved.
//

import UIKit

//Delegate method step 2: allow VC to assume CoinManagerDelegate in declaration
class ViewController: UIViewController {

    @IBOutlet weak var bitcoinLabel: UILabel!
    @IBOutlet weak var currencyLabel: UILabel!
    @IBOutlet weak var currencyPicker: UIPickerView!
    
    //connect VC class to CoinManager class
    // change "let" to "var" to modify properties
    var coinManager = CoinManager()
       
       override func viewDidLoad() {
           super.viewDidLoad()
           
           //Delegate method step 6: Set receiving class (ViewController) as the delegate
           coinManager.delegate = self
           //sets data source as VC class
           currencyPicker.dataSource = self
           //sets VC class as UIPickerView delegate
           currencyPicker.delegate = self
       }
}
    
    //MARK: - UIPickerView
    
    extension ViewController: UIPickerViewDataSource, UIPickerViewDelegate {
    
    //This determines the number of columns of data shown in the picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    //tap into array in coin manager struct via "struct"."array"."function"
    //single value signified by "->"
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return coinManager.currencyArray.count
    }
    
    //will render the text (currency title) on each row
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //tap into array in struct as 'row' is predefined parameter
        return coinManager.currencyArray[row]
    }
    
    //selects value in 'row' when selector changes position
    //Pass selected currency back to CoinManager to prep use for API
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //create constant representing currency selected
        let currency = coinManager.currencyArray[row]
        //call getCoinPrice function passing in selected currency to API on coinmanager
        coinManager.getCoinPrice(for: currency)
    }
}
    
      //MARK: - CoinManagerDelegate
    
    extension ViewController: CoinManagerDelegate {
        
    //Delegate method step 5: Create function in receiving class (ViewController) to receive and use API data

    func didUpdateCurrency (price: String, currency: String) {
        print(price, "hi")
        //Use DispatchQueue async to update UI while networking & data retrieval happens separate thread
        DispatchQueue.main.async {
            //changes which currency shown on UI
            self.currencyLabel.text = currency
            //changes price of bitcoin on UI
            self.bitcoinLabel.text = price
        }
    }
    
    //Delegate error method allows errors passed from Manager to be received in VC
    func didFailWithError(error: Error) {
        //communicate error in terminal
        print(error)
    }

}


