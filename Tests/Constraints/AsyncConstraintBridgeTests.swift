import XCTest
@testable import Peppermint

final class AsyncConstraintBridgeTests: XCTestCase {

    let constraint = BlockConstraint<String, FakeError> {
        $0 == "validInput"
    } errorBuilder: {
        .Invalid
    }

    func testEvaluateShouldReturnSuccessWhenTheInputIsValid() async throws {
        let sut = constraint.async()
        let result = await sut.evaluate(with: "validInput")
        
        switch result {
        case .success:
            XCTAssertTrue(true)
        default:
            XCTFail()
        }
    }

    func testEvaluateShouldReturnFailureWhenTheInputIsInvalid() async throws {
        let sut = constraint.async()
        let result = await sut.evaluate(with: "invalidInput")
       
        switch result {
        case .failure:
            XCTAssertTrue(true)
        default:
            XCTFail()
        }
    }

    func testCheckShouldReturnTheInputWhenTheInputIsValid() async throws {
        let sut = constraint.async()
        
        do {
            let result = try await sut.check("validInput")
            XCTAssertEqual(result, "validInput")
        } catch {
            XCTFail()
        }
    }

    func testCheckShouldThrowWhenTheInputIsInvalid() async throws {
        let sut = constraint.async()
        
        do {
            let _ = try await sut.check("invalidInput")
            XCTFail()
        } catch let error as Summary<FakeError> {
            XCTAssertEqual(error, Summary<FakeError>(errors: [.Invalid]))
        } catch {
            XCTFail()
        }
    }
}
