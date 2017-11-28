import UIKit
import CoreData
import Zip

class DetailViewController: UIViewController
{
    @IBOutlet weak var detailLabel: UILabel!
    @IBOutlet weak var imageView: UIImageView!
    
    // Be aware configureView() actually gets executed twice every time another hero is selected -
    // First called from within detailItem() and then called from within viewDidLoad()
    
    func configureView()
    {
        
        
        // Update the user interface for the detail item.
        
        // This if will skip if called from first time of loading the entire view (once only)
        if let detail = self.detailItem
        {
                    
/*
    // Create getter for default document folder
    var documentsUrl: URL
    {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
*/
            
            let filename = detail["filename"].stringValue
            
            if let label = self.detailLabel
            {
                label.text = filename
            
                if let _ = self.imageView
                {
                    do
                    {
                        if let sourceWatchFile = Bundle.main.url(forResource: filename, withExtension: "watch")
                        {
                            let unzipDirectory = try Zip.quickUnzipFile(sourceWatchFile)
                    
                            let fileURL = unzipDirectory.appendingPathComponent("preview.jpg")
                            
                            let imageData = try Data(contentsOf: fileURL)
                            
                            imageView.contentMode = .scaleAspectFit
                            imageView.image = UIImage(data: imageData)
                        }
                    }
                    catch
                    {
                        print("Something went wrong")
                    }
                }
        }
        }
    }
    
    //Be aware viewDidLoad() actually gets executed every time another hero is selected
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    var detailItem: JSON?
    {
        didSet
        {
            // Update the view.
            self.configureView()
        }
    }
}
