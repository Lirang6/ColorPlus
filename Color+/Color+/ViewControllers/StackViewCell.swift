//
//  StackViewCell.swift
//  Color+
//
//  Created by Liran on 04/12/2021.
//

import UIKit
import Foundation

class StackViewCell: UITableViewCell {
    
    var cellExists:Bool = false

    @IBOutlet var openView: UIView!
    var favPalettes:[[CGFloat]] = []
    @IBOutlet var hexValueLabel: UILabel!
    @IBOutlet var copyHexButton: UIButton!
    var gradientLayer = CAGradientLayer()
    @IBOutlet var backgroundView2: UIView!
    
    @IBOutlet var stuffView: UIView! {
        didSet {
            stuffView?.isHidden = true
            stuffView?.alpha = 0
            copyHexButton.isEnabled = false
        }
    }
    
    @IBOutlet var open: UIButton!

    
//    @IBOutlet var salary: UILabel!
//    
//    @IBOutlet var textView: UITextView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func animate(duration:Double, c: @escaping () -> Void) {
        UIView.animateKeyframes(withDuration: duration, delay: 0, options: .calculationModePaced, animations: {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: duration, animations: {
                
                self.stuffView.isHidden = !self.stuffView.isHidden
                if self.stuffView.alpha == 1 {
                    self.stuffView.alpha = 0.5
                } else {
                    self.stuffView.alpha = 1
                }
                
            })
        }, completion: {  (finished: Bool) in
            print("animation complete")
            c()
        })
    }
    
    func drawPalette(){
        gradientLayer.frame = stuffView.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.9873165488, green: 0.7010524869, blue: 0.7917805314, alpha: 1).cgColor, #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        backgroundView2.layer.addSublayer(gradientLayer)
        
        let centerWidth = stuffView.frame.width / 4
        let height = CGFloat(77)
        var circleCenter = CGPoint(x: centerWidth, y: height)
        
        for i in 1...6 {
            if i < 4 {
            circleCenter = CGPoint(x: centerWidth * CGFloat(i), y: height)
            } else {
                circleCenter = CGPoint(x: centerWidth * CGFloat(i - 3), y: height + 80)
            }
            
            let circlePath = UIBezierPath(arcCenter: circleCenter, radius: CGFloat(23), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
                
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            circlePath.fill()
                
            // Change the fill color

            shapeLayer.fillColor = UIColor(red: CGFloat(favPalettes[i-1][0]), green: CGFloat(favPalettes[i-1][1]), blue: CGFloat(favPalettes[i-1][2]), alpha: 1).cgColor
            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.masksToBounds = false;
            shapeLayer.shadowOffset = CGSize.zero;
            shapeLayer.shadowRadius = 5;
            shapeLayer.shadowOpacity = 0.8;
                
            stuffView.layer.addSublayer(shapeLayer)
        }
        
        
    
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let touchLocation = touch.location(in: stuffView)

                for sublayer in stuffView.layer.sublayers ?? [] {

                    if let shapeLayer = sublayer as? CAShapeLayer {
                        //Ensures shapeLayer
                        if shapeLayer.path != nil {
                            if shapeLayer.path!.contains(touchLocation) {
                                shapeLayer.lineWidth = 4
                                hexValueLabel.text = UIColor(cgColor: shapeLayer.fillColor ?? 0 as! CGColor).toHexString()
                                copyHexButton.isEnabled = true
                            } else {
                                shapeLayer.lineWidth = 1.5
                            }
                        }
                    }

                }
            }
    }
    
        @IBAction func copyHexValue(_ sender: Any) {
            UIPasteboard.general.string = hexValueLabel.text
            let alert = UIAlertController(title: "Copied", message: "Hex value copied to board", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        }
}
