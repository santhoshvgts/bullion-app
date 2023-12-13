package com.bullion

import android.appwidget.AppWidgetManager
import android.appwidget.AppWidgetProvider
import android.content.Context
import android.graphics.Bitmap
import android.graphics.BitmapFactory
import android.widget.RemoteViews

import es.antonborri.home_widget.HomeWidgetPlugin
import java.io.File

/**
 * Implementation of App Widget functionality.
 */
class BullionWidget : AppWidgetProvider() {
    override fun onUpdate(
        context: Context,
        appWidgetManager: AppWidgetManager,
        appWidgetIds: IntArray
    ) {
        // There may be multiple widgets active, so update all of them
        for (appWidgetId in appWidgetIds) {
            val widgetData = HomeWidgetPlugin.getData(context)
            val views = RemoteViews(context.packageName, R.layout.bullion_widget).apply {

                val title = widgetData.getString("headline_title", null)
                setTextViewText(R.id.headline_title, title ?: "Bullion")

                val description = widgetData.getString("headline_description", null)
                setTextViewText(R.id.headline_description, description ?: "Open the App to update")

                val priceChanges = widgetData.getString("price_changes", null)
                setTextViewText(R.id.price_changes, priceChanges ?: "---")

                val imageName = widgetData.getString("logoDev", null)
                if(imageName != null) {
                    val imageFile = File(imageName)
                    val imageExists = imageFile.exists()
                    if (imageExists) {
                        val myBitmap: Bitmap = BitmapFactory.decodeFile(imageFile.absolutePath)
                        setImageViewBitmap(R.id.widget_image, myBitmap)
                    } else {
                        println("Image not found!, looked @: ${imageName}")
                    }
                } else println("No image name found!")
            }

            appWidgetManager.updateAppWidget(appWidgetId, views)
        }

    }

    override fun onEnabled(context: Context) {
        // Enter relevant functionality for when the first widget is created
    }

    override fun onDisabled(context: Context) {
        // Enter relevant functionality for when the last widget is disabled
    }
}

/*
internal fun updateAppWidget(
    context: Context,
    appWidgetManager: AppWidgetManager,
    appWidgetId: Int
) {
    val widgetText = context.getString(R.string.appwidget_text)
    // Construct the RemoteViews object
    val views = RemoteViews(context.packageName, R.layout.bullion_widget)
    views.setTextViewText(R.id.appwidget_text, widgetText)

    // Instruct the widget manager to update the widget
    appWidgetManager.updateAppWidget(appWidgetId, views)
}*/
