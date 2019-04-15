//
//  VideoPropertyView.swift
//  Pickle
//
//  Created by Amelia on 15/4/19.
//  Copyright © 2019 Carousell. All rights reserved.
//

internal final class VideoPropertyView: UIView {

    private let videoIcon: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = .white
        icon.image = UIImage(named: "video-icon")?.withRenderingMode(.alwaysTemplate)
        return icon
    }()

    private let durationLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 12)
        label.textAlignment = .right
        label.textColor = .white
        return label
    }()

    func configure(duration: TimeInterval) {
        let formatter = DateComponentsFormatter()
        formatter.zeroFormattingBehavior = .pad

        if duration >= 3600 {
            formatter.allowedUnits = [.hour, .minute, .second]
        } else {
            formatter.allowedUnits = [.minute, .second]
        }

        durationLabel.text = formatter.string(from: duration)
    }

    func setSelected(_ value: Bool) {
        if value {
            backgroundColor = UIColor.Palette.blue
        } else {
            backgroundColor = UIColor.Palette.darkGray.withAlphaComponent(0.2)
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setupViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupViews() {
        backgroundColor = UIColor.Palette.darkGray.withAlphaComponent(0.2)

        addSubview(videoIcon)
        videoIcon.translatesAutoresizingMaskIntoConstraints = false
        videoIcon.heightAnchor.constraint(equalToConstant: 16).isActive = true
        videoIcon.widthAnchor.constraint(equalToConstant: 16).isActive = true
        videoIcon.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 4).isActive = true
        videoIcon.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true

        addSubview(durationLabel)
        durationLabel.translatesAutoresizingMaskIntoConstraints = false
        durationLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -4).isActive = true
        durationLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
}
