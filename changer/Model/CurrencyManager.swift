import Foundation

protocol CurrencyManagerDelegate: class {
    func didUpdateValue(rate: String, currency: String)
    func didFailWithError(error: Error)
}

struct CurrencyManager {
    
    let baseURL = "https://rest.coinapi.io/v1/exchangerate"
    let apiKey = "A1AA1735-F8E9-4144-9C71-2F24DE7AC162"
    
    let currencyArray = ["AUD", "BRL","CAD","CNY","EUR","GBP","HKD","IDR","ILS","INR","JPY","MXN","NOK","NZD","PLN","RON","RUB","SEK","SGD","USD","ZAR"]
    
    weak var delegate: CurrencyManagerDelegate?
    
    func getChangedValue(firstCurrency: String, secondCurrency: String) {
        
        let urlString = "\(baseURL)/\(firstCurrency)/\(secondCurrency)?apikey=\(apiKey)"
        
        if let url = URL(string: urlString) {
            
            let session = URLSession(configuration: .default)
            
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                
                if let safeData = data {
                    
                    if let value = self.parseJSON(safeData) {
                        
                        let valueString = String(format: "%2f", value)
                        
                        self.delegate?.didUpdateValue(rate: valueString, currency: secondCurrency)
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func parseJSON(_ data: Data) -> Double? {
        
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(CurrencyData.self, from: data)
            let lastPrice = decodedData.rate
            return lastPrice
        } catch {
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
