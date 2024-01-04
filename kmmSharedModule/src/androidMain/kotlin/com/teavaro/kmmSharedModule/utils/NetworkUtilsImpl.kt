package com.teavaro.kmmSharedModule.utils

import android.annotation.SuppressLint
import android.app.Application
import android.content.Context
import android.net.ConnectivityManager
import android.net.NetworkCapabilities.NET_CAPABILITY_INTERNET
import android.os.Build

class NetworkUtilsImpl(private val application: Application): NetworkUtils {

    @SuppressLint("MissingPermission")
    override fun isInternetConnectionAvailable(): Boolean {
        val connectivityManager = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            application.getSystemService(ConnectivityManager::class.java)
        } else {
            application.getSystemService(Context.CONNECTIVITY_SERVICE) as ConnectivityManager
        }
        return if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.M) {
            val currentNetwork = connectivityManager.activeNetwork
            val caps = connectivityManager.getNetworkCapabilities(currentNetwork)
            caps != null && caps.hasCapability(NET_CAPABILITY_INTERNET)

        } else {
            val networkInfo = connectivityManager.activeNetworkInfo
            networkInfo != null && networkInfo.isConnected
        }
    }
}