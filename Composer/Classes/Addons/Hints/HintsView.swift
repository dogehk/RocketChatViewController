//
//  HintsView.swift
//  RocketChatViewController Example
//
//  Created by Matheus Cardoso on 9/12/18.
//  Copyright © 2018 Rocket.Chat. All rights reserved.
//

import UIKit

public protocol HintsDelegate {
    func numberOfHints(in hintsView: HintsView) -> Int
    func maximumHeight(for hintsView: HintsView) -> CGFloat
    func hintsView(_ hintsView: HintsView, cellForHintAt index: Int) -> UITableViewCell
    func title(for hintsView: HintsView) -> String?
}

public extension HintsDelegate {
    func title(for hintsView: HintsView) -> String? {
        return "Suggestions"
    }

    func maximumHeight(for hintsView: HintsView) -> CGFloat {
        return 300
    }
}

private final class HintsFallbackDelegate: HintsDelegate {
    func numberOfHints(in hintsView: HintsView) -> Int {
        return 0
    }

    func hintsView(_ hintsView: HintsView, cellForHintAt index: Int) -> UITableViewCell {
        return UITableViewCell()
    }
}

public class HintsView: UITableView {
    public var hintsDelegate: HintsDelegate?
    private var fallbackDelegate: HintsDelegate = HintsFallbackDelegate()

    private var currentDelegate: HintsDelegate {
        return hintsDelegate ?? fallbackDelegate
    }

    public override var intrinsicContentSize: CGSize {
        if numberOfRows(inSection: 0) == 0 {
            return CGSize(width: contentSize.width, height: 0)
        }

        return CGSize(width: contentSize.width, height: min(contentSize.height, currentDelegate.maximumHeight(for: self)))
    }

    public override func reloadData() {
        super.reloadData()
        invalidateIntrinsicContentSize()
    }

    public init() {
        super.init(frame: .zero, style: .plain)
        self.commonInit()
    }

    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.commonInit()
    }

    /**
     Shared initialization procedures.
     */
    private func commonInit() {
        dataSource = self
        delegate = self
        rowHeight = UITableViewAutomaticDimension
        estimatedRowHeight = 44

        register(
            UITableViewHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier: "header"
        )

        addSubviews()
        setupConstraints()
    }

    /**
     Adds buttons and other UI elements as subviews.
     */
    private func addSubviews() {

    }

    /**
     Sets up constraints between the UI elements in the composer.
     */
    private func setupConstraints() {
        translatesAutoresizingMaskIntoConstraints = false

        NSLayoutConstraint.activate([

        ])
    }
}

extension HintsView: UITableViewDataSource {
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentDelegate.numberOfHints(in: self)
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return currentDelegate.hintsView(self, cellForHintAt: indexPath.row)
    }

    public func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return currentDelegate.title(for: self)
    }
}

extension HintsView: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }

        header.backgroundView?.backgroundColor = .white
        header.textLabel?.text = currentDelegate.title(for: self)
        header.textLabel?.textColor = #colorLiteral(red: 0.6196078431, green: 0.6352941176, blue: 0.6588235294, alpha: 1)
    }
}
