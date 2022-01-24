//
//  FavoritesViewController.swift
//  Color+
//
//  Created by Liran on 14/11/2021.
//

import UIKit
import Foundation

class FavoritesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate{
    
    var favPalettes:[[[CGFloat]]] = []
    
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var favView: UITableView!
    var button_tag:Int = -1
    var t_count:Int = 0
    var lastCell: StackViewCell = StackViewCell()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favPalettes.count
    }
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == UITableViewCell.EditingStyle.delete {
            favPalettes.remove(at: indexPath.row)
            UserDefaults.standard.set(favPalettes, forKey: "Favorites")
            DispatchQueue.main.async{
                self.favView.reloadData()
            }
        }
    }
    
    ///Draws table cells programmatically
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "favCell")
        let cell = tableView.dequeueReusableCell(withIdentifier: "StackViewCell", for: indexPath) as! StackViewCell
        if !cell.cellExists {
            if !favPalettes.isEmpty {
                cell.favPalettes = favPalettes[indexPath.row]
                cell.drawPalette()
                cell.open.tag = t_count
                cell.openView.tag = t_count
                cell.open.addTarget(self, action: #selector(cellOpened(sender:)), for: .touchUpInside)
                t_count += 1
                cell.cellExists = true
                let centerWidth = cell.frame.width / 7
                let centerHeight = cell.frame.height / 2
                var circleCenter = CGPoint(x: centerWidth, y: centerHeight)

                for i in 1...6 {

                    circleCenter = CGPoint(x: 8 + centerWidth * CGFloat(i) - 5, y: centerHeight)

                    let circlePath = UIBezierPath(arcCenter: circleCenter, radius: CGFloat(14), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)

                    let shapeLayer = CAShapeLayer()
                    shapeLayer.path = circlePath.cgPath
//                    circlePath.fill()

                    // Change the fill color
                    shapeLayer.fillColor = UIColor(red: CGFloat(favPalettes[indexPath.row][i-1][0]), green: CGFloat(favPalettes[indexPath.row][i-1][1]), blue: CGFloat(favPalettes[indexPath.row][i-1][2]), alpha: 1).cgColor
                    print(favPalettes[indexPath.row][i-1][0])
                    print(favPalettes[indexPath.row][i-1][1])
                    print(favPalettes[indexPath.row][i-1][2])

                    shapeLayer.strokeColor = UIColor.black.cgColor
                    shapeLayer.lineWidth = 1
                    shapeLayer.masksToBounds = false;
                    shapeLayer.shadowOffset = CGSize.zero;
                    shapeLayer.shadowRadius = 3;
                    shapeLayer.shadowOpacity = 1;
                    circlePath.fill()

                    cell.layer.addSublayer(shapeLayer)
                }
            }
        }
        
        return cell
    }
    
    ///Expands cell on click
    @objc func cellOpened(sender:UIButton) {
        self.favView.beginUpdates()
        
        let previousCellTag = button_tag
        
        if lastCell.cellExists {
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
            
            if sender.tag == button_tag {
                button_tag = -1
                lastCell = StackViewCell()
            }
        }
        
        if sender.tag != previousCellTag {
            button_tag = sender.tag
            
            lastCell = favView.cellForRow(at: IndexPath(row: button_tag, section: 0)) as! StackViewCell
            self.lastCell.animate(duration: 0.2, c: {
                self.view.layoutIfNeeded()
            })
        
        }
        self.favView.endUpdates()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        let UserDefault = UserDefaults.standard
        let favorites = UserDefault.array(forKey: "Favorites") as? [[[CGFloat]]]
        self.favPalettes = favorites ?? []
        DispatchQueue.main.async{
            self.favView.reloadData()
        }
    }
    
    
    
    ///Resets favPalettes (Userdefaults = 0, reloadData)
    @IBAction func clearClicked(_ sender: Any) {
        favPalettes = []
        UserDefaults.standard.set([], forKey: "Favorites")
        DispatchQueue.main.async{
            self.favView.reloadData()
        }
        
    }
    
    ///Updates tableview when screen called.
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareTableView()
        favView.reloadData()
        favPalettes = []
        favView.register(UINib(nibName: "StackViewCell", bundle: nil), forCellReuseIdentifier: "StackViewCell")
        favView.delegate = self
        favView.dataSource = self
        favView.allowsSelection = false
        //favView.separatorStyle = .none
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
            if indexPath.row == button_tag {
                return 320
            } else {
                return 60
            }
        }
    
    ///Delegates data & delegation to self.
    func prepareTableView() {
        favView.dataSource = self
        favView.delegate = self
    }
}

