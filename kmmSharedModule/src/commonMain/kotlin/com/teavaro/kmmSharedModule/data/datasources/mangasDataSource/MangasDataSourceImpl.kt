package com.teavaro.kmmSharedModule.data.datasources.mangasDataSource

import com.teavaro.kmmSharedModule.utils.FlowExecuter
import com.teavaro.kmmSharedModule.data.local.LocalDatabase
import com.teavaro.kmmSharedModule.data.models.manga.Manga
import com.teavaro.kmmSharedModule.data.remote.rest.APIFactory
import com.teavaro.kmmSharedModule.data.remote.rest.RestClientException
import com.teavaro.kmmSharedModule.utils.NetworkUtils
import kotlinx.coroutines.flow.map

class MangasDataSourceImpl(apiFactory: APIFactory,
                           private val localDatabase: LocalDatabase<Manga>,
                           private val networkUtils: NetworkUtils): MangasDataSource {

    private var searchOffset = 0
    private var currentListingOffset = 0
    private var searchTitle: String? = null
    private val apis = apiFactory.createAPIs()

    override fun fetchMangas(successAction: (isLastPage: Boolean, List<Manga>) -> Unit, failureAction: (String) -> Unit) {
        if (this.networkUtils.isInternetConnectionAvailable()) {
            FlowExecuter.executeApi(apis.fetchMangas(offset = this.currentListingOffset), {
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

    override fun fetchMangas(searchTitle: String, successAction: (isLastPage: Boolean, List<Manga>) -> Unit, failureAction: (String) -> Unit) {
        if (this.networkUtils.isInternetConnectionAvailable()) {
            if (this.searchTitle != searchTitle) {
                // Reset search pagination
                this.searchOffset = 0
                this.searchTitle = searchTitle
            }
            FlowExecuter.executeApi(
                apis.fetchMangas(
                    title = searchTitle,
                    offset = this.searchOffset
                ), {
                    this.searchOffset = it.nextOffset
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

    override fun findFavouriteManga(mangaId: String) = this.localDatabase.findById(mangaId)

    override fun resetPagination() {
        this.searchOffset = 0
        this.currentListingOffset = 0
    }

    override fun fetchFavouriteMangas(successAction: (List<Manga>) -> Unit, failureAction: (String) -> Unit) {
        FlowExecuter.execute(this.localDatabase.retrieveMangas(), successAction, failureAction)
    }

    override fun fetchFavouriteMangas(searchTitle: String, successAction: (List<Manga>) -> Unit, failureAction: (String) -> Unit) {
        FlowExecuter.execute(this.localDatabase.retrieveMangas().map { list ->
            list.filter { it.attributes.englishTitle?.contains(searchTitle, true) == true }
        }, successAction, failureAction)
    }

    override fun addMangaToFavourite(manga: Manga, successAction: () -> Unit, failureAction: (String) -> Unit) {
        FlowExecuter.execute(this.localDatabase.saveOrUpdate(manga), { successAction() }, failureAction)
    }

    override fun deleteFavouriteManga(manga: Manga, successAction: () -> Unit, failureAction: (String) -> Unit) {
        FlowExecuter.execute(this.localDatabase.delete(manga), { successAction() }, failureAction)
    }
}