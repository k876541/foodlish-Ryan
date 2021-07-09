//
//  FoodishCollectionViewController.swift
//  foodlish-Ryan
//
//  Created by Ryan Chang on 2021/7/7.
//

import UIKit

private let reuseIdentifier = "\(FoodImageCollectionViewCell.self)"

class FoodishCollectionViewController: UICollectionViewController {

    var foodNumber = Int()
    var foods = [Food]()
    var foodImageArray = [URL]()
    
    var tasks = [URLSessionTask]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchData()
        
        navigationItem.title = "Ryan Chang"
        let barButtonItem = UIBarButtonItem(title: "", style: .done , target: self, action: nil)
        navigationItem.backBarButtonItem = barButtonItem
        let image = UIImage(named: "backArrow")
        let barAppearance = UINavigationBarAppearance()
        barAppearance.setBackIndicatorImage(image,transitionMaskImage: image)
        navigationController?.navigationBar.standardAppearance = barAppearance

        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Register cell classes
        //self.collectionView!.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "userInfoCollectionReusableView")

        // Do any additional setup after loading the view.
    }

    
    
    
    
    
    func fetchDatas(){
        print("fetchDatas")
        print(foodNumber,"//////")
        for _ in 1 ... foodNumber {
            fetchData()
        }
        print("for end")
    }
    
    
    
    func fetchData() {
        print("fetchData")
        let str = "https://foodish-api.herokuapp.com/api/" //圖片網址
        if let url = URL(string: str){
            for _ in 1 ... foodNumber {
                let task = URLSession.shared.dataTask(with: url) {[weak self] data, response, error in
                    let decoder = JSONDecoder()
                    if let data = data {
                        do {
                            let fo = try decoder.decode(Food.self, from: data)
                            self?.foods = [fo]
                            let imageurl = self?.foods.first?.image
                            DispatchQueue.main.async {
                                self?.foodImageArray.append(imageurl!)
                                print("reloadData")
                                self?.collectionView.reloadData()
                            }
                        } catch  {
                            print("error")
                        }
                    }
                }
                
                
                
                task.resume()
                tasks.append(task)
                print(tasks)
            }
        }
    }
    

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(true)
        for i in 0 ..< foodNumber{
            print("cancel")
            tasks[i].cancel()
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return foodImageArray.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as? FoodImageCollectionViewCell else {return UICollectionViewCell()}
    
        let item = foodImageArray[indexPath.item]
     
        print(foodImageArray.count)
        print(foodImageArray)

        //fetch Images (PhotoWall)
        URLSession.shared.dataTask(with: item) { data, response, error in
            if let data = data {
                DispatchQueue.main.async {
                    cell.foodImageView.image = UIImage(data: data)
                }
            }
        }.resume()
        return cell
    }

    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let reusableView = collectionView.dequeueReusableSupplementaryView(ofKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "\(userInfoCollectionReusableView.self)", for: indexPath) as? userInfoCollectionReusableView else { return UICollectionReusableView() }
        return reusableView
    }
    
    // MARK: UICollectionViewDelegate

    /*
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    */

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */

}
