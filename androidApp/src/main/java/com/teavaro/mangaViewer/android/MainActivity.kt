package com.teavaro.mangaViewer.android

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.material.*
import androidx.compose.runtime.Composable
import androidx.compose.ui.Modifier
import androidx.compose.ui.tooling.preview.Preview
import com.teavaro.kmmSharedModule.data.datasources.chapterDataSource.ChapterDataSource
import com.teavaro.kmmSharedModule.data.datasources.chapterDataSource.ChapterDataSourceImpl
import com.teavaro.kmmSharedModule.data.remote.rest.APIFactory
import com.teavaro.kmmSharedModule.data.remote.rest.client.HttpClientFactory
import com.teavaro.kmmSharedModule.utils.NetworkUtilsImpl
import com.teavaro.kmmSharedModule.utils.logger.LoggerImpl
import com.teavaro.kmmSharedModule.utils.logger.SystemLogger
import com.teavaro.utiqTech.data.models.UTIQOptions
import com.teavaro.utiqTech.initializer.UTIQ

class MainActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContent {
            MyApplicationTheme {
                Surface(
                    modifier = Modifier.fillMaxSize(),
                    color = MaterialTheme.colors.background
                ) {
                    // Here
                }
            }
        }
    }

    override fun onStart() {
        super.onStart()
        val logger: SystemLogger = LoggerImpl(true)
        val restClient = HttpClientFactory(this.baseContext, logger).create(true)
        val apiFactory = APIFactory(restClient)
//        val ds: MangasDataSource = MangasDataSourceImpl(apiFactory)
//        ds.fetchMangas("Naruto", { bool, list ->
//            println(list.first())
//        }, {
//            println("Error $it")
//        })
        //
        val networkUtils = NetworkUtilsImpl(this.application)
        val ds: ChapterDataSource = ChapterDataSourceImpl(apiFactory, networkUtils)
        ds.fetchMangaChapters("722a45c0-5e55-40f2-929b-ff69b0989edb", { bool, list ->
            println(list.first())
        }, {
            println("Error $it")
        })
        //
         // UTIQ.initialize(this.application, "R&Ai^v>TfqCz4Y^HH2?3uk8j", UTIQOptions(true))
        // FunnelConnectSDK.initialize(this.application, "cBsA3tQa.fyL749JH+?yJW=7", FCOptions(true))
    }
}

@Composable
fun GreetingView(text: String) {
    Text(text = text)
}

@Preview
@Composable
fun DefaultPreview() {
    MyApplicationTheme {
        GreetingView("Hello, Android!")
    }
}