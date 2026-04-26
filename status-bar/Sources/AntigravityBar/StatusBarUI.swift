import AppKit

struct StatusBarUI {
    
    static func makeTimerCircle(secondsLeft: Double, size: CGFloat = 14) -> NSImage {
        let maxCycle: Double = 5400 // 90 min cycle
        let elapsed = max(0, min(1, 1.0 - secondsLeft / maxCycle))

        let img = NSImage(size: NSSize(width: size, height: size), flipped: false) { rect in
            let center = NSPoint(x: rect.midX, y: rect.midY)
            let radius = (size - 2) / 2

            let bgPath = NSBezierPath(ovalIn: rect.insetBy(dx: 1, dy: 1))
            NSColor.white.withAlphaComponent(0.35).setFill()
            bgPath.fill()
            NSColor.white.withAlphaComponent(0.6).setStroke()
            bgPath.lineWidth = 0.75
            bgPath.stroke()

            if elapsed > 0.01 {
                let startAngle: CGFloat = 90
                let endAngle = startAngle - CGFloat(elapsed * 360)

                let piePath = NSBezierPath()
                piePath.move(to: center)
                piePath.appendArc(withCenter: center, radius: radius, startAngle: startAngle, endAngle: endAngle, clockwise: true)
                piePath.close()
                NSColor.white.withAlphaComponent(0.85).setFill()
                piePath.fill()
            }
            return true
        }
        img.isTemplate = false
        return img
    }

    static func makeSparkline(history: [Int], color: NSColor, size: NSSize = NSSize(width: 30, height: 12)) -> NSImage {
        let img = NSImage(size: size, flipped: false) { rect in
            let count = max(history.count, 2)
            let stepX = rect.width / CGFloat(count - 1)
            
            var points: [NSPoint] = []
            for (i, val) in history.enumerated() {
                let x = CGFloat(i) * stepX
                let y = (CGFloat(val) / 100.0) * rect.height
                points.append(NSPoint(x: x, y: y))
            }
            
            let fillPath = NSBezierPath()
            fillPath.move(to: NSPoint(x: 0, y: 0))
            fillPath.line(to: points[0])
            for pt in points.dropFirst() {
                fillPath.line(to: pt)
            }
            fillPath.line(to: NSPoint(x: rect.width, y: 0))
            fillPath.close()
            
            color.withAlphaComponent(0.85).setFill()
            fillPath.fill()
            
            return true
        }
        img.isTemplate = false
        return img
    }

    static func colorForResourceUsage(_ pct: Int) -> NSColor {
        if pct > 85 { return NSColor.systemRed }
        if pct > 65 { return NSColor.systemOrange }
        if pct > 40 { return NSColor.systemYellow }
        return NSColor.systemGreen
    }

    static func makeBarTitle(models: [ModelQuota], daemonOnline: Bool, cacheFormatted: String, cacheMB: Double, cpu: Int, gpu: Int, ram: Int, historyCPU: [Int], historyGPU: [Int], historyRAM: [Int]) -> NSAttributedString {
        let result = NSMutableAttributedString()
        let pctFont = NSFont.monospacedDigitSystemFont(ofSize: 13, weight: .regular)
        let sepFont = NSFont.systemFont(ofSize: 12, weight: .regular)
        let sep = NSAttributedString(string: "  |  ", attributes: [
            .font: sepFont, .foregroundColor: NSColor.tertiaryLabelColor
        ])

        // 1. Cache
        let cacheColor = colorForCacheMB(cacheMB)
        let cacheStr = NSAttributedString(string: cacheFormatted, attributes: [
            .font: pctFont, .foregroundColor: cacheColor
        ])
        result.append(cacheStr)
        result.append(sep)

        // 2. Models
        if models.isEmpty {
            if !daemonOnline {
                let offStr = NSAttributedString(string: "OFF", attributes: [
                    .font: pctFont, .foregroundColor: NSColor.tertiaryLabelColor
                ])
                result.append(offStr)
                result.append(sep)
            }
        } else {
            let grouped = groupModels(models)
            for g in grouped {
                let color = colorForPercentage(g.pct)

                let circleImg = makeTimerCircle(secondsLeft: g.secsLeft)
                let attachment = NSTextAttachment()
                attachment.image = circleImg
                attachment.bounds = CGRect(x: 0, y: -1, width: 14, height: 14)
                result.append(NSAttributedString(attachment: attachment))
                result.append(NSAttributedString(string: " ", attributes: [.font: sepFont]))

                var formattedPctStr = "\(g.pct)%"
                if g.pct < 10 {
                    formattedPctStr = "\u{2007}\u{2007}\(g.pct)%"
                } else if g.pct < 100 {
                    formattedPctStr = "\u{2007}\(g.pct)%"
                }
                
                let pctStr = NSAttributedString(string: formattedPctStr, attributes: [
                    .font: pctFont, .foregroundColor: color
                ])
                result.append(pctStr)
                result.append(sep)
            }
        }

        // 3. Stats
        let stats: [(String, Int, [Int], NSColor)] = [
            ("CPU", cpu, historyCPU, NSColor.systemBlue),
            ("GPU", gpu, historyGPU, colorForResourceUsage(gpu)),
            ("RAM", ram, historyRAM, colorForResourceUsage(ram))
        ]
        for (idx, stat) in stats.enumerated() {
            let color = stat.3
            
            let sparkImg = makeSparkline(history: stat.2, color: color)
            let attachment = NSTextAttachment()
            attachment.image = sparkImg
            attachment.bounds = CGRect(x: 0, y: -1, width: sparkImg.size.width, height: sparkImg.size.height)
            result.append(NSAttributedString(attachment: attachment))
            result.append(NSAttributedString(string: " ", attributes: [.font: sepFont]))
            
            var formattedPctStr = "\(stat.1)"
            if stat.1 < 10 {
                formattedPctStr = "\u{2007}\u{2007}\(stat.1)"
            } else if stat.1 < 100 {
                formattedPctStr = "\u{2007}\(stat.1)"
            }
            
            result.append(NSAttributedString(string: formattedPctStr, attributes: [
                .font: pctFont, .foregroundColor: NSColor.labelColor
            ]))
            
            if idx < stats.count - 1 {
                result.append(sep)
            }
        }

        return result
    }

    static func groupModels(_ models: [ModelQuota]) -> [(name: String, pct: Int, secsLeft: Double)] {
        struct Group {
            let name: String
            let keywords: [String]
        }
        let groups = [
            Group(name: "Pro", keywords: ["pro"]),
            Group(name: "Flash", keywords: ["flash"]),
            Group(name: "Claude", keywords: ["claude", "sonnet", "opus"])
        ]

        var result: [(name: String, pct: Int, secsLeft: Double)] = []
        for group in groups {
            let matching = models.filter { m in
                let l = m.label.lowercased()
                return group.keywords.contains(where: { l.contains($0) })
            }
            if !matching.isEmpty {
                let minPct = Int(matching.map(\.remainingPercentage).min() ?? 0)
                let minSecs = matching.map(\.secondsUntilReset).min() ?? 0
                result.append((name: group.name, pct: minPct, secsLeft: minSecs))
            }
        }
        return result
    }

    static func colorForPercentage(_ pct: Int) -> NSColor {
        if pct == 100 { return NSColor.white }
        if pct >= 80 { return NSColor.systemGreen }
        if pct >= 60 { return NSColor.systemYellow }
        if pct >= 40 { return NSColor.systemOrange }
        return NSColor.systemRed
    }

    static func colorForCacheMB(_ mb: Double) -> NSColor {
        if mb < 100 { return NSColor.systemGreen }
        if mb < 300 { return NSColor.systemYellow }
        if mb < 500 { return NSColor.systemOrange }
        return NSColor.systemRed
    }
}
