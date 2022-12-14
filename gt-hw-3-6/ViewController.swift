//
//  ViewController.swift
//  gt-hw-3-6
//
//  Created by ake11a on 2022-10-17.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var productsCollectionView: UICollectionView!
    //@IBOutlet weak var totalLabel: UILabel!
    //@IBOutlet weak var cartImageView: UIImageView!
    @IBOutlet weak var productSearchBar: UISearchBar!
    
    var products =
    [Product(name: "Apple", picture: UIImage(named: "Apple")!, price: 45.50),
     Product(name: "Pear", picture: UIImage(named: "Pear")!, price: 63.50),
     Product(name: "Plum", picture: UIImage(named: "Plum")!, price: 74.50),
     Product(name: "Apricot", picture: UIImage(named: "Apricot")!, price: 98.50),
     Product(name: "Tomato", picture: UIImage(named: "Tomato")!, price: 33.50),
     Product(name: "Cucumber", picture: UIImage(named: "Cucumber")!, price: 28.50)]
    
    //    var total = Array(repeating: 0, count: products.count)
    //    var total = Array(repeating: 0, count: 6)
    //    var total = [Int:Int]()
    var cartProducts = [Product]()
    var filteredProducts = [Product]()
    
    var totalSum = 0
    
    var cartButton = UIButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        filteredProducts = products
        
        setupCollectionView()
        
        cartButton.backgroundColor = .green
        cartButton.setTitle("0", for: .normal)
        cartButton.titleLabel?.font = .boldSystemFont(ofSize: 40)
        
        cartButton.addTarget(self, action: #selector(goToCart), for: .touchUpInside)
        cartButton.layer.cornerRadius = (view.frame.width / 4) / 2
        
        view.addSubview(cartButton)
        cartButton.translatesAutoresizingMaskIntoConstraints = false
        cartButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        cartButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -40).isActive = true
        cartButton.widthAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
        cartButton.heightAnchor.constraint(equalToConstant: view.frame.width / 4).isActive = true
    }
    
    func setupCollectionView() {
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        //layout.scrollDirection = .horizontal
        productsCollectionView.collectionViewLayout = layout
        
        productsCollectionView.showsHorizontalScrollIndicator = false
        
        //        imageCollectionView.delegate = self
        //        imageCollectionView.dataSource = self
    }
    
    @objc func goToCart() {
        let cartScreen = SecondViewController()
        
        cartScreen.cartProducts = cartProducts
        
        present(cartScreen, animated: false)
        
    }
}

extension ViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return filteredProducts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "product_cell", for: indexPath) as! ProductCell
        
        cell.nameLabel.text = filteredProducts[indexPath.row].name
        cell.pictureImageView.image = filteredProducts[indexPath.row].picture
        cell.priceLabel.text = "\(filteredProducts[indexPath.row].price) ??????"
        
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: 175, height: 175)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let alertController = UIAlertController(title: "Question", message: "How much do you want to add in cart?", preferredStyle: .alert)
        
        var textField = UITextField()
        
        alertController.addTextField { text in
            textField = text
        }
        
        let actionOk = UIAlertAction(title: "Ok", style: .cancel) { [self] action in
            //print(self.filteredNames[indexPath.row])
            
            let inputText = textField.text!
            
            if let amount = Int(inputText) {
                var counter = 0
                
                while counter < amount {
                    self.cartProducts.append(self.filteredProducts[indexPath.row])
                    
                    counter += 1
                }
                
                self.totalSum += amount
                
                self.cartButton.setTitle("\(totalSum)", for: .normal)
            }
        }
        
        let actionCancel = UIAlertAction(title: "Cancel", style: .destructive) { action in
            ()
        }
        
        alertController.addAction(actionOk)
        alertController.addAction(actionCancel)
        
        present(alertController, animated: true, completion: nil)

    }
}

extension ViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filteredProducts = []
        
        if searchText == "" {
            filteredProducts = products
        }
        
        for product in products {
            if product.name.uppercased().contains(searchText.uppercased()) {
                filteredProducts.append(product)
            }
        }
        
        productsCollectionView.reloadData()
    }
}

class SecondViewController: UIViewController {
    
    var cartTableView = UITableView()
    var totalLabel = UILabel()
    
    var cartProducts = [Product]()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        cartTableView.register(UITableViewCell.self, forCellReuseIdentifier: "product_cell")
        view.addSubview(cartTableView)
        
        cartTableView.translatesAutoresizingMaskIntoConstraints = false
        cartTableView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        cartTableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        cartTableView.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        cartTableView.heightAnchor.constraint(equalToConstant: view.frame.height - 100).isActive = true
        
        //cartTableView.delegate = self
        cartTableView.dataSource = self
        
        view.addSubview(totalLabel)
        totalLabel.translatesAutoresizingMaskIntoConstraints = false
        totalLabel.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        totalLabel.topAnchor.constraint(equalTo: view.bottomAnchor, constant: -200).isActive = true
        totalLabel.widthAnchor.constraint(equalToConstant: view.frame.width).isActive = true
        totalLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        
        totalLabel.font = .systemFont(ofSize: 20)
        
        var totalSum = 0.0
        
        for cartProduct in cartProducts {
            totalSum += cartProduct.price
        }
        totalLabel.text = "Total: \(cartProducts.count). Sum: \(totalSum)"
    }
}

extension SecondViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cartProducts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = UITableViewCell(style: .default, reuseIdentifier: "product_cell")
        
        cell.imageView?.image = cartProducts[indexPath.row].picture
        
        cell.imageView?.translatesAutoresizingMaskIntoConstraints = false
        cell.imageView?.leftAnchor.constraint(equalTo: cell.leftAnchor, constant: 0).isActive = true
        cell.imageView?.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
        cell.imageView?.widthAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        cell.imageView?.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        
        cell.textLabel?.text = "\(cartProducts[indexPath.row].name) \(cartProducts[indexPath.row].price)"
        
        cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
        cell.textLabel?.leftAnchor.constraint(equalTo: cell.imageView!.rightAnchor, constant: 0).isActive = true
        cell.textLabel?.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
        cell.textLabel?.topAnchor.constraint(equalTo: cell.topAnchor, constant: 0).isActive = true
        cell.textLabel?.heightAnchor.constraint(equalTo: cell.heightAnchor).isActive = true
        
        return cell
    }
}

extension SecondViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 300
    }
}


