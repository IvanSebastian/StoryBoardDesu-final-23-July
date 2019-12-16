//
//  TutorialViewController.swift
//  ShowTime
//
//  Created by Ivan Sebastian on 10/07/19.
//  Copyright © 2019 whiteHat. All rights reserved.
//

import UIKit

class TutorialViewController: UIViewController, UIScrollViewDelegate {
    
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var pageControl: UIPageControl!
    

    let btnNew = UIButton()
    let judul = [ NSAttributedString.Key.font:UIFont(name: "SF Pro Text", size:18.0)!]
    

    
    var slides:[Slide] = [];
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        scrollView.delegate = self
        slides = createSlides()
        setupSlideScrollView(slides: slides)
        
        pageControl.numberOfPages = slides.count
        pageControl.currentPage = 0
        view.bringSubviewToFront(pageControl)
        
        
        
        
        // Do any additional setup after loading the view.
    }
    
    
    
    
    
    
    
    
    
    func createSlides() -> [Slide]
    {
        let slide1:Slide = Bundle.main.loadNibNamed("SlideView", owner: self, options: nil)?.first as! Slide
        slide1.imageView.image = UIImage(named: "Tutorial 1 (XR)@5x")
        slide1.labelTitle.text = "Welcome to Showtime!"
        slide1.labelDesc.text = "It's Showtime, Baby! We promise to give you jolly and joyful experiences with friends through move and music. So, what are you waiting for? Let's boogie down, folks!"
        
        let slide2:Slide = Bundle.main.loadNibNamed("SlideView", owner: self, options: nil)?.first as! Slide
        slide2.imageView.image = UIImage(named: "Tutorial 2 (XR)")
        slide2.labelTitle.text = "Let the music do the magic!"
        slide2.labelDesc.text = "But, before that, let me say some words! In this game, we have picked fun songs for you all. So, enjoy your time and let the music move your body!"
        
        let slide3:Slide = Bundle.main.loadNibNamed("SlideView", owner: self, options: nil)?.first as! Slide
        slide3.imageView.image = UIImage(named: "Tutorial 3 (XR)")
        slide3.labelTitle.text = "Touch the spots as it appears"
        slide3.labelDesc.text = "There will be spots on your front camera in rhythm with the beats. Make sure you touch it in no time!"
        
        let slide4:Slide = Bundle.main.loadNibNamed("SlideView", owner: self, options: nil)?.first as! Slide
        slide4.imageView.image = UIImage(named: "Tutorial 4 (XR)")
        slide4.labelTitle.text = "Sync yout move!"
        slide4.labelDesc.text = "Cooperation is important in every Showtime moves. You have to work together to finish a music. After all, it is a way more fun when you do them together!"
        
        
        let slide5:Slide = Bundle.main.loadNibNamed("SlideView", owner: self, options: nil)?.first as! Slide
        slide5.imageView.image = UIImage(named: "Tutorial 5 (XR)")
        slide5.labelTitle.text = "Challenge Accepted"
        slide5.labelDesc.text = "There will be different levels to test your teams' Showtime moves, so challenge yourself! Up your level once you find one music is too easy peasy lemon squeezy "
        
        btnNew.frame.size = CGSize(width: 294, height: 44)
        btnNew.layer.cornerRadius = 20
        btnNew.backgroundColor = #colorLiteral(red: 1, green: 0.9607843137, blue: 0.03137254902, alpha: 1)
        btnNew.layer.position = CGPoint(x: slide5.frame.width/2, y: 776)
        btnNew.setTitle("Lets go!", for: .normal)
        btnNew.setTitleColor(.black, for: .normal)
        
        
        slide5.addSubview(btnNew)
        btnNew.addTarget(self, action: #selector(moveToNextScreen), for: .touchUpInside)
        
        
        
        return [slide1, slide2, slide3, slide4, slide5]
        
    }
    

    
    func setupSlideScrollView(slides : [Slide]) {
        scrollView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: view.frame.height)
        scrollView.contentSize = CGSize(width: view.frame.width * CGFloat(slides.count), height: view.frame.height)
        scrollView.isPagingEnabled = true
        
        for i in 0 ..< slides.count {
            slides[i].frame = CGRect(x: view.frame.width * CGFloat(i), y: 0, width: view.frame.width, height: view.frame.height)
            scrollView.addSubview(slides[i])
        }
    }
    
    @objc func moveToNextScreen(){
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let secondVc = storyboard.instantiateViewController(withIdentifier: "Home")
        present(secondVc, animated: true, completion: nil)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let pageIndex = round(scrollView.contentOffset.x/view.frame.width)
        pageControl.currentPage = Int(pageIndex)
        
        let maximumHorizontalOffset: CGFloat = scrollView.contentSize.width - scrollView.frame.width
        let currentHorizontalOffset: CGFloat = scrollView.contentOffset.x
        
        // vertical
        let maximumVerticalOffset: CGFloat = scrollView.contentSize.height - scrollView.frame.height
        let currentVerticalOffset: CGFloat = scrollView.contentOffset.y
        
        let percentageHorizontalOffset: CGFloat = currentHorizontalOffset / maximumHorizontalOffset
        let percentageVerticalOffset: CGFloat = currentVerticalOffset / maximumVerticalOffset
        
        
        /*
         * below code changes the background color of view on paging the scrollview
         */
        //        self.scrollView(scrollView, didScrollToPercentageOffset: percentageHorizontalOffset)
        
        
        /*
         * below code scales the imageview on paging the scrollview
         */
        //        let percentOffset: CGPoint = CGPoint(x: percentageHorizontalOffset, y: percentageVerticalOffset)
        //
        //        if(percentOffset.x > 0 && percentOffset.x <= 0.25) {
        //
        //            slides[0].imageView.transform = CGAffineTransform(scaleX: (0.25-percentOffset.x)/0.25, y: (0.25-percentOffset.x)/0.25)
        //            slides[1].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.25, y: percentOffset.x/0.25)
        //
        //        } else if(percentOffset.x > 0.25 && percentOffset.x <= 0.50) {
        //            slides[1].imageView.transform = CGAffineTransform(scaleX: (0.50-percentOffset.x)/0.25, y: (0.50-percentOffset.x)/0.25)
        //            slides[2].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.50, y: percentOffset.x/0.50)
        //
        //        } else if(percentOffset.x > 0.50 && percentOffset.x <= 0.75) {
        //            slides[2].imageView.transform = CGAffineTransform(scaleX: (0.75-percentOffset.x)/0.25, y: (0.75-percentOffset.x)/0.25)
        //            slides[3].imageView.transform = CGAffineTransform(scaleX: percentOffset.x/0.75, y: percentOffset.x/0.75)
        //
        //        } else if(percentOffset.x > 0.75 && percentOffset.x <= 1) {
        //            slides[3].imageView.transform = CGAffineTransform(scaleX: (1-percentOffset.x)/0.25, y: (1-percentOffset.x)/0.25)
        //            slides[4].imageView.transform = CGAffineTransform(scaleX: percentOffset.x, y: percentOffset.x)
        //        }
    }
    
    
    
    
}
