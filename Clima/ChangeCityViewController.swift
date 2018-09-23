import UIKit

protocol userEnteredCityDelegate{
    func userEnteredCity(city :String)
}



class ChangeCityViewController: UIViewController {
    //delegate to switch back to previous screen
    var delegate : userEnteredCityDelegate?

    
    //This is the pre-linked IBOutlets to the text field:
    @IBOutlet weak var changeCityTextField: UITextField!

    
    //This is the IBAction that gets called when the user taps on the "Get Weather" button:
    @IBAction func getWeatherPressed(_ sender: AnyObject) {
        
        
        let cityUser = changeCityTextField.text!
        delegate?.userEnteredCity(city: cityUser)
        self.dismiss(animated: true, completion: nil)
        
    
        
    }
    
    

    //This is the IBAction that gets called when the user taps the back button. It dismisses the ChangeCityViewController.
    @IBAction func backButtonPressed(_ sender: AnyObject) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
