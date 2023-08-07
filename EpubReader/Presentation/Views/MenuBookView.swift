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
        let stackView = UIStackView()
        stackView.axis = NSLayoutConstraint.Axis.horizontal
        stackView.distribution = .fillEqually
        stackView.alignment = .center
        return stackView
    }()

    public lazy var reviewView: UIView = {
        [unowned self] in
        let view: UIView = UIView()
        view.heightAnchor.constraint(equalToConstant: self.bounds.size.height).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.bounds.size.width/3).isActive = true
        return view
    }()

    public lazy var chapterView: UIView = {
        [unowned self] in
        let view: UIView = UIView()
        view.heightAnchor.constraint(equalToConstant: self.bounds.size.height).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.bounds.size.width/3).isActive = true
        return view
    }()

    public lazy var pageView: UIView = {
        [unowned self] in
        let view: UIView = UIView()
        view.heightAnchor.constraint(equalToConstant: self.bounds.size.height).isActive = true
        view.widthAnchor.constraint(equalToConstant: self.bounds.size.width/3).isActive = true
        return view
    }()

    public lazy var btnReview: ActionButton = {
        [unowned self] in
        let btnReview: ActionButton = ActionButton()
        btnReview.btnAction.isEnabled = false
        return btnReview
    }()

    public lazy var btnChapter: ActionButton = {
        [unowned self] in
        let btnChapter: ActionButton = ActionButton()
        btnChapter.btnAction.isEnabled = false
        return btnChapter
    }()

    public lazy var btnPage: ActionButton = {
        [unowned self] in
        let btnPage: ActionButton = ActionButton()
        btnPage.btnAction.isEnabled = false
        return btnPage
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

    private func setupUI() {
        self.addSubview(self.contentView)
        
        self.contentView.addArrangedSubview(reviewView)
        self.contentView.addArrangedSubview(chapterView)
        self.contentView.addArrangedSubview(pageView)
        self.contentView.translatesAutoresizingMaskIntoConstraints = false

        self.reviewView.addSubview(self.btnReview)
        self.chapterView.addSubview(self.btnChapter)
        self.pageView.addSubview(self.btnPage)
    }

    fileprivate func setupConstraint() {
        self.contentView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview()
        }

        self.btnReview.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        self.btnChapter.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }

        self.btnPage.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }

    func setReview(hasIn: Bool, text: String) {
        self.btnReview.imgView.tintColor = UIColor.color(with: .background)
        let summary = text + " lượt xem"
        setTitle(self.btnReview.lbDescription, summary)
        let tintableImage = UIImage(named: "ic_view.png")?.withRenderingMode(.alwaysTemplate)
        self.btnReview.imgView.image = tintableImage
    }

    func setChapters(chapters: String) {
        self.btnChapter.imgView.tintColor = UIColor.color(with: .background)
        let title = chapters + " Chương"
        let tintableImage = UIImage(named: "ic_chapters.png")?.withRenderingMode(.alwaysTemplate)

        setTitle(self.btnChapter.lbDescription, title)
        self.btnChapter.imgView.image = tintableImage
    }

    func setPages(pages: String) {
        self.btnPage.imgView.tintColor = UIColor.color(with: .background)
        let title = pages + " Trang"
        let tintableImage = UIImage(named: "ic_pages.png")?.withRenderingMode(.alwaysTemplate)

        setTitle(self.btnPage.lbDescription, title)
        self.btnPage.imgView.image = tintableImage
    }

    private func setTitle(_ label: UILabel, _ title: String) {
        label.text = title
        label.addCharacterSpacing()
    }
}
