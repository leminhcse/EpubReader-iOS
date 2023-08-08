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
    }

    // MARK: - Events
    func setPages(hasIn: Bool, text: String) {
        self.lbPages.lbTitle.text = text
        self.lbPages.lbDescription.text = "Trang"
        let tintableImage = UIImage(named: "ic_pages.png")?.withRenderingMode(.alwaysTemplate)
        self.lbPages.imgView.tintColor = UIColor.color(with: .background)
        self.lbPages.imgView.image = tintableImage
    }

    func setRating(rating: String) {
        self.lbRating.lbTitle.text = rating
        self.lbRating.lbDescription.text = "Đánh giá"
        let tintableImage = UIImage(named: "ic_rating.png")?.withRenderingMode(.alwaysTemplate)
        self.lbRating.imgView.tintColor = UIColor.systemYellow
        self.lbRating.imgView.image = tintableImage
    }

    func setReview(reviews: String) {
        self.lbReview.lbTitle.text = reviews
        self.lbReview.lbDescription.text = "Lượt đọc"
        let tintableImage = UIImage(named: "ic_view.png")?.withRenderingMode(.alwaysTemplate)
        self.lbReview.imgView.tintColor = UIColor.color(with: .background)
        self.lbReview.imgView.image = tintableImage
    }
}
