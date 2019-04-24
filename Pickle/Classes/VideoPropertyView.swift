//
//  This source file is part of the carousell/pickle open source project
//
//  Copyright © 2017 Carousell and the project authors
//  Licensed under Apache License v2.0
//
//  See https://github.com/carousell/pickle/blob/master/LICENSE for license information
//  See https://github.com/carousell/pickle/graphs/contributors for the list of project authors
//

internal final class VideoPropertyView: UIView {

    private lazy var videoIcon: UIImageView = {
        let icon = UIImageView()
        icon.tintColor = .white
        let image = UIImage(named: "video-icon", in: Bundle(for: type(of: self)), compatibleWith: nil)
        icon.image = image?.withRenderingMode(.alwaysTemplate)
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

    func setSelected(_ isSelected: Bool) {
        if isSelected {
            backgroundColor = UIColor.Palette.blue
        } else {
            backgroundColor = UIColor.Palette.grey.withAlphaComponent(0.2)
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
        backgroundColor = UIColor.Palette.grey.withAlphaComponent(0.2)

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
