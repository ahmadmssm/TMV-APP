package com.teavaro.kmmSharedModule.data.datasources.chapterDataSource

import com.teavaro.kmmSharedModule.data.models.chapter.Chapter
import com.teavaro.kmmSharedModule.data.models.chapter.ChapterPages
import com.teavaro.kmmSharedModule.data.remote.rest.APIFactory
import com.teavaro.kmmSharedModule.data.remote.rest.RestClientException
import com.teavaro.kmmSharedModule.utils.FlowExecuter
import com.teavaro.kmmSharedModule.utils.NetworkUtils

class ChapterDataSourceImpl(apiFactory: APIFactory, private val networkUtils: NetworkUtils): ChapterDataSource {

    private var currentListingOffset = 0
    private val apis = apiFactory.createAPIs()

    override fun fetchMangaChapters(mangaId: String, successAction: (isLastPage: Boolean, List<Chapter>) -> Unit, failureAction: (String) -> Unit) {
        if (this.networkUtils.isInternetConnectionAvailable()) {
            FlowExecuter.executeApi(
                this.apis.fetchChapters(
                    mangaId,
                    offset = this.currentListingOffset
                ), {
                    this.currentListingOffset = it.nextOffset
                    successAction(it.isLastPage, it.data)
                }, {
                    failureAction(
                        when (it) {
                            is RestClientException.GenericError -> it.errorMessage
                            is RestClientException.HttpError -> "${it.statusCode} ${it.errorMessage}"
                        }
                    )
                })
        }
        else {
            failureAction("Internet Connection is not available!")
        }
    }

    override fun fetchChapterPages(chapterId: String, successAction: (ChapterPages) -> Unit, failureAction: (String) -> Unit) {
        if (this.networkUtils.isInternetConnectionAvailable()) {
            FlowExecuter.executeApi(this.apis.fetchChapterPages(chapterId), successAction) {
                failureAction(
                    when (it) {
                        is RestClientException.GenericError -> it.errorMessage
                        is RestClientException.HttpError -> "${it.statusCode} ${it.errorMessage}"
                    }
                )
            }
        }
        else {
            failureAction("Internet Connection is not available!")
        }
    }

    override fun resetChaptersFetchingPagination() {
        this.currentListingOffset = 0
    }
}