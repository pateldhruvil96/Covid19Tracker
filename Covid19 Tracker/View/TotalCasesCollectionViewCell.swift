//
//  TotalCasesCollectionViewCell.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Rameshbhaib Patel on 23/05/21.
//

import UIKit
import Charts

class TotalCasesCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var circularView: CovidPieChartView!
    @IBOutlet weak var activeTitleValueLabel: UILabel!
    @IBOutlet weak var recoveredTitleValueLabel: UILabel!
    @IBOutlet weak var fatalTitleValueLabel: UILabel!
    @IBOutlet weak var totalCasesTitleValue: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.layer.cornerRadius = 20
    }
    func setup(timeline: Timeline) {
        setupPieChart(timeline: timeline)
        totalCasesTitleValue.text = timeline.cases.decimalFormat

        activeTitleValueLabel.text = timeline.active.decimalFormat
        recoveredTitleValueLabel.text = timeline.recovered.decimalFormat
        fatalTitleValueLabel.text = timeline.deaths.decimalFormat
    }
    private func setupPieChart(timeline: Timeline) {
        var entries: [PieChartDataEntry] = []

        let entry1 = PieChartDataEntry(value: Double(timeline.active))
        entries.append(entry1)

        let entry2 = PieChartDataEntry(value: Double(timeline.recovered))
        entries.append(entry2)

        let entry3 = PieChartDataEntry(value: Double(timeline.deaths))
        entries.append(entry3)

        let set = PieChartDataSet(entries: entries)
        set.highlightEnabled = false
        set.drawValuesEnabled = false
        set.label = nil
        set.entryLabelColor = .clear
        set.setColors(Color.yellowLight, Color.greenDark, Color.black)

        let data = PieChartData(dataSet: set)
        circularView.data = data
    }

}
