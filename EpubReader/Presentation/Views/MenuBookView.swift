//
//  MenuBookView.swift
//  EpubReader
//
//  Created by mac on 14/07/2023.
//

import UIKit
import SnapKit

class MenuBookView: UIView {

    fileprivate lazy var contentView: UIStackView = {
        [unowned self] in
        let contentView = UIStackView()
        contentView.axis = NSLayoutConstraint.Axis.horizontal
        contentView.distribution = .fillEqually
        contentView.alignment = .center
        return contentView
    }()

    public lazy var pageView: UIView = {
        [unowned self] in
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(self.bounds.size.height)
            make.width.equalTo(self.bounds.size.width/3 - 8)
        }
        return view
    }()

    public lazy var ratingView: UIView = {
        [unowned self] in
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(self.bounds.size.height)
            make.width.equalTo(self.bounds.size.width/3 - 8)
        }
        return view
    }()

    public lazy var reviewView: UIView = {
        [unowned self] in
        let view = UIView()
        view.snp.makeConstraints { make in
            make.height.equalTo(self.bounds.size.height)
            make.width.equalTo(self.bounds.size.width/3 - 8)
        }
        return view
    }()
    
    public lazy var verticalLine1: UIView = {
        [unowned self] in
        let verticalLine1 = UIView()
        verticalLine1.backgroundColor = UIColor.gray
        return verticalLine1
    }()
    
    public lazy var verticalLine2: UIView = {
        [unowned self] in
        let verticalLine2 = UIView()
        verticalLine2.backgroundColor = UIColor.gray
        return verticalLine2
    }()

    public lazy var lbPages: BookDetailView = {
        [unowned self] in
        let lbPages = BookDetailView()
        return lbPages
    }()
    
    public lazy var lbRating: BookDetailView = {
        [unowned self] in
        let lbRating = BookDetailView()
        return lbRating
    }()
    
    public lazy var lbReview: BookDetailView = {
        [unowned self] in
        let lbReview = BookDetailView()
        return lbReview
    }()

    // MARK: - Constructors
    override init(frame: CGRect) {
        super.init(frame: frame)

        self.setupUI()
        self.setupConstraint()
    }

    required internal init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    // MARK: - UI Update
    private func setupUI() {
        self.addSubview(self.contentView)
        
        self.contentView.addArrangedSubview(pageView)
        self.contentView.addArrangedSubview(ratingView)
        self.contentView.addArrangedSubview(reviewView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        self.pageView.addSubview(self.lbPages)
        self.ratingView.addSubview(self.lbRating)
        self.reviewView.addSubview(self.lbReview)
    }

    private func setupConstraint() {
        self.contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }

        self.lbPages.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.lbRating.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.lbReview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.contentView.addSubview(verticalLine1)
        self.contentView.addSubview(verticalLine2)

        let padding: CGFloat = 12
        let verticalHeight = self.frame.height - padding*3
        var top: CGFloat = 18
        if UIDevice.current.userInterfaceIdiom == .pad {
            top = 24
        }
        
        verticalLine1.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(top)
            make.leading.equalTo(self.lbPages.snp.trailing).offset(-padding)
            make.trailing.equalTo(self.lbRating.snp.leading)
            make.size.equalTo(CGSize(width: 0.5, height: verticalHeight))
        }
        
        verticalLine2.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(top)
            make.leading.equalTo(self.lbRating.snp.trailing).offset(top/2)
            make.trailing.equalTo(self.lbReview.snp.leading)
            make.size.equalTo(CGSize(width: 0.5, height: verticalHeight))
        }
    }

    // MARK: - Events
    func setPageNumber(hasIn: Bool, pageNumber: String?) {
        if pageNumber == "" {
            self.lbPages.lbTitle.text = "N/A"
        } else {
            self.lbPages.lbTitle.text = pageNumber
        }
        self.lbPages.lbDescription.text = "Trang"
        let tintableImage = UIImage(named: "ic_pages.png")?.withRenderingMode(.alwaysTemplate)
        self.lbPages.imgView.tintColor = UIColor.color(with: .background)
        self.lbPages.imgView.image = tintableImage
    }

    func setFavoriteNumber(favoriteNumber: Int) {
        self.lbRating.lbTitle.text = String(describing: favoriteNumber)
        self.lbRating.lbDescription.text = "Yêu thích"
        let tintableImage = UIImage(named: "fi_heart.png")?.withRenderingMode(.alwaysTemplate)
        self.lbRating.imgView.tintColor = UIColor.systemPink
        self.lbRating.imgView.image = tintableImage
    }

    func setReviewNumber(reviewNumber: String) {
        self.lbReview.lbTitle.text = reviewNumber
        self.lbReview.lbDescription.text = "Lượt đọc"
        let tintableImage = UIImage(named: "ic_view.png")?.withRenderingMode(.alwaysTemplate)
        self.lbReview.imgView.tintColor = UIColor.color(with: .background)
        self.lbReview.imgView.image = tintableImage
    }
}
