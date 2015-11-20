import Foundation
import UIKit
import Quick
import Nimble

import TableViewModel

class TableViewSpec: QuickSpec {
    override func spec() {
        describe("table view bound to a 'TableViewModel'") {

            context("when it is initialized with a 'TableViewModel'") {
                var tableView: UITableView!
                var view: UIView!
                var viewController: UIViewController!
                var model: TableViewModel!

                beforeEach {
                    view = UIView()
                    view.frame = UIScreen.mainScreen().bounds

                    viewController = UIViewController()
                    viewController.view = view

                    tableView = UITableView()
                    tableView.frame = view.bounds;
                    view.addSubview(tableView)

                    model = TableViewModel(tableView: tableView)

                    ViewControllerTestingHelper.pushViewController(viewController)
                }

                it("doesn't have any sections") {
                    expect(tableView.numberOfSections) == 0
                }

                context("when a section is added to the model") {

                    var section: TableSection!

                    beforeEach {
                        section = TableSection(tableViewModel: model)
                        model.addSection(section)
                    }

                    it("has 1 section") {
                        expect(tableView.numberOfSections) == 1
                    }

                    context("when another section is added to the model") {
                        var section2: TableSection!

                        beforeEach {
                            section2 = TableSection(tableViewModel: model)
                            model.addSection(section2)
                        }

                        it("has 2 sections") {
                            expect(tableView.numberOfSections) == 2
                        }
                    }

                    context("when the section is removed from model") {
                        beforeEach {
                            model.removeSection(section)
                        }

                        it("has 0 sections") {
                            expect(tableView.numberOfSections) == 0
                        }
                    }

                    context("when a row is added to the section") {

                        var row1: TableRow!

                        beforeEach {
                            row1 = TableRow(nibName: "SampleCell1", inBundle: NSBundle(forClass: self.dynamicType))
                            section.addRow(row1)
                        }

                        it("has 1 cell in section") {
                            expect(tableView.numberOfRowsInSection(0)) == 1
                        }

                        it("has the correct cell") {
                            let cell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
                            expect(cell).to(beASampleCell1())
                        }

                        context("when another row is added to the section") {
                            var row2: TableRow!

                            beforeEach {
                                row2 = TableRow(nibName: "SampleCell1", inBundle: NSBundle(forClass: self.dynamicType))
                                section.addRow(row2)
                            }

                            it("has 2 cells in section") {
                                expect(tableView.numberOfRowsInSection(0)) == 2
                            }

                            it("has the correct cells") {
                                let cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
                                let cell2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))
                                expect(cell1).to(beASampleCell1())
                                expect(cell2).to(beASampleCell1())
                                expect(cell1) !== cell2
                            }

                            context("when the first row is removed") {
                                var cell1, cell2: UITableViewCell!

                                beforeEach {
                                    cell1 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
                                    cell2 = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 1, inSection: 0))

                                    section.removeRow(row1)
                                }

                                it("has 1 cell") {
                                    expect(tableView.numberOfRowsInSection(0)) == 1
                                }

                                it("has the correct cell") {
                                    let actualCell = tableView.cellForRowAtIndexPath(NSIndexPath(forRow: 0, inSection: 0))
                                    expect(actualCell) === cell2
                                }
                            }
                        }
                    }
                }
            }

        }
    }
}

func beASampleCell1<T:UITableViewCell>() -> MatcherFunc<T?> {
    return MatcherFunc {
        actualExpression, failureMessage in
        failureMessage.postfixMessage = " be a SampleCell1"
        do {
            let cell = try actualExpression.evaluate() as! UITableViewCell
            let label = cell.contentView.subviews[0] as! UILabel
            return label.text == "SampleCell1"
        } catch {
            return false
        }
    }
}
