import AppKit
import Foundation
import ServiceManagement
import SwiftUI

@_silgen_name("CGSMainConnectionID") func CGSMainConnectionID() -> CInt
@_silgen_name("CGSSetWindowLevel") func CGSSetWindowLevel(_ connection: CInt, _ window: CInt, _ level: CInt) -> CInt

struct EnvPaths {
    static let geminiDir = NSHomeDirectory() + "/.gemini"
    static let antigravityDir = NSHomeDirectory() + "/.gemini/antigravity"
    static let ecosystemDir = NSHomeDirectory() + "/Documents/PROJECTS/WORK/AI-Ecosystem"
}

@MainActor
class AppDelegate: NSObject, NSApplicationDelegate, NSMenuDelegate {
    private var statusItem: NSStatusItem!
    private var pollTimer: Timer?
    private var lastQuota: QuotaData?
    private var daemonOnline = false
    private let api = AntigravityAPI.shared
    private var isMenuOpen = false
    private var isFetching = false

    func applicationDidFinishLaunching(_ notification: Notification) {
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)

        if let button = statusItem.button {
            updateBarTitle(models: [], cpu: 0, gpu: 0, ram: 0)
            button.action = #selector(statusBarClicked(_:))
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
        }

        startPolling()
        checkAndShowSetupWizard()
    }

    // MARK: - Polling

    private let backgroundInterval: TimeInterval = 2
    private let activeInterval: TimeInterval = 2
    private let retryInterval: TimeInterval = 2

    private func startPolling() {
        fetchAndUpdate()
    }

    private func scheduleNextPoll() {
        pollTimer?.invalidate()
        let interval: TimeInterval
        if !daemonOnline {
            interval = retryInterval
        } else if isMenuOpen {
            interval = activeInterval
        } else {
            interval = backgroundInterval
        }
        pollTimer = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { [weak self] _ in
            Task { @MainActor in
                self?.fetchAndUpdate()
            }
        }
    }

    func menuWillOpen(_ menu: NSMenu) {
        isMenuOpen = true
        fetchAndUpdate()
    }

    func menuDidClose(_ menu: NSMenu) {
        isMenuOpen = false
        scheduleNextPoll()
    }

    private func fetchAndUpdate() {
        guard !isFetching else { return }
        isFetching = true
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            let cpu = SystemStats.shared.getCPUUsage()
            let gpu = SystemStats.shared.getGPUUsage()
            let ram = SystemStats.shared.getRAMUsage()

            guard let daemon = self.api.findActiveDaemon() else {
                DispatchQueue.main.async {
                    self.daemonOnline = false
                    self.lastQuota = nil
                    self.updateBarTitle(models: [], cpu: cpu, gpu: gpu, ram: ram)
                    self.isFetching = false
                    self.scheduleNextPoll()
                }
                return
            }
            self.api.fetchQuota(daemon: daemon) { quota in
                DispatchQueue.main.async {
                    self.daemonOnline = true
                    self.lastQuota = quota
                    self.updateBarTitle(models: quota?.models ?? [], cpu: cpu, gpu: gpu, ram: ram)
                    self.isFetching = false
                    self.scheduleNextPoll()
                }
            }
        }
    }

    private func updateBarTitle(models: [ModelQuota], cpu: Int, gpu: Int, ram: Int) {
        let cache = api.cacheSize()
        statusItem.button?.attributedTitle = StatusBarUI.makeBarTitle(
            models: models, 
            daemonOnline: daemonOnline, 
            cacheFormatted: cache.formatted, 
            cacheMB: cache.megabytes,
            cpu: cpu,
            gpu: gpu,
            ram: ram,
            historyCPU: SystemStats.shared.cpuHistory,
            historyGPU: SystemStats.shared.gpuHistory,
            historyRAM: SystemStats.shared.ramHistory
        )
    }

    // MARK: - Click Handling
    @objc private func statusBarClicked(_ sender: NSStatusBarButton) {
        showContextMenu()
    }

    // MARK: - Context Menu
    
    private func prepareModelsForMenu(quota: QuotaData) -> [ModelQuota] {
        let sortedModels = quota.models.sorted { m1, m2 in
            func priority(_ label: String) -> Int {
                let l = label.lowercased()
                if l.contains("3.1") || l.contains("pro") {
                    if l.contains("high") { return 10 }
                    if l.contains("low") { return 11 }
                    return 12
                }
                if l.contains("flash") || l.contains("gemini 3") { return 20 }
                if l.contains("sonnet") { return 30 }
                if l.contains("opus") { return 31 }
                if l.contains("claude") { return 32 }
                if l.contains("oss") || l.contains("120b") || l.contains("gemma") { return 40 }
                return 100
            }
            let p1 = priority(m1.label)
            let p2 = priority(m2.label)
            if p1 != p2 { return p1 < p2 }
            return m1.label < m2.label
        }

        var finalModels: [ModelQuota] = []
        var proModels: [ModelQuota] = []
        for m in sortedModels {
            if m.label.lowercased().contains("3.1") {
                proModels.append(m)
            } else {
                finalModels.append(m)
            }
        }
        
        if !proModels.isEmpty {
            let minPct = proModels.map { $0.remainingPercentage }.min() ?? 0
            let minSecs = proModels.map { $0.secondsUntilReset }.min() ?? 0
            let minTimeStr = proModels.first(where: { $0.secondsUntilReset == minSecs })?.timeUntilReset ?? ""
            let isExh = proModels.allSatisfy { $0.isExhausted }
            let combined = ModelQuota(
                label: "Gemini 3.1 Pro",
                remainingPercentage: minPct,
                isExhausted: isExh,
                timeUntilReset: minTimeStr,
                secondsUntilReset: minSecs
            )
            finalModels.insert(combined, at: 0)
        }
        return finalModels
    }

    private func showContextMenu() {
        let menu = NSMenu()
        menu.autoenablesItems = false
        menu.delegate = self

        // Header with quota details
        if let quota = lastQuota {
            let finalModels = prepareModelsForMenu(quota: quota)
            menu.addItem(makeModelsHorizontalItem(models: finalModels))
        } else {
            let item = NSMenuItem(title: "⏳ No quota data", action: nil, keyEquivalent: "")
            item.isEnabled = false
            menu.addItem(item)
        }

        menu.addItem(.separator())
        
        // BLOCK: Top RAM Apps (Informational Strip)
        menu.addItem(makeAppsHorizontalItem())

        menu.addItem(.separator())
        menu.addItem(makeHorizontalToolbarItem())
        menu.addItem(.separator())
        
        let quitItem = NSMenuItem(title: "Quit", action: #selector(quitApp), keyEquivalent: "")
        quitItem.target = self
        menu.addItem(quitItem)

        statusItem.menu = menu
        statusItem.button?.performClick(nil)
        DispatchQueue.main.async { [weak self] in
            self?.statusItem.menu = nil
        }
    }

    private func createLabel(_ attrStr: NSAttributedString) -> NSTextField {
        let field = NSTextField()
        field.attributedStringValue = attrStr
        field.isEditable = false
        field.drawsBackground = false
        field.isBordered = false
        field.alignment = .center
        field.lineBreakMode = .byTruncatingTail
        field.maximumNumberOfLines = 1
        return field
    }

    private func makeHorizontalToolbarItem() -> NSMenuItem {
        let item = NSMenuItem()
        
        let allActions: [(String, String, NSColor)] = [
            ("Main\nGEMINI", "doc.text", .systemBlue),
            ("Knowledge\nProfile", "person.crop.circle", .systemPurple),
            ("Skills\n& Tools", "wrench.and.screwdriver", .systemOrange),
            ("Global\nWorkflows", "arrow.triangle.branch", .systemTeal),
            ("Setup &\nAudit", "desktopcomputer", .systemIndigo),
            ("Restart &\nReload", "arrow.clockwise", .systemYellow),
            ("Full\nCleanup", "trash", .systemRed)
        ]
        
        let mainStack = NSStackView()
        mainStack.orientation = .vertical
        mainStack.distribution = .fillEqually
        mainStack.spacing = 8
        
        func createRow(actions: [(String, String, NSColor)], startIndex: Int) -> NSStackView {
            let rowStack = NSStackView()
            rowStack.orientation = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 8
            
            for (i, action) in actions.enumerated() {
                let containerBox = NSBox()
                containerBox.boxType = .custom
                containerBox.borderWidth = 0
                containerBox.cornerRadius = 10
                containerBox.fillColor = NSColor.labelColor.withAlphaComponent(0.06)
                
                let vStack = NSStackView()
                vStack.orientation = .vertical
                vStack.alignment = .centerX
                vStack.spacing = 4
                
                let imgView = NSImageView()
                if let img = NSImage(systemSymbolName: action.1, accessibilityDescription: nil) {
                    let config = NSImage.SymbolConfiguration(pointSize: 15, weight: .semibold)
                    img.isTemplate = true
                    imgView.image = img.withSymbolConfiguration(config)
                }
                imgView.contentTintColor = action.2
                
                let lbl = NSTextField(labelWithString: action.0)
                lbl.font = NSFont.systemFont(ofSize: 10, weight: .semibold)
                lbl.textColor = NSColor.labelColor
                lbl.alignment = .center
                lbl.lineBreakMode = .byWordWrapping
                lbl.maximumNumberOfLines = 2
                
                vStack.addArrangedSubview(imgView)
                vStack.addArrangedSubview(lbl)
                
                containerBox.contentView = vStack
                vStack.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    vStack.leadingAnchor.constraint(equalTo: containerBox.leadingAnchor, constant: 2),
                    vStack.trailingAnchor.constraint(equalTo: containerBox.trailingAnchor, constant: -2),
                    vStack.centerYAnchor.constraint(equalTo: containerBox.centerYAnchor)
                ])
                
                let btn = NSButton()
                btn.title = ""
                btn.isBordered = false
                btn.isTransparent = true
                btn.target = self
                btn.action = #selector(toolbarButtonClicked(_:))
                btn.tag = startIndex + i
                btn.toolTip = action.0
                
                let wrapper = NSView()
                containerBox.translatesAutoresizingMaskIntoConstraints = false
                btn.translatesAutoresizingMaskIntoConstraints = false
                wrapper.addSubview(containerBox)
                wrapper.addSubview(btn)
                
                NSLayoutConstraint.activate([
                    containerBox.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
                    containerBox.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
                    containerBox.topAnchor.constraint(equalTo: wrapper.topAnchor),
                    containerBox.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
                    
                    btn.leadingAnchor.constraint(equalTo: wrapper.leadingAnchor),
                    btn.trailingAnchor.constraint(equalTo: wrapper.trailingAnchor),
                    btn.topAnchor.constraint(equalTo: wrapper.topAnchor),
                    btn.bottomAnchor.constraint(equalTo: wrapper.bottomAnchor),
                    
                    wrapper.heightAnchor.constraint(equalToConstant: 72)
                ])
                
                rowStack.addArrangedSubview(wrapper)
            }
            
            return rowStack
        }
        
        let row1Stack = createRow(actions: Array(allActions[0..<4]), startIndex: 0)
        let row2Stack = createRow(actions: Array(allActions[4...]), startIndex: 4)
        
        mainStack.addArrangedSubview(row1Stack)
        mainStack.addArrangedSubview(row2Stack)
        
        row1Stack.translatesAutoresizingMaskIntoConstraints = false
        row2Stack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            row1Stack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            row1Stack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor),
            row2Stack.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
            row2Stack.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor)
        ])
        
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 550, height: 160))
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            mainStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            mainStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4)
        ])
        
        item.view = container
        return item
    }

    private func makeAppsHorizontalItem() -> NSMenuItem {
        let item = NSMenuItem()
        
        let mainStack = NSStackView()
        mainStack.orientation = .vertical
        mainStack.distribution = .fillEqually
        mainStack.spacing = 8
        
        let topApps = Array(ProcessManager.getTopProcesses().prefix(10)) // 10 apps
        
        func createRow(apps: [AppGroup]) -> NSStackView {
            let rowStack = NSStackView()
            rowStack.orientation = .horizontal
            rowStack.distribution = .fillEqually
            rowStack.spacing = 8
            
            for app in apps {
                let memoryStr = ProcessManager.formatMemory(app.totalRssKB)
                
                var icon: NSImage?
                if app.isSystemGroup {
                    if #available(macOS 12.0, *) {
                        icon = NSImage(systemSymbolName: "gearshape.fill", accessibilityDescription: nil)?
                            .withSymbolConfiguration(.init(hierarchicalColor: .systemGray))
                    } else {
                        icon = NSImage(systemSymbolName: "gearshape.fill", accessibilityDescription: nil)
                    }
                } else if !app.appPath.isEmpty, FileManager.default.fileExists(atPath: app.appPath) {
                    icon = NSWorkspace.shared.icon(forFile: app.appPath)
                }
                
                let imgView = NSImageView()
                imgView.image = icon
                imgView.imageScaling = .scaleProportionallyUpOrDown
                
                var displayName = app.appName
                if displayName.hasSuffix(".app") {
                    displayName = String(displayName.dropLast(4))
                }
                
                let nameAttr = NSAttributedString(string: displayName, attributes: [
                    .font: NSFont.systemFont(ofSize: 10, weight: .medium),
                    .foregroundColor: app.isSystemGroup ? NSColor.systemBlue : NSColor.secondaryLabelColor
                ])
                let nameField = createLabel(nameAttr)
                
                let memAttr = NSAttributedString(string: memoryStr, attributes: [
                    .font: NSFont.monospacedDigitSystemFont(ofSize: 11, weight: .bold),
                    .foregroundColor: NSColor.systemYellow
                ])
                let memField = createLabel(memAttr)
                
                let vStack = NSStackView()
                vStack.orientation = .vertical
                vStack.alignment = .centerX
                vStack.spacing = 4
                
                imgView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    imgView.widthAnchor.constraint(equalToConstant: 30),
                    imgView.heightAnchor.constraint(equalToConstant: 30)
                ])
                
                vStack.addArrangedSubview(imgView)
                vStack.addArrangedSubview(nameField)
                vStack.addArrangedSubview(memField)
                
                let box = NSBox()
                box.boxType = .custom
                box.borderWidth = 1
                box.borderColor = NSColor.separatorColor.withAlphaComponent(0.2)
                box.cornerRadius = 10
                box.fillColor = NSColor.unemphasizedSelectedContentBackgroundColor.withAlphaComponent(0.2)
                box.contentView = vStack
                
                vStack.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    vStack.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: 4),
                    vStack.trailingAnchor.constraint(equalTo: box.trailingAnchor, constant: -4),
                    vStack.centerYAnchor.constraint(equalTo: box.centerYAnchor)
                ])
                
                box.translatesAutoresizingMaskIntoConstraints = false
                box.heightAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
                
                rowStack.addArrangedSubview(box)
            }
            
            if apps.count < 5 {
                for _ in 0..<(5 - apps.count) {
                    let empty = NSView()
                    rowStack.addArrangedSubview(empty)
                }
            }
            
            return rowStack
        }
        
        var activeRows: [NSStackView] = []
        
        if topApps.count > 0 {
            let row1 = createRow(apps: Array(topApps.prefix(5)))
            mainStack.addArrangedSubview(row1)
            activeRows.append(row1)
        }
        if topApps.count > 5 {
            let row2 = createRow(apps: Array(topApps.dropFirst(5)))
            mainStack.addArrangedSubview(row2)
            activeRows.append(row2)
        }
        
        for row in activeRows {
            row.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                row.leadingAnchor.constraint(equalTo: mainStack.leadingAnchor),
                row.trailingAnchor.constraint(equalTo: mainStack.trailingAnchor)
            ])
        }
        
        let height: CGFloat = topApps.count > 5 ? 200 : 95
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 550, height: height))
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(mainStack)
        
        NSLayoutConstraint.activate([
            mainStack.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            mainStack.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            mainStack.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            mainStack.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4)
        ])
        
        item.view = container
        return item
    }

    @objc private func toolbarButtonClicked(_ sender: NSButton) {
        let segment = sender.tag
        
        // Close menu manually since custom views don't dismiss it
        statusItem.menu?.cancelTracking()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            switch segment {
            case 0: self.openMainGemini()
            case 1: self.openProfile()
            case 2: self.openSkills()
            case 3: self.openWorkflows()
            case 4: self.handleSetupWizard()
            case 5: self.restartAndReload()
            case 6: self.fullCleanup()
            default: break
            }
        }
    }

    private func makeModelsHorizontalItem(models: [ModelQuota]) -> NSMenuItem {
        let item = NSMenuItem()
        let stackView = NSStackView()
        stackView.orientation = .horizontal
        stackView.distribution = .fillEqually
        stackView.spacing = 8
        
        for model in models {
            let pct = Int(model.remainingPercentage)
            let icon: String
            if pct == 100 { icon = "⚪️" }
            else if pct >= 80 { icon = "🟢" }
            else if pct >= 60 { icon = "🟡" }
            else if pct >= 40 { icon = "🟠" }
            else { icon = "🔴" }
            
            let cleanLabel = model.label
                .replacingOccurrences(of: " (Thinking)", with: "")
                .replacingOccurrences(of: " (Medium)", with: "")
            
            var vendor = ""
            var tier = ""
            if cleanLabel.hasPrefix("Gemini ") {
                vendor = "Gemini"
                tier = cleanLabel.replacingOccurrences(of: "Gemini ", with: "")
            } else if cleanLabel.hasPrefix("Claude ") {
                vendor = "Claude"
                tier = cleanLabel.replacingOccurrences(of: "Claude ", with: "")
            } else if cleanLabel.hasPrefix("GPT-OSS ") {
                vendor = "GPT-OSS"
                tier = cleanLabel.replacingOccurrences(of: "GPT-OSS ", with: "")
            } else {
                let parts = cleanLabel.split(separator: " ", maxSplits: 1)
                vendor = String(parts.first ?? "")
                tier = parts.count > 1 ? String(parts[1]) : ""
            }
            
            if tier == "Sonnet 4.6" { tier = "Sonnet" }
            if tier == "Opus 4.6" { tier = "Opus" }
            
            var vendorColor: NSColor = .secondaryLabelColor
            if vendor == "Gemini" { vendorColor = .systemBlue }
            else if vendor == "Claude" { vendorColor = .systemOrange }
            else if vendor == "GPT-OSS" { vendorColor = .systemGreen }
            
            let vendorField = createLabel(NSAttributedString(string: vendor.uppercased(), attributes: [
                .font: NSFont.systemFont(ofSize: 9, weight: .bold),
                .foregroundColor: vendorColor.withAlphaComponent(0.9)
            ]))
            
            let tierField = createLabel(NSAttributedString(string: tier, attributes: [
                .font: NSFont.systemFont(ofSize: 12, weight: .heavy),
                .foregroundColor: NSColor.labelColor
            ]))
            
            let pctField = createLabel(NSAttributedString(string: "\(icon) \(pct)%", attributes: [
                .font: NSFont.monospacedDigitSystemFont(ofSize: 11, weight: .medium),
                .foregroundColor: NSColor.labelColor
            ]))
            
            let timeField = createLabel(NSAttributedString(string: model.timeUntilReset, attributes: [
                .font: NSFont.monospacedDigitSystemFont(ofSize: 10, weight: .medium),
                .foregroundColor: NSColor.tertiaryLabelColor
            ]))
            
            let vStack = NSStackView()
            vStack.orientation = .vertical
            vStack.alignment = .centerX
            vStack.spacing = 1
            
            vStack.addArrangedSubview(vendorField)
            vStack.addArrangedSubview(tierField)
            vStack.addArrangedSubview(pctField)
            vStack.addArrangedSubview(timeField)
            
            vStack.setCustomSpacing(4, after: tierField)
            vStack.setCustomSpacing(2, after: pctField)
            
            let box = NSBox()
            box.boxType = .custom
            box.borderWidth = 1
            box.borderColor = NSColor.separatorColor.withAlphaComponent(0.2)
            box.cornerRadius = 8
            box.fillColor = NSColor.unemphasizedSelectedContentBackgroundColor.withAlphaComponent(0.3)
            box.contentView = vStack
            
            vStack.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                vStack.leadingAnchor.constraint(equalTo: box.leadingAnchor, constant: 4),
                vStack.trailingAnchor.constraint(equalTo: box.trailingAnchor, constant: -4),
                vStack.topAnchor.constraint(equalTo: box.topAnchor, constant: 8),
                vStack.bottomAnchor.constraint(equalTo: box.bottomAnchor, constant: -8)
            ])
            
            stackView.addArrangedSubview(box)
        }
        
        let container = NSView(frame: NSRect(x: 0, y: 0, width: 550, height: 85))
        stackView.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            stackView.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            stackView.topAnchor.constraint(equalTo: container.topAnchor, constant: 4),
            stackView.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -4)
        ])
        
        item.view = container
        return item
    }

    // MARK: - Actions

    @objc private func openMainGemini() { openInAntigravity(EnvPaths.geminiDir + "/GEMINI.md") }
    @objc private func openProfile() { openInAntigravity(EnvPaths.antigravityDir + "/knowledge/user_ecosystem_profile/artifacts/PROFILE.md") }
    @objc private func openSkills() { openInAntigravity(EnvPaths.antigravityDir + "/skills") }
    @objc private func openWorkflows() { openInAntigravity(EnvPaths.antigravityDir + "/global_workflows") }

    @objc private func handleSetupWizard() {
        let profilePath = EnvPaths.antigravityDir + "/knowledge/user_ecosystem_profile/metadata.json"
        if FileManager.default.fileExists(atPath: profilePath) {
            TerminalHelper.autoConfigureEcosystem()
        } else {
            WizardWindowController.shared.showWindow()
        }
    }

    private func checkAndShowSetupWizard() {
        let profilePath = EnvPaths.antigravityDir + "/knowledge/user_ecosystem_profile/metadata.json"
        if !FileManager.default.fileExists(atPath: profilePath) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                WizardWindowController.shared.showWindow()
            }
        }
    }

    // MARK: - Unified Utilities

    @objc private func restartAndReload() {
        TerminalHelper.sendAntigravityCommand("antigravity.restartLanguageServer")
        TerminalHelper.sendAntigravityCommand("antigravity.restartUserStatusUpdater")
        TerminalHelper.sendAntigravityCommand("workbench.action.reloadWindow")
    }

    @objc private func fullCleanup() {
        let alert = NSAlert()
        alert.messageText = "Full Cleanup?"
        alert.informativeText = "Cache, Brain, and Recordings will be cleared. (Knowledge is preserved)."
        alert.alertStyle = .warning
        alert.addButton(withTitle: "Clear All")
        alert.addButton(withTitle: "Cancel")
        if alert.runModal() == .alertFirstButtonReturn {
            api.clearCache()
            api.clearBrain()
            api.clearRecordings()
            fetchAndUpdate()
        }
    }

    @objc private func quitApp() { NSApp.terminate(nil) }

    private func openInAntigravity(_ path: String) {
        let url = URL(fileURLWithPath: path)
        let config = NSWorkspace.OpenConfiguration()
        let bundleIDs = [
            "com.google.antigravity",
            "com.google.android.studio.antigravity",
            "com.todesktop.241115phmt2hfaz"
        ]
        for bid in bundleIDs {
            if let appUrl = NSWorkspace.shared.urlForApplication(withBundleIdentifier: bid) {
                NSWorkspace.shared.open([url], withApplicationAt: appUrl, configuration: config)
                return
            }
        }
        NSWorkspace.shared.open(url)
    }
}
