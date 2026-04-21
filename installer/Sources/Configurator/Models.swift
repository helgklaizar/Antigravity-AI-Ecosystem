import Foundation

// MARK: - AI Tool

enum AITool: String, CaseIterable, Codable, Identifiable {
    case antigravity = "antigravity"
    case claude = "claude"
    case cursor = "cursor"
    case copilot = "copilot"
    case windsurf = "windsurf"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .antigravity: return "Antigravity (Gemini)"
        case .claude: return "Claude"
        case .cursor: return "Cursor"
        case .copilot: return "GitHub Copilot"
        case .windsurf: return "Windsurf"
        }
    }

    var icon: String {
        switch self {
        case .antigravity: return "🟣"
        case .claude: return "🟠"
        case .cursor: return "🔵"
        case .copilot: return "🤖"
        case .windsurf: return "🏄‍♂️"
        }
    }

    /// Files this tool generates at project root
    var projectRootFiles: [String] {
        switch self {
        case .antigravity: return ["GEMINI.md", "AGENTS.md", "DESIGN.md"]
        case .claude:      return ["CLAUDE.md", "AGENTS.md", "DESIGN.md"]
        case .cursor:      return [".cursorrules", ".cursorignore", "DESIGN.md"]
        case .copilot:     return [".github/copilot-instructions.md", "DESIGN.md"]
        case .windsurf:    return [".windsurfrules", "DESIGN.md"]
        }
    }
}

// MARK: - Profession Category

enum ProfessionCategory: String, CaseIterable, Identifiable {
    case software = "Software Development"
    case data = "Data & AI"
    case securityQa = "Security & QA"
    case creative = "Design & Creative"
    case management = "Management & Biz"
    case research = "Research & Academia"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .software: return "💻"
        case .data: return "🧠"
        case .securityQa: return "🛡️"
        case .creative: return "🎨"
        case .management: return "💼"
        case .research: return "🔬"
        }
    }
    
    var professions: [Profession] {
        switch self {
        case .software: return [.frontendDev, .backendDev, .fullstackDev, .iosDevs, .androidDev, .gameDev, .devops]
        case .data: return [.mlEngineer, .dataScientist]
        case .securityQa: return [.securityEng, .qaEng]
        case .creative: return [.designer]
        case .management: return [.productMgr, .indieHacker]
        case .research: return [.researcher]
        }
    }
}

// MARK: - Profession

enum Profession: String, CaseIterable, Codable, Identifiable {
    case frontendDev    = "frontend"
    case backendDev     = "backend"
    case fullstackDev   = "fullstack"
    case mlEngineer     = "ml_engineer"
    case dataScientist  = "data_scientist"
    case iosDevs        = "ios_macos"
    case androidDev     = "android"
    case gameDev        = "gamedev"
    case devops         = "devops"
    case securityEng    = "security"
    case qaEng          = "qa"
    case designer       = "designer"
    case productMgr     = "product_mgr"
    case researcher     = "researcher"
    case indieHacker    = "indie_hacker"

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .frontendDev:  return "Frontend Developer"
        case .backendDev:   return "Backend Developer"
        case .fullstackDev: return "Full-stack Developer"
        case .mlEngineer:   return "ML / AI Engineer"
        case .dataScientist:return "Data Scientist / Analyst"
        case .iosDevs:      return "iOS / macOS Developer"
        case .androidDev:   return "Android Developer"
        case .gameDev:      return "Game Developer"
        case .devops:       return "DevOps / SRE"
        case .securityEng:  return "Security Engineer"
        case .qaEng:        return "QA / Test Engineer"
        case .designer:     return "UI / UX Designer"
        case .productMgr:   return "Product Manager"
        case .researcher:   return "Researcher / Academic"
        case .indieHacker:  return "Indie Hacker"
        }
    }

    var icon: String {
        switch self {
        case .frontendDev:  return "🎨"
        case .backendDev:   return "⚙️"
        case .fullstackDev: return "🔄"
        case .mlEngineer:   return "🧠"
        case .dataScientist:return "📊"
        case .iosDevs:      return "🍎"
        case .androidDev:   return "🤖"
        case .gameDev:      return "🎮"
        case .devops:       return "🛠"
        case .securityEng:  return "🛡️"
        case .qaEng:        return "🧪"
        case .designer:     return "✏️"
        case .productMgr:   return "📋"
        case .researcher:   return "🎓"
        case .indieHacker:  return "🚀"
        }
    }

    var stack: String {
        switch self {
        case .frontendDev:  return "TypeScript, React/Vue, CSS, Vite"
        case .backendDev:   return "Node.js / Python, PostgreSQL, Docker, REST/gRPC"
        case .fullstackDev: return "TypeScript, React, Node.js, PostgreSQL"
        case .mlEngineer:   return "Python, MLX, Metal, PyTorch, uv"
        case .dataScientist:return "Python, Pandas, Jupyter, SQL"
        case .iosDevs:      return "Swift, SwiftUI, XCTest, SPM"
        case .androidDev:   return "Kotlin, Compose, Android Studio"
        case .gameDev:      return "C#, Unity / C++, Unreal"
        case .devops:       return "Docker, K8s, Terraform, GitHub Actions, Bash"
        case .securityEng:  return "Python, Bash, Kali, Wireshark, OWASP"
        case .qaEng:        return "Playwright, Selenium, XCTest, Jest"
        case .designer:     return "Figma, CSS, Design Systems, Tokens"
        case .productMgr:   return "Jira, Notion, Linear, Figma"
        case .researcher:   return "LaTeX, Python, R, Jupyter"
        case .indieHacker:  return "Next.js, Supabase, Vercel, Stripe"
        }
    }

    /// Agents to install at workspace-level .gemini/agents/
    var workspaceAgents: [AgentTemplate] {
        let common: [AgentTemplate] = [.architect, .developer, .tester]
        switch self {
        case .frontendDev:  return common + [.uiSpecialist, .i18nMaster]
        case .backendDev:   return common + [.devops, .zeroDayDefender]
        case .fullstackDev: return common + [.devops, .uiSpecialist]
        case .mlEngineer:   return common + [.mlxSpecialist, .quantAnalyst]
        case .dataScientist:return common + [.quantAnalyst]
        case .iosDevs:      return common + [.iosSpecialist, .zeroDayDefender]
        case .androidDev:   return common + [.uiSpecialist, .zeroDayDefender]
        case .gameDev:      return common + [.developer, .tester]
        case .devops:       return [.architect, .devops, .zeroDayDefender]
        case .securityEng:  return [.architect, .tester, .zeroDayDefender]
        case .qaEng:        return [.tester, .devops]
        case .designer:     return [.developer, .uiSpecialist]
        case .productMgr:   return [.architect, .tester]
        case .researcher:   return [.architect, .developer]
        case .indieHacker:  return common + [.uiSpecialist, .devops]
        }
    }

    /// Global workflows relevant to this profession
    var relevantWorkflows: [String] {
        switch self {
        case .frontendDev:  return ["ui-prototyping", "ui-spec-to-code", "qa-orchestrator", "new-project"]
        case .backendDev:   return ["new-project", "safe-prod-sync", "pentest-qa", "self-healing-loop"]
        case .fullstackDev: return ["new-project", "ui-prototyping", "safe-prod-sync", "qa-orchestrator"]
        case .mlEngineer:   return ["mac-port-factory", "quant-laboratory", "new-module", "research-master"]
        case .dataScientist:return ["quant-laboratory", "research-master"]
        case .iosDevs:      return ["new-project", "release-engine", "qa-orchestrator", "crash-detect"]
        case .androidDev:   return ["new-project", "release-engine", "qa-orchestrator", "crash-detect"]
        case .gameDev:      return ["new-project", "crash-detect", "qa-orchestrator"]
        case .devops:       return ["release-engine", "self-healing-loop", "safe-prod-sync", "git-hooks-qa"]
        case .securityEng:  return ["pentest-qa", "issue-triage"]
        case .qaEng:        return ["qa-orchestrator", "pentest-qa", "git-hooks-qa"]
        case .designer:     return ["ui-prototyping", "ui-spec-to-code", "new-project"]
        case .productMgr:   return ["research-master", "issue-triage"]
        case .researcher:   return ["research-master", "llm-wiki-compiler"]
        case .indieHacker:  return ["new-project", "release-engine", "ui-prototyping", "api-integrations"]
        }
    }

    var gitignoreContent: String {
        switch self {
        case .frontendDev, .fullstackDev, .indieHacker:
            return """
            node_modules/
            .next/
            dist/
            .turbo/
            .env
            .env.*
            .DS_Store
            *.log
            """
        case .backendDev, .mlEngineer, .dataScientist, .securityEng, .researcher:
            return """
            __pycache__/
            .venv/
            .env
            .env.*
            *.log
            dist/
            .DS_Store
            *.metallib
            *.bin
            *.csv
            """
        case .iosDevs:
            return """
            .build/
            .swiftpm/
            *.xcuserdata
            *.xcworkspace/xcuserdata/
            DerivedData/
            .DS_Store
            """
        case .androidDev:
            return """
            .gradle/
            build/
            local.properties
            .DS_Store
            """
        case .gameDev:
            return """
            Library/
            Temp/
            Obj/
            Build/
            Builds/
            .DS_Store
            """
        case .devops:
            return """
            .env
            .env.*
            *.tfstate
            *.tfstate.backup
            .terraform/
            .DS_Store
            *.log
            """
        case .designer, .productMgr, .qaEng:
            return """
            node_modules/
            dist/
            .DS_Store
            *.log
            """
        }
    }
}

// MARK: - Agent Templates

enum AgentTemplate: String, CaseIterable, Codable {
    case architect, developer, tester, devops
    case uiSpecialist   = "ui-specialist"
    case i18nMaster     = "i18n-ai-master"
    case zeroDayDefender = "zero-day-defender"
    case mlxSpecialist  = "mlx-specialist"
    case quantAnalyst   = "quant-analyst"
    case iosSpecialist  = "ios-macos-specialist"
    case huxleyCoder    = "huxley-coder"
    case swarmOrchestrator = "swarm-orchestrator"

    var filename: String { "\(rawValue).md" }

    var description: String {
        switch self {
        case .architect:         return "Senior system architect – design, ER diagrams, API contracts"
        case .developer:         return "Core coding agent – implements features per spec"
        case .tester:            return "QA agent – writes and runs tests"
        case .devops:            return "DevOps – CI/CD, Docker, infra automation"
        case .uiSpecialist:      return "UI/UX – design tokens, animations, accessibility"
        case .i18nMaster:        return "i18n AI – translations and locale management"
        case .zeroDayDefender:   return "Security audit – OWASP, vulnerability scanning"
        case .mlxSpecialist:     return "MLX/Metal – Apple Silicon ML optimization"
        case .quantAnalyst:      return "Quant – model quantization and benchmarking"
        case .iosSpecialist:     return "iOS/macOS – SwiftUI, SPM, App Store"
        case .huxleyCoder:       return "Gödel Machine – proof-first high-reliability coding"
        case .swarmOrchestrator: return "Swarm – multi-agent task orchestration"
        }
    }

    func content(for profession: Profession) -> String {
        switch self {
        case .architect:
            return """
            ---
            name: architect
            description: Senior system architect for software design, infrastructure planning, and database modeling.
            ---

            # System Architect

            **Identity**: You are a Lead Software Architect focused on clean architecture, scalability, and robust design for a **\(profession.displayName)** stack (\(profession.stack)).

            ## Core Mandate
            1. Design systems that are loosely coupled and highly cohesive.
            2. Prioritize horizontal scalability and offline-first paradigms when applicable.
            3. Create clear data models and API contracts.
            4. Document high-level design before implementation starts.

            ## Execution Tactics
            - Produce Mermaid diagrams (class, ER, sequence) for visualizing architecture.
            - Identify single points of failure, bottlenecks, and security boundaries.
            - Select the optimal tech stack based on project constraints.

            ## 🔄 System Context Enforcement
            Every time you are invoked, your **very first** line of output MUST be exactly this format:
            `🔄 **Context:** [Agent: architect] | [Skill: None] | [Workflow: None]`
            """

        case .developer:
            return """
            ---
            name: developer
            description: Core coding agent for \(profession.displayName). Stack: \(profession.stack).
            ---

            # Developer Agent

            **Identity**: Senior developer specializing in **\(profession.stack)**.

            ## Rules
            - Write working code only. Finish the job.
            - No features beyond what was asked.
            - Match existing patterns in the codebase.
            - Surgical changes only – touch only what's necessary.

            ## 🔄 System Context Enforcement
            `🔄 **Context:** [Agent: developer] | [Skill: None] | [Workflow: None]`
            """

        case .tester:
            return """
            ---
            name: tester
            description: QA and test automation agent.
            ---

            # Tester Agent

            Write tests first. Make them pass. Never report done based on a plausible-looking diff alone.

            ## Rules
            - Prefer running code to guessing about code.
            - Address root causes, not symptoms.
            - For UI changes: screenshot before, screenshot after.

            ## 🔄 System Context Enforcement
            `🔄 **Context:** [Agent: tester] | [Skill: None] | [Workflow: None]`
            """

        case .mlxSpecialist:
            return """
            ---
            name: mlx-specialist
            description: MLX / Metal performance optimization specialist for Apple Silicon.
            model: sonnet
            ---

            # MLX Specialist

            **Identity**: Expert in Apple Silicon ML acceleration via MLX and Metal.

            ## Core Focus
            - Prioritize `float16` and `bfloat16` for Apple Silicon efficiency.
            - Use `-mlx` suffix naming for all module projects.
            - All modules MUST be defined in `eco.yaml` registry.
            - Run Metal benchmarks to validate performance (High/SOTA status).

            ## 🔄 System Context Enforcement
            `🔄 **Context:** [Agent: mlx-specialist] | [Skill: None] | [Workflow: None]`
            """

        default:
            return """
            ---
            name: \(rawValue)
            description: \(description)
            ---

            # \(rawValue.capitalized) Agent

            Specialized agent for **\(profession.displayName)** projects.

            ## Stack context
            \(profession.stack)

            ## 🔄 System Context Enforcement
            `🔄 **Context:** [Agent: \(rawValue)] | [Skill: None] | [Workflow: None]`
            """
        }
    }
}

// MARK: - User Profile

struct UserProfile: Identifiable, Codable, Hashable {
    var id = UUID()
    var name: String
    var profession: Profession
    var aiTools: [AITool]
    var projectsRootPath: String   // e.g. ~/Documents/PROJECTS
    var onboardingComplete: Bool = false

    var primaryTool: AITool { aiTools.first ?? .antigravity }
}

// MARK: - Deployment Result

struct DeploymentStep: Identifiable {
    let id = UUID()
    let level: String      // "User", "Workspace", "Project"
    let action: String
    var status: StepStatus = .pending

    enum StepStatus {
        case pending, running, done, failed
    }
}

// MARK: - App Store

class AppStore: ObservableObject {
    static let shared = AppStore()
    @Published var profile: UserProfile? {
        didSet { saveProfile() }
    }
    @Published var isOnboardingComplete: Bool = false
    @Published var deploymentSteps: [DeploymentStep] = []

    init() { loadProfile() }

    func saveProfile(_ p: UserProfile) {
        var updated = p
        updated.onboardingComplete = true
        profile = updated
        isOnboardingComplete = true
    }

    private func saveProfile() {
        if let data = try? JSONEncoder().encode(profile) {
            UserDefaults.standard.set(data, forKey: "userProfile_v2")
        }
    }

    private func loadProfile() {
        if let data = UserDefaults.standard.data(forKey: "userProfile_v2"),
           let saved = try? JSONDecoder().decode(UserProfile.self, from: data) {
            profile = saved
            isOnboardingComplete = saved.onboardingComplete
        }
    }

    func reset() {
        profile = nil
        isOnboardingComplete = false
        UserDefaults.standard.removeObject(forKey: "userProfile_v2")
    }
}
