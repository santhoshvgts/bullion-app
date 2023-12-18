//
//  BullionWidget.swift
//  BullionWidget
//
//  Created by Anantha Eswar on 30/11/23.
//

import WidgetKit
import SwiftUI

private let widgetGroupId = "group.bullion"

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SpotPriceEntry {
        SpotPriceEntry(date: Date(), title: "Spot Price", description: "$2000", priceChanges: "-($6.00) (-0.3%)", filename: "No screenshot available",  displaySize: context.displaySize)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (SpotPriceEntry) -> ()) {
        let entry : SpotPriceEntry
        if context.isPreview{
            entry = placeholder(in: context)
        } else {
            let userDefaults = UserDefaults(suiteName: widgetGroupId)
            let title = userDefaults?.string(forKey: "headline_title") ?? "Bullion"
            let description = userDefaults?.string(forKey: "headline_description") ?? "Open the App to update"
            let priceChanges = userDefaults?.string(forKey: "price_changes") ?? "Open the App to update"
            let filename = userDefaults?.string(forKey: "logoDev") ?? "No screenshot available"
            entry = SpotPriceEntry(date: Date(), title: title, description: description, priceChanges: priceChanges, filename: filename, displaySize: context.displaySize)
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
    let priceChanges: String
    let filename: String
    let displaySize: CGSize
}

struct BullionWidgetEntryView : View {
    var entry: Provider.Entry
    
    var ChartImage: some View {
            if let uiImage = UIImage(contentsOfFile: entry.filename) {
                let image = Image(uiImage: uiImage)
                    .resizable()
                    .frame(width: entry.displaySize.height*0.5, height: entry.displaySize.height*0.5, alignment: .center)
                return AnyView(image)
            }
            print("The image file could not be loaded")
            return AnyView(EmptyView())
        }
    
    var body: some View {
        
        ZStack {

            Color("#FBEEEC")
                .edgesIgnoringSafeArea(.all)
            
            Image("bull_logo")
                .resizable()
                .frame(width: 112, height: 112)
                .padding(16)
                .opacity(0.1)
            
            VStack(alignment: .leading) {
                
                Text(entry.title)
                    .font(.system(size: 13))
                    .fontWeight(.bold)
                    .foregroundColor(Color(red: 118/255, green: 123/255, blue: 134/255))
                    //.background(Color(red: 251/255, green: 238/255, blue: 236/255))
                    .multilineTextAlignment(.leading)
                    .lineLimit(1)
                    .padding(.leading, 8)
                .padding(.top, 8)

                
                
                Text(entry.description)
                        .font(.system(size: 17))
                        .bold()
                        .foregroundColor(.primary)
                        //.background(Color(red: 251/255, green: 238/255, blue: 236/255))
                        .lineLimit(1)
                        .padding(.leading, 8)

                Text(entry.priceChanges)
                        .font(.system(size: 11))
                        .bold()
                        .foregroundColor(Color(red: 205/255, green: 55/255, blue: 55/255))
                        //.background(Color(red: 251/255, green: 238/255, blue: 236/255))
                        .lineLimit(1)
                        .padding(.leading, 8)
                
                ChartImage
                
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

//#Preview(as: .systemSmall) {
//    BullionWidget()
//} timeline: {
//    SpotPriceEntry(date: .now, title: "Title", description: "Description", filename: "filename", displaySize: <#T##CGSize#>)
//}

