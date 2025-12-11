package com.geumpumgalchwi.geumpumta

import android.net.*
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {

    private val CHANNEL = "network_monitor"

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        val connectivityManager =
            getSystemService(CONNECTIVITY_SERVICE) as ConnectivityManager

        val request = NetworkRequest.Builder().build()

        connectivityManager.registerNetworkCallback(
            request,
            object : ConnectivityManager.NetworkCallback() {

                override fun onLost(network: Network) {
                    runOnUiThread {
                        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                            MethodChannel(messenger, CHANNEL)
                                .invokeMethod("network_changed", mapOf("type" to "lost"))
                        }
                    }
                }

                override fun onAvailable(network: Network) {
                    runOnUiThread {
                        val activeNetwork = connectivityManager.activeNetworkInfo
                        val isWifi = activeNetwork?.type == ConnectivityManager.TYPE_WIFI

                        flutterEngine?.dartExecutor?.binaryMessenger?.let { messenger ->
                            MethodChannel(messenger, CHANNEL)
                                .invokeMethod("network_changed", mapOf(
                                    "type" to "changed",
                                    "isWifi" to isWifi
                                ))
                        }
                    }
                }
            }
        )
    }
}