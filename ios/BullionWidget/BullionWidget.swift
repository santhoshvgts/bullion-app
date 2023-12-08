//
//  BullionWidget.swift
//  BullionWidget
//
//  Created by Anantha Eswar on 30/11/23.
//

import WidgetKit
import SwiftUI

private let widgetGroupId = "<APP GROUP ID>"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SpotPriceEntry {
        SpotPriceEntry(date: Date(), title: "Spot Price", description: "The Gold price has increased by 2%")
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SpotPriceEntry) -> ()) {
        let entry : SpotPriceEntry
        if context.isPreview{
            entry = placeholder(in: context)
        } else {
            let userDefaults = UserDefaults(suiteName: widgetGroupId)
            let title = userDefaults?.string(forKey: "headline_title") ?? "Bullion"
            let description = userDefaults?.string(forKey: "headline_description") ?? "Open the App to update"
            entry = SpotPriceEntry(date: Date(), title: title, description: description)
        }
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        getSnapshot(in: context) { (entry) in
          let timeline = Timeline(entries: [entry], policy: .atEnd)
                    completion(timeline)
                }
    }
}

struct SpotPriceEntry: TimelineEntry {
    let date: Date
    let title: String
    let description: String
}

struct BullionWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        
        ZStack {

            Color("#FBEEEC")
                .edgesIgnoringSafeArea(.all)
            
            Image("bull_logo")
                .resizable()
                .frame(width: 112, height: 112)
                .padding(16)
                .opacity(0.1)
            
            VStack {
                
                Text(entry.title)
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .font(.system(size: 20))
                    .padding(.leading, 8)
                    .padding(.top, 8)
                
                Text(entry.description)
                    .foregroundColor(.black)
                    .font(.system(size: 16))
                    .padding(.leading, 8)
                    .padding(.top, 4)
                
            }
            
        }
        .cornerRadius(10)
        .shadow(radius: 10)
    }
}

struct BullionWidget: Widget {
    let kind: String = "BullionWidget"
    
    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            if #available(iOS 17.0, *) {
                BullionWidgetEntryView(entry: entry)
                    .containerBackground(.fill.tertiary, for: .widget)
            } else {
                BullionWidgetEntryView(entry: entry)
                    .padding()
                    .background()
            }
        }
        .configurationDisplayName("Bullion Widget")
        .description("Check the latest news and alerts")
    }
}

#Preview(as: .systemSmall) {
    BullionWidget()
} timeline: {
    SpotPriceEntry(date: .now, title: "Title", description: "Description")
}

