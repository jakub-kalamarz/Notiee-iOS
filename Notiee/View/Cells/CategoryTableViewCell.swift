//
//  CategoryTableViewCell.swift
//  Notiee
//
//  Created by Kuba on 25/06/2020.
//  Copyright © 2020 Jakub. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell {
    
    //var data:Category!
    
    private var card:UIView = {
        var view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var title:UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 25)
        label.text = "Title"
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private var icon:UIImageView = {
        let image = UIImage(systemName: "circle.fill")
        let imageView = UIImageView(image: image)
        return imageView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.selectionStyle = .none
        
        card.layer.masksToBounds = false
        card.layer.shadowOpacity = 0.33
        card.layer.shadowRadius = 4
        card.layer.shadowOffset = CGSize(width: 0, height: 0)
        card.layer.shadowColor = UIColor.black.cgColor

        card.backgroundColor = .white
        card.layer.cornerRadius = 8
        
        contentView.addSubview(card)
        card.addSubview(title)
        
        NSLayoutConstraint.activate([
            card.widthAnchor.constraint(equalTo: contentView.widthAnchor, constant: -20),
            card.heightAnchor.constraint(equalTo: contentView.heightAnchor, constant: -20),
            card.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            card.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            title.widthAnchor.constraint(equalTo: card.widthAnchor, constant: -10),
            title.heightAnchor.constraint(equalTo: card.heightAnchor),
            title.centerYAnchor.constraint(equalTo: card.centerYAnchor),
            title.centerXAnchor.constraint(equalTo: card.centerXAnchor),
            
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func highligh() {
        self.card.layer.shadowOpacity = 0.5
    }
    
    func unhighligh() {
        self.card.layer.shadowOpacity = 0.33
    }
    
    
    

}
