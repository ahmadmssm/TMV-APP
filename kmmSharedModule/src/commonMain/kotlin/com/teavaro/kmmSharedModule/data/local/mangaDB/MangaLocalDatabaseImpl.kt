package com.teavaro.kmmSharedModule.data.local.mangaDB

import com.teavaro.kmmSharedModule.data.models.manga.Manga
import com.teavaro.kmmSharedModule.data.models.MangaWrapper
import io.realm.kotlin.MutableRealm
import io.realm.kotlin.Realm
import io.realm.kotlin.RealmConfiguration
import io.realm.kotlin.UpdatePolicy
import io.realm.kotlin.ext.query
import kotlinx.coroutines.flow.Flow
import kotlinx.coroutines.flow.flow

class MangaLocalDatabaseImpl: MangaLocalDatabase {

    private val configuration = RealmConfiguration
        .Builder(schema = setOf(MangaWrapper::class))
        .schemaVersion(2)
        .name("mangasDB.realm")
        .build()

    override fun saveOrUpdate(item: Manga) = this.realmOperation {
        copyToRealm(MangaWrapper(item), UpdatePolicy.ALL).toManga()
    }

    override fun delete(item: Manga) = this.realmOperation {
        val query = query<MangaWrapper>("id = $0", item.id)
        delete(query)
    }

    override fun clear() = this.realmOperation {
        val query = this.query<MangaWrapper>()
        delete(query)
    }

    override fun findById(id: String): Manga? {
        val query = Realm.open(configuration).query<MangaWrapper>("id = $0", id)
        return query.find().firstOrNull()?.toManga()
    }

    override fun findByName(name: String): Manga? {
        val query = Realm.open(configuration).query<MangaWrapper>("title = $0", name)
        return query.find().firstOrNull()?.toManga()
    }

    override fun retrieveMangas() = this.realmOperation {
        query<MangaWrapper>().find().toList().map { it.toManga() }
    }

    override fun retrieveMangasAsList(): List<Manga> {
        return Realm.open(configuration).query<MangaWrapper>().find().toList().map { it.toManga() }
    }

    private fun <T>realmOperation(action: MutableRealm.(MutableRealm) -> (T)): Flow<T> {
        return flow {
            Realm.open(configuration).write {
                action(this)
            }.apply {
                emit(this)
            }
        }
    }
}