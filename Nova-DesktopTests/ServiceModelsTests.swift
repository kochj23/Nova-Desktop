// ServiceModelsTests.swift — Nova Desktop
// Unit tests for service model types and state logic.
// Written by Jordan Koch.

import XCTest
@testable import Nova_Desktop

final class ServiceModelsTests: XCTestCase {

    // MARK: - ServiceState

    func testServiceStateRawValues() {
        XCTAssertEqual(ServiceState.online.rawValue, "Online")
        XCTAssertEqual(ServiceState.degraded.rawValue, "Degraded")
        XCTAssertEqual(ServiceState.offline.rawValue, "Offline")
        XCTAssertEqual(ServiceState.unknown.rawValue, "Unknown")
    }

    func testServiceStateEquatable() {
        XCTAssertEqual(ServiceState.online, ServiceState.online)
        XCTAssertNotEqual(ServiceState.online, ServiceState.offline)
    }

    // MARK: - MonitoredService

    func testMonitoredServiceDefaults() {
        let svc = MonitoredService(id: "test", name: "Test Service", icon: "gear", port: 8080)
        XCTAssertEqual(svc.id, "test")
        XCTAssertEqual(svc.name, "Test Service")
        XCTAssertEqual(svc.icon, "gear")
        XCTAssertEqual(svc.port, 8080)
        XCTAssertEqual(svc.state, .unknown)
        XCTAssertEqual(svc.detail, "")
        XCTAssertNil(svc.latencyMs)
        XCTAssertNil(svc.startAction)
        XCTAssertNil(svc.stopAction)
        XCTAssertNil(svc.openAction)
    }

    func testMonitoredServiceNilPort() {
        let svc = MonitoredService(id: "cloud", name: "Cloud Service", icon: "cloud", port: nil)
        XCTAssertNil(svc.port)
    }

    func testMonitoredServiceIdentifiable() {
        let svc1 = MonitoredService(id: "a", name: "A", icon: "a", port: 1)
        let svc2 = MonitoredService(id: "b", name: "B", icon: "b", port: 2)
        XCTAssertNotEqual(svc1.id, svc2.id)
    }

    func testMonitoredServiceWithActions() {
        let svc = MonitoredService(
            id: "ollama", name: "Ollama", icon: "cpu.fill", port: 11434,
            startAction: .shell(command: "ollama serve &"),
            stopAction: .shell(command: "pkill ollama"),
            openAction: .openURL(url: "http://127.0.0.1:11434")
        )
        XCTAssertNotNil(svc.startAction)
        XCTAssertNotNil(svc.stopAction)
        XCTAssertNotNil(svc.openAction)
    }

    // MARK: - OpenClawStatus

    func testOpenClawStatusDefaults() {
        let status = OpenClawStatus()
        XCTAssertFalse(status.gatewayOnline)
        XCTAssertEqual(status.gatewayVersion, "—")
        XCTAssertEqual(status.activeSessions, 0)
        XCTAssertFalse(status.memoryServerOnline)
        XCTAssertEqual(status.memoriesCount, 0)
        XCTAssertFalse(status.slackConnected)
        XCTAssertEqual(status.currentModel, "—")
        XCTAssertEqual(status.uptimeSeconds, 0)
        XCTAssertTrue(status.cronJobs.isEmpty)
        XCTAssertEqual(status.memoryBackend, "postgresql+pgvector")
        XCTAssertFalse(status.redisOnline)
        XCTAssertEqual(status.memoryQueueDepth, 0)
        XCTAssertFalse(status.memorySearchEndpoint)
    }

    // MARK: - CronJobStatus

    func testCronJobStatusStateColor() {
        let okJob = CronJobStatus(id: "1", name: "test", schedule: "*/5", state: "ok",
                                  lastRun: "now", nextRun: "5m", consecutiveErrors: 0, target: "main")
        XCTAssertEqual(okJob.stateColor, "green")

        let errorJob = CronJobStatus(id: "2", name: "bad", schedule: "*/5", state: "error",
                                     lastRun: "now", nextRun: "5m", consecutiveErrors: 3, target: "main")
        XCTAssertEqual(errorJob.stateColor, "red")

        let runningJob = CronJobStatus(id: "3", name: "run", schedule: "*/5", state: "running",
                                       lastRun: "now", nextRun: "5m", consecutiveErrors: 0, target: "main")
        XCTAssertEqual(runningJob.stateColor, "cyan")

        let skippedJob = CronJobStatus(id: "4", name: "skip", schedule: "*/5", state: "skipped",
                                       lastRun: "now", nextRun: "5m", consecutiveErrors: 0, target: "main")
        XCTAssertEqual(skippedJob.stateColor, "yellow")
    }

    // MARK: - GitHubRepoStatus

    func testGitHubRepoStatusIdIsFullName() {
        var repo = GitHubRepoStatus(name: "Nova-Desktop", fullName: "kochj23/Nova-Desktop")
        XCTAssertEqual(repo.id, "kochj23/Nova-Desktop")
        XCTAssertEqual(repo.openIssues, 0)
        XCTAssertEqual(repo.openPRs, 0)
        XCTAssertEqual(repo.stars, 0)
        XCTAssertFalse(repo.isPrivate)
        XCTAssertEqual(repo.defaultBranch, "main")
        XCTAssertEqual(repo.lastCommitMessage, "—")
        XCTAssertNil(repo.lastCommitDate)
    }

    // MARK: - NovaActivityStatus

    func testNovaActivityStatusDefaults() {
        let activity = NovaActivityStatus()
        XCTAssertFalse(activity.slackOnline)
        XCTAssertNil(activity.lastSlackMessageDate)
        XCTAssertEqual(activity.emailUnreadCount, 0)
        XCTAssertNil(activity.lastEmailCheck)
        XCTAssertNil(activity.lastCronRun)
        XCTAssertEqual(activity.cronErrorCount, 0)
        XCTAssertEqual(activity.activeSessions, 0)
    }

    // MARK: - SystemStats

    func testSystemStatsDefaults() {
        let stats = SystemStats()
        XCTAssertEqual(stats.cpuPercent, 0)
        XCTAssertEqual(stats.ramPercent, 0)
        XCTAssertEqual(stats.diskReadMBs, 0)
        XCTAssertEqual(stats.diskWriteMBs, 0)
        XCTAssertEqual(stats.uptimeSeconds, 0)
    }

    // MARK: - OllamaModel

    func testOllamaModelIdIsName() {
        let model = OllamaModel(name: "qwen3:30b", size: "16.5GB", modified: "2025-04-01")
        XCTAssertEqual(model.id, "qwen3:30b")
        XCTAssertEqual(model.name, "qwen3:30b")
        XCTAssertEqual(model.size, "16.5GB")
    }
}
