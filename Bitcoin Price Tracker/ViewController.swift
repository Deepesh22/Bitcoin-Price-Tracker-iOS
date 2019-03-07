//
//  ViewController.swift
//  Bitcoin Price Tracker
//
//  Created by Deepesh on 07/03/19.
//  Copyright © 2019 deepesh deshmukh. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    // URL and API
    let baseURL : String = "https://min-api.cryptocompare.com/data/price?fsym=BTC&tsyms="
    let API_Key = "f9dbdc3a6ea58162cfb75547960f9032e6679444b4363682597d98f9089bee5c"
    
    let pickerViewData = ["None", "INR", "AUD", "EUR", "USD", "GBP", "CAD", "JPY"]
    
    var priceData : JSON = []
    var finalURL : String = ""
    
    // linked IBOutlets
    @IBOutlet weak var currencyPicker: UIPickerView!
    @IBOutlet weak var bitcoinPriceLabel: UILabel!
    
    @IBAction func refreshData(_ sender: UIButton) {
        getPriceData(url: finalURL)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.finalURL = createFinalURL()
        
        // setting delegate of UIPickerViewDelegate, UIPickerViewDataSource
        currencyPicker.delegate = self
        currencyPicker.dataSource = self
        
        getPriceData(url: finalURL)
    }
    
    //MARK: - Creating final URL
    /*********************************************************************************/
    // We can request prices for all the currencies in one request, hence will not be required to make calls again and again, Hence we create a final url which can request data for every currency.
    func createFinalURL() -> String{
        let joinedString = pickerViewData.joined(separator : ",")
        let finalURL = baseURL + joinedString + "&api_key=" + API_Key
        return finalURL
    }
    

    //MARK: - Setting up picker view
    /*********************************************************************************/
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerViewData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerViewData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let selectedCurrency = pickerViewData[row]
        if selectedCurrency == "None"{
            bitcoinPriceLabel.text = "Price"
        }
        else{
            updatePriceLabel(currency : selectedCurrency)
        }
    }
    
    //MARK: - Requesting Prices (making request calls)
    /*********************************************************************************/

    func getPriceData(url: String){
        Alamofire.request(url).responseJSON { response in
            if response.result.isSuccess{
                self.priceData = JSON(response.result.value!)
            }
            else{
                self.bitcoinPriceLabel.text = "Connection Issue"
            }
        }
    }
    
    
    //MARK: - Updating Prices (making request calls)
    /*********************************************************************************/
    
    func updatePriceLabel(currency : String){
        bitcoinPriceLabel.text = priceData[currency].stringValue + " " + currency
    }
    
}

