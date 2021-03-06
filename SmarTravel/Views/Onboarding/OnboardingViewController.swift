import UIKit
import FirebaseAuth

class OnboardingViewController: UIViewController {
    
    // MARK: - UI element diclaration
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var nextBTN: UIButton!
    
    // MARK: - global variables diclaration
    
    var slides: [OnBoardingSlide] = []
    var currentPage:Int = 0 {
        didSet {
            pageControl.currentPage = currentPage
            if currentPage == slides.count - 1 {
                nextBTN.setTitle("Get Started", for: .normal)
            } else {
                nextBTN.setTitle("Next", for: .normal)
            }
        }
    }
    
    // MARK: - View life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        slides = [OnBoardingSlide(title: "Welcome to SmarTravel",
                                  description: "Here you can find the best trips worldwide!",
                                  image: #imageLiteral(resourceName: "splash")),
                  OnBoardingSlide(title: "You can find your next trip in a few steps",
                                  description: "With our new home page design it is easy to see all the popular trips and sort by your destination country",
                                  image: #imageLiteral(resourceName: "homepage")),
                  OnBoardingSlide(title: "Find your upcoming trips",
                                  description: "You can see all your upcoming trips in your prifile page",
                                  image: #imageLiteral(resourceName: "my trips"))]
        
        pageControl.numberOfPages = slides.count
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if FirebaseAuth.Auth.auth().currentUser != nil {
            self.logIn()
        }
    }
    
    //MARK: - View methods
    
    @IBAction func nextBTNClicked(_ sender: Any) {
        if currentPage == slides.count - 1 {
            let controller = LoginViewController.instantiate()
            self.present(controller, animated: true, completion: nil)
        } else {
            currentPage += 1
            let indexPath = IndexPath(item: currentPage, section: 0)
            collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }
    
    //MARK: - Methods
    
    func logIn() {
        let controller = UINavigationController.instantiate()
        self.present(controller, animated: true, completion: nil)
    }
}

extension OnboardingViewController: UICollectionViewDelegate, UICollectionViewDataSource , UICollectionViewDelegateFlowLayout {
    
    // MARK: - extension override methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return slides.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: OnboardingCollectionViewCell.identifier,
            for: indexPath) as! OnboardingCollectionViewCell
        
        cell.setup(slides[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let width = scrollView.frame.width
        currentPage = Int(scrollView.contentOffset.x / width)
    }
}
