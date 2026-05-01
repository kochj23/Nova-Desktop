// DesignSystemTests.swift — Nova Desktop
// Unit tests for the ModernDesign color system and utility functions.
// Written by Jordan Koch.

import XCTest
@testable import Nova_Desktop

final class DesignSystemTests: XCTestCase {

    // MARK: - Status Color Mapping

    func testStatusColorOnline() {
        let color = ModernColors.statusColor(.online)
        XCTAssertEqual(color, ModernColors.statusOnline)
    }

    func testStatusColorDegraded() {
        let color = ModernColors.statusColor(.degraded)
        XCTAssertEqual(color, ModernColors.statusDegraded)
    }

    func testStatusColorOffline() {
        let color = ModernColors.statusColor(.offline)
        XCTAssertEqual(color, ModernColors.statusOffline)
    }

    func testStatusColorUnknown() {
        let color = ModernColors.statusColor(.unknown)
        XCTAssertEqual(color, ModernColors.statusUnknown)
    }

    // MARK: - Heat Map Colors

    func testHeatColorGreen() {
        // Below 30% should be green (status online)
        let color = ModernColors.heatColor(percentage: 15)
        XCTAssertEqual(color, ModernColors.statusOnline)
    }

    func testHeatColorYellow() {
        // 30-60% should be yellow
        let color = ModernColors.heatColor(percentage: 45)
        XCTAssertEqual(color, ModernColors.yellow)
    }

    func testHeatColorOrange() {
        // 60-80% should be orange
        let color = ModernColors.heatColor(percentage: 70)
        XCTAssertEqual(color, ModernColors.orange)
    }

    func testHeatColorRed() {
        // Above 80% should be red (status offline)
        let color = ModernColors.heatColor(percentage: 95)
        XCTAssertEqual(color, ModernColors.statusOffline)
    }

    func testHeatColorBoundaryAt30() {
        // Exactly 30 should be yellow (30..<60)
        let color = ModernColors.heatColor(percentage: 30)
        XCTAssertEqual(color, ModernColors.yellow)
    }

    func testHeatColorBoundaryAt60() {
        // Exactly 60 should be orange (60..<80)
        let color = ModernColors.heatColor(percentage: 60)
        XCTAssertEqual(color, ModernColors.orange)
    }

    func testHeatColorBoundaryAt80() {
        // Exactly 80 should be red (default case)
        let color = ModernColors.heatColor(percentage: 80)
        XCTAssertEqual(color, ModernColors.statusOffline)
    }

    func testHeatColorZero() {
        let color = ModernColors.heatColor(percentage: 0)
        XCTAssertEqual(color, ModernColors.statusOnline)
    }

    func testHeatColorHundred() {
        let color = ModernColors.heatColor(percentage: 100)
        XCTAssertEqual(color, ModernColors.statusOffline)
    }
}
