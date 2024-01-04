package com.teavaro.kmmSharedModule.data.models

import com.teavaro.kmmSharedModule.data.models.manga.Manga
import io.realm.kotlin.types.RealmObject
import com.teavaro.kmmSharedModule.utils.Serializer
import io.realm.kotlin.types.annotations.PrimaryKey

internal class MangaWrapper: RealmObject {

    @PrimaryKey
    var id: String = ""
    private var mangaJson: String = ""

    @Suppress("unused")
    constructor() {}

    constructor(manga: Manga) : super() {
        this.id = manga.id
        this.mangaJson = Serializer.objectToString(manga)
    }

    fun toManga() = Serializer.objectFromString<Manga>(this.mangaJson)
}