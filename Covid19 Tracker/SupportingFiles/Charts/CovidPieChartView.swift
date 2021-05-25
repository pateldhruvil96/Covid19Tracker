//
//  CovidPieChartView.swift
//  Covid19 Tracker
//
//  Created by Dhruvil Rameshbhaib Patel on 23/05/21.
//

import UIKit
import Charts

final class CovidPieChartView: PieChartView {
    override var isDrawEntryLabelsEnabled: Bool {
        return false
    }
    
    override var isRotationEnabled: Bool {
        return false
    }
    
    override var isDrawMarkersEnabled: Bool {
        return false
    }
    
    override var isDrawCenterTextEnabled: Bool {
        return false
    }
    
    override var isHighLightPerTapEnabled: Bool {
        return false
    }
    
    override var isUsePercentValuesEnabled: Bool {
        return false
    }
    
    override var isDragDecelerationEnabled: Bool {
        return false
    }
    
    override var legendRenderer: LegendRenderer! {
        let vph = ViewPortHandler(width: 0, height: 0)
        return LegendRenderer(viewPortHandler: vph, legend: nil)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        self.holeRadiusPercent = 0.80
        
        self.transparentCircleColor = Color.white
        self.transparentCircleRadiusPercent = 0.83
        
        let desc = Description()
        desc.enabled = false
        self.chartDescription = desc
        
        self.drawEntryLabelsEnabled = false
        setExtraOffsets(left: 0, top: 0, right: 0, bottom: 0)
        
        highlightValues(nil)
        isUserInteractionEnabled = false
    }
}

