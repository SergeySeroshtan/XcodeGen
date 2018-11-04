import XcodeGenKit
import xcodeproj
import Foundation
import XCTest
import ProjectSpec
import PathKit

class GeneratedPerformanceTests: XCTestCase {

    let basePath = Path.temporary + "XcodeGenPeformanceTests"

    func testGeneration() throws {
        let project = try Project.testProject(basePath: basePath)
        self.measure {
            let generator = ProjectGenerator(project: project)
            _ = try! generator.generateXcodeProject()
        }
    }

    func testWriting() throws {
        let project = try Project.testProject(basePath: basePath)
        let generator = ProjectGenerator(project: project)
        let xcodeProject = try generator.generateXcodeProject()
        self.measure {
            xcodeProject.pbxproj.invalidateUUIDs()
            try! xcodeProject.write(path: project.defaultProjectPath)
        }
    }
}

let fixturePath = Path(#file).parent().parent() + "Fixtures"

class FixturePerformanceTests: XCTestCase {

    let specPath = fixturePath + "TestProject/project.yml"

    func testFixtureDecoding() throws {
        self.measure {
            _ = try! Project(path: specPath)
        }
    }

    func testCacheFileGeneration() throws {
        let specLoader = SpecLoader(version: "1.2")
        _ = try specLoader.loadProject(path: specPath)

        self.measure {
            _ = try! specLoader.generateCacheFile()
        }
    }

    func testFixtureGeneration() throws {
        let project = try Project(path: specPath)
        self.measure {
            let generator = ProjectGenerator(project: project)
            _ = try! generator.generateXcodeProject()
        }
    }

    func testFixtureWriting() throws {
        let project = try Project(path: specPath)
        let generator = ProjectGenerator(project: project)
        let xcodeProject = try generator.generateXcodeProject()
        self.measure {
            xcodeProject.pbxproj.invalidateUUIDs()
            try! xcodeProject.write(path: project.defaultProjectPath)
        }
    }
}
