//
//  RestaurantDetailViewController.swift
//  Chapter9
//
//  Created by Nazih Al Tajar on 22/03/2019.
//  Copyright © 2019 sss. All rights reserved.
//

import UIKit

class RestaurantDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
     //var restaurante : [IRestaurantInfo] = []

    @IBOutlet private var restaurantTableView: UITableView!
    @IBOutlet private var restaurantHeaderView: RestaurantDetailHeaderView!

    var restaurantDetail: Restaurant?

    override func viewDidLoad() {
        super.viewDidLoad()

        restaurantTableView.delegate = self
        restaurantTableView.dataSource = self

        setupInfoCell()
        
       // createRestaurantInfoList()
    }

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {

        switch indexPath.row {

        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell

            cell.iconImageView.image = UIImage(named: "phone")
            cell.shortTextLabel.text = restaurantDetail?.phone
            cell.selectionStyle = .none

            return cell

        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
            cell.iconImageView.image = UIImage(named: "map")
            cell.shortTextLabel.text = restaurantDetail?.location
            cell.selectionStyle = .none

            return cell

        case 2:

            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailTextCell.self), for: indexPath) as! RestaurantDetailTextCell
            cell.descriptionLabel.text = restaurantDetail?.description
            cell.selectionStyle = .none

            return cell

        default:
            fatalError("Failed to instantiate the table view cell for detail view controller")
        }
        
//
//        if(restaurante[indexPath.row] is RestaurantInfoWithIcon){
//            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RestaurantDetailIconTextCell.self), for: indexPath) as! RestaurantDetailIconTextCell
//
//            cell.iconImageView.image = UIImage(named: "phone")
//            cell.shortTextLabel.text = restaurantDetail?.phone
//            cell.selectionStyle = .none
//
//            return cell
//        }

        
        
    
        
    }

    private func setupInfoCell() {
        guard let restaurantDetail = restaurantDetail else { return }
        restaurantHeaderView.setupHeaderView(restaurantDetails: restaurantDetail)
    }
    
    
//    private func createRestaurantInfoList(){
//       restaurante = [IRestaurantInfo]()
//        guard let restaurantDetail = restaurantDetail else { return }
//        RestaurantInfoWithIcon(Text: "phone", ImageName: restaurantDetail.phone)
//        RestaurantInfoWithIcon(Text: "map", ImageName: restaurantDetail.location)
//        RestaurantInfo(Text: restaurantDetail.description)
//    }
}
