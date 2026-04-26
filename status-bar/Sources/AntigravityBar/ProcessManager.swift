import Foundation

struct ProcessItem: Identifiable {
    let id = UUID()
    let pid: Int
    let rssKB: Int
    let name: String
    let appName: String
    let appPath: String
    let isSystem: Bool
}

struct AppGroup: Identifiable {
    let id: String // appName
    let appName: String
    let appPath: String
    var totalRssKB: Int
    var processes: [ProcessItem]
    
    var isSystemGroup: Bool {
        return processes.allSatisfy { $0.isSystem }
    }
}

class ProcessManager {
    static func getTopProcesses() -> [AppGroup] {
        let task = Process()
        task.launchPath = "/bin/ps"
        task.arguments = ["-axm", "-o", "pid,rss,comm"]
        
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = FileHandle.nullDevice
        
        do {
            try task.run()
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            guard let output = String(data: data, encoding: .utf8) else { return [] }
            
            var allProcesses: [ProcessItem] = []
            
            let lines = output.components(separatedBy: .newlines).dropFirst() // skip header
            for line in lines {
                let trimmed = line.trimmingCharacters(in: .whitespaces)
                if trimmed.isEmpty { continue }
                
                let components = trimmed.split(separator: " ", maxSplits: 2)
                if components.count == 3,
                   let pid = Int(components[0]),
                   let rss = Int(components[1]) {
                    let comm = String(components[2])
                    let name = (comm as NSString).lastPathComponent
                    
                    var realPath = comm
                    var pathBuffer = [CChar](repeating: 0, count: Int(4096))
                    let pathLen = proc_pidpath(Int32(pid), &pathBuffer, UInt32(pathBuffer.count))
                    if pathLen > 0 {
                        realPath = String(cString: pathBuffer)
                    }
                    
                    var isSystem = (realPath.hasPrefix("/System/") || 
                                    realPath.hasPrefix("/usr/") || 
                                    realPath.hasPrefix("/sbin/") || 
                                    realPath.hasPrefix("/bin/") ||
                                    realPath.hasPrefix("/Library/Apple/")) 
                                   && !realPath.hasPrefix("/usr/local/")
                    
                    if realPath.contains("Safari.app") {
                        isSystem = false
                    }
                    
                    var appName = name
                    var appPath = realPath
                    if isSystem {
                        appName = "macOS System"
                    } else if let appRange = realPath.range(of: ".app/") {
                        let prefix = realPath[..<appRange.lowerBound]
                        appName = (prefix as NSString).lastPathComponent + ".app"
                        appPath = String(prefix) + ".app"
                    } else if comm.contains("Helper") {
                        if let firstWord = appName.split(separator: " ").first {
                            appName = String(firstWord)
                        }
                    }
                    
                    allProcesses.append(ProcessItem(pid: pid, rssKB: rss, name: name, appName: appName, appPath: appPath, isSystem: isSystem))
                }
            }
            
            var grouped: [String: [ProcessItem]] = [:]
            for p in allProcesses {
                var groupName = p.appName
                if groupName.hasSuffix(".app") {
                    groupName = String(groupName.dropLast(4))
                }
                grouped[groupName, default: []].append(p)
            }
            
            var groups: [AppGroup] = grouped.map { (key, value) in
                let total = value.reduce(0) { $0 + $1.rssKB }
                let sortedProcesses = value.sorted { $0.rssKB > $1.rssKB }
                let path = sortedProcesses.first?.appPath ?? ""
                return AppGroup(id: key, appName: key, appPath: path, totalRssKB: total, processes: sortedProcesses)
            }
            
            groups.sort { $0.totalRssKB > $1.totalRssKB }
            return Array(groups.prefix(20))
            
        } catch {
            return []
        }
    }
    
    static func formatMemory(_ kb: Int) -> String {
        let mb = Double(kb) / 1024.0
        if mb >= 1024 {
            return String(format: "%.1f GB", mb / 1024.0)
        }
        return String(format: "%.0f MB", mb)
    }
    
    static func killProcess(pid: Int) {
        kill(pid_t(pid), SIGTERM)
    }
}
