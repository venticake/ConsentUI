import XCTest
@testable import ConsentUI

final class RegionCheckerTests: XCTestCase {

    func testEEACountriesContainsExpectedCountries() {
        // EU countries
        XCTAssertTrue(RegionChecker.eeaCountries.contains("DE")) // Germany
        XCTAssertTrue(RegionChecker.eeaCountries.contains("FR")) // France
        XCTAssertTrue(RegionChecker.eeaCountries.contains("IT")) // Italy
        XCTAssertTrue(RegionChecker.eeaCountries.contains("ES")) // Spain

        // EFTA countries
        XCTAssertTrue(RegionChecker.eeaCountries.contains("NO")) // Norway
        XCTAssertTrue(RegionChecker.eeaCountries.contains("IS")) // Iceland
        XCTAssertTrue(RegionChecker.eeaCountries.contains("LI")) // Liechtenstein

        // UK
        XCTAssertTrue(RegionChecker.eeaCountries.contains("GB"))
    }

    func testNonEEACountriesNotIncluded() {
        XCTAssertFalse(RegionChecker.eeaCountries.contains("US"))
        XCTAssertFalse(RegionChecker.eeaCountries.contains("CA"))
        XCTAssertFalse(RegionChecker.eeaCountries.contains("JP"))
        XCTAssertFalse(RegionChecker.eeaCountries.contains("CN"))
        XCTAssertFalse(RegionChecker.eeaCountries.contains("KR"))
        XCTAssertFalse(RegionChecker.eeaCountries.contains("AU"))
    }

    func testEEACountriesCount() {
        // 27 EU + 3 EFTA + 1 UK = 31 countries
        XCTAssertEqual(RegionChecker.eeaCountries.count, 31)
    }
}
