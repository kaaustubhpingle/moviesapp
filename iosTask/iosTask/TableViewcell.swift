//
//  TableViewcell.swift
//  iosTask
//
//  Created by kaustubh.pingle on 27/08/24.
//

import UIKit

var flag = 0
protocol MovieTableViewCellDelegate: AnyObject {
    func didTapFavoriteButton(on cell: MovieTableViewCell)
}

class MovieTableViewCell: UITableViewCell {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var ButtonFav: UIButton!
    
    weak var delegate: MovieTableViewCellDelegate?
    @IBAction func favButtonClicked(_ sender: Any) {
        delegate?.didTapFavoriteButton(on: self)
        if(flag == 0){
            ButtonFav.setImage(UIImage(named: "unfav"), for: .normal)
        }else{
            ButtonFav.setImage(UIImage(named: "fav"), for: .normal)
        }
        flag = 1
    }
    
    
}
