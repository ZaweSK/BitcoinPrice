//
//  ViewController.swift
//  bitcoin
//
//  Created by Peter on 18/02/2019.
//  Copyright © 2019 Excellence. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
   
    var currencyArray = ["AUD","BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    let currencySymbols = ["$", "R$", "$", "¥", "€", "£", "$", "Rp", "₪", "₹", "¥", "$", "kr", "$", "zł", "lei", "₽", "kr", "$", "$", "R"]
    
    var pickedCurrency : String?
    
    let URL = "https://apiv2.bitcoinaverage.com/indices/global/ticker/BTC"
    
    @IBOutlet var priceLabel: UILabel!
    @IBOutlet var picker: UIPickerView!
    
    override func viewDidLoad() {
        picker.delegate = self
        picker.dataSource = self
    }
    
    
    
    // MARK: - Picker View Data Source and Delegate methods
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return currencyArray.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return currencyArray[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let url = URL + currencyArray[row]
        pickedCurrency = currencySymbols[row]
        getData(fromAddress: url)
    }
    
    
    // MARK: - Data Fetching
    
    private func getData(fromAddress url: String){
        Alamofire.request(url, method: .get).responseJSON { (response) in
            if response.result.isSuccess{
                let json: JSON = JSON(response.result.value!)
                self.parseJSON(json)
            }else{
                print("request failed")
            }
        }
    }
    
    //MARK: - Data Parsing
    
    private func parseJSON(_ json: JSON){
        if let bitcoinPrice = json["ask"].double {
            
            updateUI(with: bitcoinPrice)
        }
    }
    
    private func updateUI(with price: Double) {
        
        let currency = pickedCurrency ?? ""
        
        priceLabel.text = "\(price)\(currency)"
    }
    

  
}

