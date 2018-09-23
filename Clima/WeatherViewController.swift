import UIKit
import CoreLocation
import SwiftyJSON
import Alamofire

class WeatherViewController: UIViewController, CLLocationManagerDelegate, userEnteredCityDelegate {
    
    //Constants
    let WEATHER_URL = "http://api.openweathermap.org/data/2.5/weather"
    let APP_ID = "1a908f364bd8aafefb264ead5acf23a3"
    
    let weatherObject = WeatherDataModel()      //weather data instance
    let manageLocation = CLLocationManager()    //location manager instance
    
    //Pre-linked IBOutlets
    @IBOutlet weak var weatherIcon: UIImageView!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var temperatureLabel: UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        manageLocation.delegate = self
        manageLocation.desiredAccuracy = kCLLocationAccuracyHundredMeters
        manageLocation.requestWhenInUseAuthorization()
        manageLocation.startUpdatingLocation()
        
        
        
    }
    
    //MARK: - Networking
    
    //getting weather data
    func getWeatherData(url: String, parameters : [String:String]){
        
        Alamofire.request(url, method: .get, parameters: parameters).responseJSON{
            response in
            if response.result.isSuccess{
                print("got response")
                let data :JSON = JSON(response.result.value!)
                print(data)
                self.updateData(JSON: data)
                
            }else{
                print(response.result.error!)
                self.cityLabel.text = "Connection Issues"
            }
        }
    }
//MARK: - JSON Parsing
    
   
    func updateData(JSON:JSON){
        
        if let temperature = JSON["main"]["temp"].double{
            
            weatherObject.temp = Int(temperature - 273.15)
            weatherObject.wCond = (JSON["weather"][0]["id"]).intValue
            weatherObject.city = JSON["name"].stringValue
            weatherObject.weatherIconName = weatherObject.updateWeatherIcon(wCond: weatherObject.wCond)
            
            updateUIWithData()
            
            
        }else{
            cityLabel.text="There Was A Network Issue"
        }
    }
    
    
    //MARK: - UI Updates
    /***************************************************************/
    
    //entering data into labels
    func updateUIWithData(){
        temperatureLabel.text = "\(weatherObject.temp)"
        weatherIcon.image = UIImage(named: weatherObject.weatherIconName)
        cityLabel.text = weatherObject.city
        
        
        
    }
    //MARK: - Location Manager Delegate Methods
    /***************************************************************/
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations[locations.count-1]
        if location.horizontalAccuracy>0{
            manageLocation.stopUpdatingLocation()
            let lat = String(location.coordinate.latitude)
            let lon = String(location.coordinate.longitude)
            let params : [String : String] = ["Latitute" : lat, "Longitude" : lon, "App ID" : APP_ID]
            
            getWeatherData(url: WEATHER_URL, parameters: params)
        }
    }
    
    
    //if doesn't grab location
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print(error)
        cityLabel.text = "Location Unavailable"
    }
    
    

    
    //MARK: - Change City Delegate methods
    /***************************************************************/

    func userEnteredCity(city: String) {
        let allCities : [ String : String] = ["q" : city, "app id" : APP_ID]
        
        getWeatherData(url: WEATHER_URL, parameters: allCities)
    }
    
    //segue to 2nd screen
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "changeCityName"{
            let destinationVC = segue.destination as! ChangeCityViewController
            destinationVC.delegate = self
        }
    }
    

}
