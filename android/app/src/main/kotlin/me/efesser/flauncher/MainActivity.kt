/*
 * FLauncher
 * Copyright (C) 2021  Étienne Fesser
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <https://www.gnu.org/licenses/>.
 */

package me.efesser.flauncher

import android.content.Intent
import android.content.Intent.CATEGORY_LEANBACK_LAUNCHER
import android.content.pm.ResolveInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

private const val CHANNEL = "me.efesser.flauncher"

class MainActivity : FlutterActivity() {

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApplications" -> {
                    result.success(getInstalledApplications())
                }
                "launchApp" -> {
                    (call.arguments as List<String>).let {
                        result.success(launchApp(it[0], it[1]))
                    }
                }
                "openSettings" -> {
                    result.success(openSettings())
                }
                else -> throw IllegalArgumentException()
            }
        }
    }

    private fun getInstalledApplications() = packageManager
            .queryIntentActivities(Intent(Intent.ACTION_MAIN, null).addCategory(CATEGORY_LEANBACK_LAUNCHER), 0)
            .map(ResolveInfo::activityInfo)
            .map {
                mapOf(
                        "name" to it.loadLabel(packageManager),
                        "packageName" to it.packageName,
                        "banner" to it.loadBanner(packageManager)?.let(::drawableToByteArray),
                        "icon" to it.loadIcon(packageManager)?.let(::drawableToByteArray),
                        "className" to it.name
                )
            }

    private fun drawableToBitmap(drawable: Drawable): Bitmap {
        val bitmap = Bitmap.createBitmap(drawable.intrinsicWidth, drawable.intrinsicHeight, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(bitmap)
        drawable.setBounds(0, 0, canvas.width, canvas.height)
        drawable.draw(canvas)
        return bitmap
    }

    private fun drawableToByteArray(drawable: Drawable): ByteArray {
        val bitmap = drawableToBitmap(drawable)
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        return stream.toByteArray()
    }

    private fun launchApp(packageName: String, className: String) = try {
        Intent(Intent.ACTION_MAIN)
                .setFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                .setClassName(packageName, className)
                .let(::startActivity)
        true
    } catch (e: Exception) {
        false
    }

    private fun openSettings() = try {
        startActivity(Intent(Settings.ACTION_SETTINGS))
        true
    } catch (e: Exception) {
        false
    }
}
