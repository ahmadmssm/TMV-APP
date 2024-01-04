package com.teavaro.kmmSharedModule.data.local

import kotlinx.coroutines.flow.Flow

interface LocalDatabase<T> {
    fun saveOrUpdate(item: T): Flow<T>
    fun delete(item: T): Flow<Unit>
    fun clear(): Flow<Unit>
    fun findById(id: String): T?
    fun findByName(name: String): T?
    fun retrieveMangasAsList(): List<T>
    fun retrieveMangas(): Flow<List<T>>
}