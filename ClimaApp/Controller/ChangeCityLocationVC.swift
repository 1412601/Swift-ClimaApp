//
//  ChangeCityLocationVC.swift
//  ClimaApp
//
//  Created by baotuan on 10/31/17.
//  Copyright © 2017 baotuan. All rights reserved.
//

import UIKit

protocol ChangeCityDelegate {
    func userChangeANewCity(city: String)
}

class ChangeCityLocationVC: UIViewController {
    
    //MARK: Delegate
    var delegate: ChangeCityDelegate?
    
    //MARK: Local variables
    @IBOutlet weak var locationtextField: UITextField!
    
    //MARK: Model
    
    //MARK: UI Action
    
    @IBAction func backPress(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func getWeatherbtn(_ sender: Any) {
        delegate?.userChangeANewCity(city: locationtextField.text!)
        self.dismiss(animated: true, completion: nil)
    }
    //MARK: Lifecycle methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

}
