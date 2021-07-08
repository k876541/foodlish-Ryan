//
//  ViewController.swift
//  foodlish-Ryan
//
//  Created by Ryan Chang on 2021/7/6.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var randomButton: UIButton!
    @IBOutlet weak var foodNumberTextField: UITextField!
    @IBOutlet weak var goButton: UIButton!
    @IBOutlet weak var foodImageView: UIImageView!
    @IBOutlet weak var loadingView: UIActivityIndicatorView!
    
    var foods = [Food]()
    var numbers = Int()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchimage()
        
        navigationItem.title = "FaSwift Interview Project"
        let barButtonItem = UIBarButtonItem(title: "", style: .plain , target: self, action: nil)
        navigationItem.backBarButtonItem = barButtonItem
        let image = UIImage(named: "backArrow")
        let barAppearance = UINavigationBarAppearance()
        barAppearance.setBackIndicatorImage(image,transitionMaskImage: image)
        navigationController?.navigationBar.standardAppearance = barAppearance

        // Do any additional setup after loading the view.
    }
    
    
    
    func fetchimage(){
            loadingView.startAnimating()
            foodImageView.isHidden = true
            print("fetchData")
            let str = "https://foodish-api.herokuapp.com/api/" //圖片網址
            if let url = URL(string: str){
                URLSession.shared.dataTask(with: url) { data, response, error in
                    let decoder = JSONDecoder()
                    if let data = data {
                        do {
                            let fo = try decoder.decode(Food.self, from: data)
                            self.foods = [fo]
                            let url = self.foods.first?.image
                            DispatchQueue.main.async {
                                URLSession.shared.dataTask(with: url!){ (data , response ,error) in
                                    if let data = data {
                                        DispatchQueue.main.async {[self] in
                                            foodImageView.image = UIImage(data: data)
                                            foodImageView.isHidden = false
                                            loadingView.stopAnimating()
                                        }
                                    }
                                }.resume()
                            }
                        } catch  {
                            print("error")
                        }
                    }
                }.resume()
            }
    }

    
    @IBSegueAction func settingNumber(_ coder: NSCoder) -> FoodishCollectionViewController? {
        let controller = FoodishCollectionViewController(coder: coder)
        controller?.foodNumber = numbers
        return controller
        
    }
    
    
    
    @IBAction func random(_ sender: UIButton) {
        let a = Int.random(in: 1 ... 573)
        
        numbers = a
        performSegue(withIdentifier: "setting", sender: nil)
    }
    
    
    
    @IBAction func go(_ sender: UIButton) {
        if let number = foodNumberTextField.text,
           let a = Int(number) {
            if a >= 1 && a <= 573 {
                numbers = a
                performSegue(withIdentifier: "setting", sender: nil)
            }else {
                foodNumberTextField.placeholder = "範圍在1~573"
            }
        }
        
        
        
        
    }
    
    
    
    
    

}

