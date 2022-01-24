//
//  ColorPaletteViewController.swift
//  Color+
//
//  Created by Liran on 10/11/2021.
//

import UIKit

class ColorPaletteViewController: UIViewController, UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    
    @IBOutlet weak var backgroundView: UIView!
    @IBOutlet weak var titlePress: UILabel!
    @IBOutlet weak var titleImage: UILabel!
    @IBOutlet weak var titlePalette: UILabel!
    @IBOutlet weak var savePaletteButton: UIButton!
    @IBOutlet weak var uploadImage: UIButton!
    @IBOutlet var imageContainer: UIImageView!
    @IBOutlet weak var colorPaletteContainer: UIView!
    var colorsHex: [[CGFloat]]!
    @IBOutlet var hexValueLabel: UILabel!
    @IBOutlet var addToFavButton: UIButton!
    @IBOutlet var copyHexButton: UIButton!
    @IBOutlet var editImageButton: UIBarButtonItem!
    var gradientLayer = CAGradientLayer()
    var compressedImage: UIImage? = nil
    
    let imgHeight = CGFloat(250)
    var imgWidth = CGFloat(370)
        
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
//        view.backgroundColor = UIColor.white
        self.title = "Color+"
        colorsHex = []
        titleImage.isHidden = true
        titlePalette.isHidden = true
        addToFavButton?.isEnabled = false
        savePaletteButton?.isEnabled = false
        copyHexButton?.isEnabled = false
        editImageButton?.isEnabled = false
        copyHexButton?.setImage(UIImage(systemName: "doc.on.doc") , for: UIControl.State.normal)
        copyHexButton?.setImage(UIImage() , for: UIControl.State.disabled)
//        UserDefaults.standard.set([], forKey: "Favorites")
        setDropDownMenu()

        gradientLayer.frame = view.bounds
        gradientLayer.colors = [#colorLiteral(red: 0.9873165488, green: 0.7010524869, blue: 0.7917805314, alpha: 1).cgColor, #colorLiteral(red: 0.9764705896, green: 0.850980401, blue: 0.5490196347, alpha: 1).cgColor]
        gradientLayer.shouldRasterize = true
        backgroundView.layer.addSublayer(gradientLayer)
        
        let outerView = UIView(frame: CGRect(x: self.view.frame.midX - imgWidth / 2, y: 150, width: imgWidth, height: imgHeight))
        outerView.clipsToBounds = false
        
        let theImageFrame = CGRect(x: 0 , y: 0, width: imgWidth, height: imgHeight)

        self.imageContainer = UIImageView(frame: theImageFrame)
        self.imageContainer.clipsToBounds = true
        self.imageContainer.layer.cornerRadius = 10
        self.imageContainer.image = nil
        
        outerView.addSubview(self.imageContainer)
        self.view.addSubview(outerView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        setFavButton()
    }
    
    override var shouldAutorotate: Bool {
            return false
        }
    
    // this is a convenient way to create this view controller without a imageURL
    convenience init() {
        self.init()
    }
    
    init(image: UIImage) {
        //Init must load before anything else
        super.init(nibName: nil, bundle: nil)
        //Color fetching relegated to async queue
        self.imageContainer.image = image
        self.getColors(image: image)
    }
        
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    ///Defines actions shown upon clicking (+)
    func setDropDownMenu(){
        var menuItems: [UIAction] {
            return [
                UIAction(title: "Photo Libary", image: UIImage(systemName: "photo"), handler: { (_) in self.importPhoto()
                }),
                UIAction(title: "Camera", image: UIImage(systemName: "camera"), handler: { (_) in self.takePhoto()
                } ),
            ]
        }

        var demoMenu: UIMenu {
            return UIMenu(title: "Create Palette", image: nil, identifier: nil, options: [], children: menuItems)
        }
        
        uploadImage.menu = demoMenu
        uploadImage.showsMenuAsPrimaryAction = true
    }
    
    ///Delegate imagePicker, sourecetype = camera
    func takePhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true, completion: nil)
    }
    
    ///Delegate imagePicker, sourecetype = photoLibrary
    func importPhoto() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        //https://www.hackingwithswift.com/books/ios-swiftui/importing-an-image-into-swiftui-using-uiimagepickercontroller
        if let image = info[.originalImage] as? UIImage {
            
            if image.size.height > image.size.width {
                imgWidth = CGFloat(180)
            } else{
                imgWidth = CGFloat(370)
            }
            
            self.imageContainer.removeFromSuperview()
            let outerView = UIView(frame: CGRect(x: self.view.frame.midX - imgWidth / 2, y: 150, width: imgWidth, height: imgHeight))
            outerView.clipsToBounds = false
            
            let theImageFrame = CGRect(x: 0 , y: 0, width: imgWidth, height: imgHeight)

            self.imageContainer = UIImageView(frame: theImageFrame)
            self.imageContainer.clipsToBounds = true
            self.imageContainer.layer.cornerRadius = 10
            self.imageContainer.image = nil
            
            outerView.addSubview(self.imageContainer)
            self.view.addSubview(outerView)
            
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
                //sets image shadow
                self.imageContainer.image = image
                self.compressedImage = self.compressImage(image: image)
                if let compressedImage = self.compressedImage {
                    self.getColors(image: compressedImage)
                }
            }
        }else{
            dismiss(animated: true, completion: nil)
        }
    }
    
    func iteratesImage(baseImage: UIImage?){
        //Ensure that image is present
        guard let bigImage = baseImage else {return}
        ///Tiny array to make iteration easier
        let image = compressImage(image: bigImage)
//        guard let image = image else {return}
            let width = Int(image.size.width)
            let height = Int(image.size.height)
        //Instantiate local array for holding pixel color values
        var pixelArray: [Pixel] = []
            var red = 0, green = 0, blue = 0
        //Main logic: Iterate through pixel
            if let cfData = image.cgImage?.dataProvider?.data, let pointer = CFDataGetBytePtr(cfData) {
//                print("width \(width) height \(height)")
                for x in 0..<width {
                    for y in 0..<height {
                        let pixelAddress = x * 4 + y * width * 4
                        red = Int(pointer.advanced(by: pixelAddress).pointee)
                        green = Int(pointer.advanced(by: pixelAddress + 1).pointee)
                        blue = Int(pointer.advanced(by: pixelAddress + 2).pointee)
                        
                        ///Reassign to floats for color assignments
                        let redVal = CGFloat(red)
                        let greenVal = CGFloat(green)
                        let blueVal = CGFloat(blue)
                        ///Create totalcolor with removed opacity stuff
                        let totalColor = Pixel(r: redVal, g: greenVal, b: blueVal)
                        ///Add totalColor to local pixelArray
                        pixelArray.append(totalColor)
//                        print("Appended \([redVal, greenVal, blueVal])")
                    }
                }//End outer for
                //Assign new working array of pixels to global reference
                current.pixelList = []
                current.pixelList = pixelArray
            }
        }
    
    /**
     Creates a reduced-quality UIImage from the input.
     - Parameters:
        - image: the image to be compressed
     - Returns: Image reduced to value set in current.thumbsize
     */
    func compressImage(image: UIImage) -> UIImage {
        guard let thumbnail = image.imageByScaling(image: image, toSize: current.thumbSize) else {return image}
//        print("THUMBNAIL \(thumbnail) vs regular \(image)")
//        imageContainer.image = thumbnail
        return thumbnail
//        return image
    }
    
    /**
     Given an image, saves the pixels to current, runs kMeans, then draws the 6 colors in the wells.
     - Parameter image: The image to be iterated over & saved as Pixels, then analyzed under kMeans
     - Returns: N/A (but saves Pixels to current.pixels for later use.
     */
    func getColors(image: UIImage){
//        print("Getting colors...")
        self.dismiss(animated: true, completion: nil)
        self.colorsHex = []
        DispatchQueue.main.async {
            self.iteratesImage(baseImage: image)
    //        let trueColors = fit(points: current.pixelList)
    //        let minCount = [colorsHex.count, current.pixelList.count].min()
            kMeans()
            for i in 0...5 {
                self.colorsHex.append([current.palette[i].RED/255, current.palette[i].GREEN/255, current.palette[i].BLUE/255])
            }

//            print("all the colors in colorshex \(String(describing: self.colorsHex))")
    //        colorsHex = current.palette
            self.drawColors()
        }
    }
    /**
     Draws representative color circles for the palette.
     - Draws circle bezier paths (that will be clickable)
     - Troubleshot with help from: https://stackoverflow.com/questions/32490837/cgcontextsavegstate-invalid-context-0x0-xcode-7-gm
     */
    func drawColors(){
        //Show titleImage and titlePalette
        titlePalette.isHidden = false
        titleImage.isHidden = false
        //Hide titlePress
        titlePress.isHidden = true
//        backgroundView.removeFromSuperview()
        
        //Clear any extant colors
        clearColors()
        let centerWidth = colorPaletteContainer.frame.width / 4
        let height = CGFloat(25)
        var circleCenter = CGPoint(x: centerWidth, y: height)
        
        let frame = colorPaletteContainer.frame
        UIGraphicsBeginImageContext(frame.size)
        
        for i in 1...6 {
            if i < 4 {
            circleCenter = CGPoint(x: centerWidth * CGFloat(i), y: height)
            } else {
                circleCenter = CGPoint(x: centerWidth * CGFloat(i - 3), y: height + 80)
            }
            
            let circlePath = UIBezierPath(arcCenter: circleCenter, radius: CGFloat(25), startAngle: CGFloat(0), endAngle: CGFloat(Double.pi * 2), clockwise: true)
                
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = circlePath.cgPath
            circlePath.fill()
                
            // Change the fill color
            shapeLayer.fillColor = UIColor(red: CGFloat(colorsHex[i-1][0]), green: CGFloat(colorsHex[i-1][1]), blue: CGFloat(colorsHex[i-1][2]), alpha: 1).cgColor
            shapeLayer.strokeColor = UIColor.black.cgColor
            shapeLayer.lineWidth = 1
            shapeLayer.masksToBounds = false;
            shapeLayer.shadowOffset = CGSize.zero;
            shapeLayer.shadowRadius = 5;
            shapeLayer.shadowOpacity = 0.8;
            
            shapeLayer.setNeedsDisplay()
                
            colorPaletteContainer.layer.addSublayer(shapeLayer)
        }
        
        UIGraphicsEndImageContext()
        addToFavButton?.isEnabled = true
        savePaletteButton?.isEnabled = true
        editImageButton?.isEnabled = true
        
        setFavButton()
    }
    
    func clearColors(){
        colorPaletteContainer.layer.sublayers = []
    }
    
    func setFavButton() {
        let favoritePalettes = loadUserDefaults()
        //Safe unwrap of colorsHex
        guard let hexColors = self.colorsHex else {return}
        if favoritePalettes.contains(hexColors){
            addToFavButton.setImage(UIImage(systemName: "heart.fill") , for: UIControl.State.normal)
        } else {
            addToFavButton.setImage(UIImage(systemName: "heart") , for: UIControl.State.normal)
        }
    }
    
    @IBAction func saveColorPalette(_ sender: Any) {
        UIGraphicsBeginImageContext(colorPaletteContainer.frame.size)
        guard UIGraphicsGetCurrentContext() != nil,
            let graphicsContext = UIGraphicsGetCurrentContext()
        else { return }
        colorPaletteContainer.layer.render(in: graphicsContext)
        let colorPalette = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        if let colorPalette = colorPalette {
            UIImageWriteToSavedPhotosAlbum(colorPalette, nil, nil, nil)
            let alert = UIAlertController(title: "Saved", message: "This palette was saved to your photos", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    @IBAction func addToFavorites(sender: UIButton){
        var favoritePalettes = loadUserDefaults()
        guard let hexColors = self.colorsHex else {return}
        
        if !favoritePalettes.contains(hexColors){
            favoritePalettes.append(hexColors)
            UserDefaults.standard.set(favoritePalettes, forKey: "Favorites")

            let alert = UIAlertController(title: "Added", message: "Added to Favorites", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        } else {
            let removeIndex = favoritePalettes.firstIndex(of: self.colorsHex) ?? 0
            favoritePalettes.remove(at: removeIndex)
        
            let alert = UIAlertController(title: "Already in", message: "Already in Favorites", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
        UserDefaults.standard.set(favoritePalettes, forKey: "Favorites")
        setFavButton()
    }
    
    /**Loads favorite palettes from userDefaults
     - Returns: favoritesArray or []
     */
    func loadUserDefaults() -> [[[CGFloat]]] {
        let favoritePalettes = UserDefaults.standard.array(forKey: "Favorites") as? [[[CGFloat]]]
        
        guard let retPalettes = favoritePalettes else {return []}
        
        return retPalettes
    }
    
    ///Alert that hex value has been added!
    @IBAction func copyHexValue(_ sender: Any) {
        UIPasteboard.general.string = hexValueLabel.text
        let alert = UIAlertController(title: "Copied", message: "Hex value copied to board", preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
    
    ///Preps EditPictureViewController
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "EditPicture" {
            //No unwraps needed
            let destination = segue.destination as? EditPictureViewController
            destination?.originalImage = imageContainer.image
            destination?.thumbNailImage = compressedImage
            destination?.originalThumbNailImage = compressedImage
            destination?.setImg(image: imageContainer.image ?? UIImage())
        }
    }
    
    ///Defines infoButton alert.
    @IBAction func infoClicked(_ sender: Any) {
        let alertDesc = "Welcome to Color+! Upload or take a picture, and we will show you its top 6 colors. With edit, save, and copy functionality, palette-making has never been this easy. The best friend of designers and the color curious. Get started with the (+) button."
        let alert = UIAlertController(title: "Color+", message: alertDesc, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        self.present(alert, animated: true, completion: nil)
        
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
            for touch in touches {
                let touchLocation = touch.location(in: colorPaletteContainer)

                for sublayer in colorPaletteContainer.layer.sublayers ?? [] {

                    if let shapeLayer = sublayer as? CAShapeLayer {
                        guard let shapePath = shapeLayer.path else {return}
                        if shapePath.contains(touchLocation) {
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
