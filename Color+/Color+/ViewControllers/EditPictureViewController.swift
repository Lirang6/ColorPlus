//
//  EditPictureViewController.swift
//  Color+
//
//  Created by Liran on 11/11/2021.
//

import UIKit
import CoreImage


class EditPictureViewController: UIViewController {

    @IBOutlet var theView: UIImageView!
    @IBOutlet var brightnessSlider: UISlider!
    @IBOutlet var contrastSlider: UISlider!
    @IBOutlet var saturationSlider: UISlider!
    
    var originalImage: UIImage?
    var thumbNailImage: UIImage?
    var originalThumbNailImage: UIImage?
    
    var originalBrightness: CGFloat = 0
    var originalContrast: CGFloat = 0
    var originalSaturation: CGFloat = 0
    let context = CIContext(options: nil)
    let filter = CIFilter(name: "CIColorControls")!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        theView = UIImageView()
    
        brightnessSlider.maximumValue = 0.2
        brightnessSlider.minimumValue = -0.2
        
        originalContrast = CGFloat(contrastSlider.value)
        originalBrightness = CGFloat(brightnessSlider.value)
        originalSaturation = CGFloat(saturationSlider.value)
        
        if let image = theView.image {
            originalImage = image
        }
        
        if current.imageBrightnessChange >= 0.2 {
            brightnessSlider.maximumValue = 0.2
            brightnessSlider.minimumValue = -0.2
            brightnessSlider.value = 0.2
        }
        
        if current.imageBrightnessChange <= -0.2 {
            brightnessSlider.maximumValue = 0.2
            brightnessSlider.minimumValue = -0.2
            brightnessSlider.value = -0.2
        }
        
        if current.imageContrastChange >= 3 {
            contrastSlider.maximumValue = 3
            contrastSlider.minimumValue = 0.25
            contrastSlider.value = 3
        }
        
        if current.imageContrastChange <= 0.25 {
            contrastSlider.maximumValue = 3
            contrastSlider.minimumValue = 0.25
            contrastSlider.value = 0.25
        }
        
        if current.imageSaturationChange >= 2 {
            saturationSlider.maximumValue = 2
            saturationSlider.minimumValue = 0
            saturationSlider.value = 2
        }
        
        if current.imageSaturationChange <= 0 {
            saturationSlider.maximumValue = 2
            saturationSlider.minimumValue = 0
            saturationSlider.value = 0
        }
        
        // Do any additional setup after loading the view.
    }
    
    func setImg(image: UIImage){
       
        let imgHeight = CGFloat(250)
        var imgWidth = CGFloat(370)
        
        if image.size.height > image.size.width {
            imgWidth = CGFloat(180)
        }
        
        //sets image shadow
        let outerView = UIView(frame: CGRect(x: view.frame.midX - imgWidth / 2, y: 150, width: imgWidth, height: imgHeight))
        outerView.clipsToBounds = false
        outerView.layer.shadowColor = UIColor.black.cgColor
        outerView.layer.shadowOpacity = 0.8
        outerView.layer.shadowOffset = CGSize.zero
        outerView.layer.shadowRadius = 10
        outerView.layer.shadowPath = UIBezierPath(roundedRect: outerView.bounds, cornerRadius: 10).cgPath
        
        let theImageFrame = CGRect(x: 0 , y: 0, width: imgWidth, height: imgHeight)

        theView = UIImageView(frame: theImageFrame)
        theView.clipsToBounds = true
        theView.layer.cornerRadius = 10
        theView.image = image
        
        
        outerView.addSubview(theView)
       
        view.addSubview(outerView)
    }
    
    private func image(byFiltering image: UIImage) -> UIImage {
        //UIImage -> CGImage -> CIImage
        
        guard let cgImage = image.cgImage else {return image}
        
        let ciImage = CIImage(cgImage: cgImage)
        
        //Set the filters params to the sliders values
        filter.setValue(ciImage, forKey: "inputImage")
        filter.setValue(saturationSlider.value, forKey: "inputSaturation")
        filter.setValue(brightnessSlider.value, forKey: "inputBrightness")
        filter.setValue(contrastSlider.value, forKey: "inputContrast")
        
        //CIImage -> CGImage -> UIImage
        
        //the metadata about how the image should be rendered with the filter
        guard let outputCIImage = filter.outputImage else {return image}
        
        //take the ciimage and run it through the CIcontext to create a tangible CGImage
        guard let outputCGImage = context.createCGImage(outputCIImage, from: outputCIImage.extent) else {return image}
        
        return UIImage(cgImage: outputCGImage)
        
    }
    

    @IBAction func sliderChanged(_ sender: Any) {
        if let unwrappedOriginalImage = originalImage {
            theView.image = image(byFiltering: unwrappedOriginalImage)
        }
        if let unwrappedThumbNailImage = originalThumbNailImage {
            thumbNailImage = image(byFiltering: unwrappedThumbNailImage)
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        current.imageBrightnessChange = CGFloat(brightnessSlider.value)
        current.imageContrastChange = CGFloat(contrastSlider.value)
        current.imageSaturationChange = CGFloat(saturationSlider.value)

        if self.isMovingFromParent {
            let parentView = navigationController?.viewControllers[0] as? ColorPaletteViewController
            parentView?.imageContainer.image = theView.image
            parentView?.getColors(image: thumbNailImage!)
            
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension UIView {
    var parentViewController: UIViewController? {
        // Starts from next (As we know self is not a UIViewController).
        var parentResponder: UIResponder? = self.next
        while parentResponder != nil {
            if let viewController = parentResponder as? UIViewController {
                return viewController
            }
            parentResponder = parentResponder?.next
        }
        return nil
    }
}
