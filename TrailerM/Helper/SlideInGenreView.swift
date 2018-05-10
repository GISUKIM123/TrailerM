//
//  SlideInGenreView.swift
//  TrailerM
//
//  Created by gisu kim on 2018-05-07.
//  Copyright © 2018 gisu kim. All rights reserved.
//

import UIKit

extension GenreView: UITableViewDataSource, UITableViewDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return genreController?.genres?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: genreListCell, for: indexPath)
        cell.textLabel?.text = genreController?.genres![indexPath.row].name
        cell.isUserInteractionEnabled = true
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleGenreSelected)))
        cell.tag = indexPath.row
        return cell
    }
    
    func tableView(_ tableView: UITableView, didHighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.backgroundColor = .lightGray
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .white
    }
    func tableView(_ tableView: UITableView, didUnhighlightRowAt indexPath: IndexPath) {
        tableView.cellForRow(at: indexPath)?.backgroundColor = .white
        tableView.cellForRow(at: indexPath)?.textLabel?.textColor = .black
    }
    
    @objc func handleGenreSelected(gesture: UITapGestureRecognizer) {
        if let cell = gesture.view as? UITableViewCell {
            let genre = genreController?.genres![cell.tag]
            genreController?.handleGenreSelected(genre: genre!)
        }
    }
}

class GenreView: UIView {
    let genreListCell = "genreListCell"
    
    var genreController : GenreController?
    
    let genreLabel : UILabel = {
        let label = UILabel()
        label.text = "Genres"
        label.textAlignment = .center
        label.backgroundColor = .white
        label.textColor = .orange
        label.font = UIFont(name: "AmericanTypewriter-Bold", size: 22)
        
        return label
    }()
    
    lazy var genreCollectionView : UITableView = {
        
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: genreListCell)
        tv.separatorStyle = .none
        
        return tv
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        genreCollectionView.dataSource = self
        genreCollectionView.delegate = self
        
        addSubview(genreLabel)
        genreLabel.translatesAutoresizingMaskIntoConstraints = false
        [
            genreLabel.topAnchor.constraint(equalTo: topAnchor),
            genreLabel.leftAnchor.constraint(equalTo: leftAnchor),
            genreLabel.widthAnchor.constraint(equalTo: widthAnchor),
            genreLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.1)
        ].forEach{ $0.isActive = true }
        
        addSubview(genreCollectionView)
        genreCollectionView.translatesAutoresizingMaskIntoConstraints = false
        [
            genreCollectionView.topAnchor.constraint(equalTo: genreLabel.bottomAnchor),
            genreCollectionView.leftAnchor.constraint(equalTo: leftAnchor),
            genreCollectionView.widthAnchor.constraint(equalTo: widthAnchor),
            genreCollectionView.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.9)
            ].forEach{ $0.isActive = true }
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

class SlideInGenreView: NSObject {
    var blackView   : UIView?
    var genreView   : GenreView?
    
    weak var genreController : GenreController?
    func shoowSlider() {
        if let keyWindow = UIApplication.shared.keyWindow {
            blackView?.frame = keyWindow.frame
            blackView?.backgroundColor = UIColor.black.withAlphaComponent(0.5)
            
            genreView = GenreView()
            genreView?.genreController = genreController
            
            genreView?.frame = CGRect(x: -(keyWindow.frame.width), y: navHeight!, width: keyWindow.frame.width * 0.7, height: keyWindow.frame.height - navHeight!)
            blackView?.addSubview(genreView!)
            
            UIView.animate(withDuration: 0.3, delay: 0.2, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.genreView?.frame = CGRect(x: 0, y: navHeight!, width: keyWindow.frame.width * 0.7, height: keyWindow.frame.height - navHeight!)
            }, completion: nil)
            
            keyWindow.addSubview(blackView!)
        }
    }
}
