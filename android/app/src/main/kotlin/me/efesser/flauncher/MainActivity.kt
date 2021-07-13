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

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.Intent.CATEGORY_LAUNCHER
import android.content.Intent.CATEGORY_LEANBACK_LAUNCHER
import android.content.IntentFilter
import android.content.pm.ResolveInfo
import android.graphics.Bitmap
import android.graphics.Canvas
import android.graphics.drawable.Drawable
import android.net.Uri
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodChannel
import java.io.ByteArrayOutputStream

private const val METHOD_CHANNEL = "me.efesser.flauncher/method"
private const val EVENT_CHANNEL = "me.efesser.flauncher/event"

class MainActivity : FlutterActivity() {
    val broadcastReceivers = ArrayList<BroadcastReceiver>()

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            when (call.method) {
                "getInstalledApplications" -> result.success(getInstalledApplications(call.arguments as Boolean))
                "launchApp" -> result.success(launchApp(call.arguments as String))
                "openSettings" -> result.success(openSettings())
                "openAppInfo" -> result.success(openAppInfo(call.arguments as String))
                "uninstallApp" -> result.success(uninstallApp(call.arguments as String))
                "isDefaultLauncher" -> result.success(isDefaultLauncher())
                "checkForGetContentAvailability" -> result.success(checkForGetContentAvailability())
                else -> throw IllegalArgumentException()
            }
        }

        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(object : StreamHandler {
            lateinit var broadcastReceiver: SinkBroadcastReceiver
            override fun onListen(arguments: Any?, events: EventSink) {
                broadcastReceiver = SinkBroadcastReceiver(events)
                val intentFilter = IntentFilter()
                intentFilter.addAction(Intent.ACTION_PACKAGE_ADDED)
                intentFilter.addAction(Intent.ACTION_PACKAGE_REMOVED)
                intentFilter.addAction(Intent.ACTION_PACKAGE_REPLACED)
                intentFilter.addDataScheme("package")
                broadcastReceivers.add(broadcastReceiver)
                registerReceiver(broadcastReceiver, intentFilter)
            }

            override fun onCancel(arguments: Any?) {
                unregisterReceiver(broadcastReceiver)
                broadcastReceivers.remove(broadcastReceiver)
            }
        })
    }

    override fun onDestroy() {
        broadcastReceivers.forEach(::unregisterReceiver)
        super.onDestroy()
    }

    private fun getInstalledApplications(sideloaded: Boolean) = packageManager
            .queryIntentActivities(Intent(Intent.ACTION_MAIN, null)
                    .addCategory(if (sideloaded) CATEGORY_LAUNCHER else CATEGORY_LEANBACK_LAUNCHER), 0)
            .map(ResolveInfo::activityInfo)
            .map {
                mapOf(
                        "name" to it.loadLabel(packageManager).toString(),
                        "packageName" to it.packageName,
                        "banner" to it.loadBanner(packageManager)?.let(::drawableToByteArray),
                        "icon" to it.loadIcon(packageManager)?.let(::drawableToByteArray),
                        "version" to packageManager.getPackageInfo(it.packageName, 0).versionName,
                )
            }
            .sortedWith(compareBy(String.CASE_INSENSITIVE_ORDER) { it["name"] as String })

    private fun launchApp(packageName: String) = try {
        val intent = packageManager.getLeanbackLaunchIntentForPackage(packageName)
                ?: packageManager.getLaunchIntentForPackage(packageName)
        startActivity(intent)
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

    private fun openAppInfo(packageName: String) = try {
        Intent(Settings.ACTION_APPLICATION_DETAILS_SETTINGS)
                .setData(Uri.fromParts("package", packageName, null))
                .let(::startActivity)
        true
    } catch (e: Exception) {
        false
    }

    private fun uninstallApp(packageName: String) = try {
        Intent(Intent.ACTION_DELETE)
                .setData(Uri.fromParts("package", packageName, null))
                .let(::startActivity)
        true
    } catch (e: Exception) {
        false
    }

    private fun checkForGetContentAvailability() = try {
        val intentActivities = packageManager.queryIntentActivities(Intent(Intent.ACTION_GET_CONTENT, null).setTypeAndNormalize("image/*"), 0)
        intentActivities.isNotEmpty()
    } catch (e: Exception) {
        false
    }

    private fun isDefaultLauncher() = try {
        val defaultLauncher = packageManager.resolveActivity(Intent(Intent.ACTION_MAIN).addCategory(Intent.CATEGORY_HOME), 0)
        defaultLauncher?.activityInfo?.packageName == packageName
    } catch (e: Exception) {
        false
    }

    private fun drawableToByteArray(drawable: Drawable): ByteArray {
        fun drawableToBitmap(drawable: Drawable): Bitmap {
            val bitmap = Bitmap.createBitmap(drawable.intrinsicWidth, drawable.intrinsicHeight, Bitmap.Config.ARGB_8888)
            val canvas = Canvas(bitmap)
            drawable.setBounds(0, 0, canvas.width, canvas.height)
            drawable.draw(canvas)
            return bitmap
        }

        val bitmap = drawableToBitmap(drawable)
        val stream = ByteArrayOutputStream()
        bitmap.compress(Bitmap.CompressFormat.PNG, 100, stream)
        return stream.toByteArray()
    }
}

class SinkBroadcastReceiver(private val sink: EventSink) : BroadcastReceiver() {
    override fun onReceive(context: Context, intent: Intent) {
        sink.success(mapOf(
                "action" to intent.action,
                "packageName" to intent.dataString
        ))
    }
}
