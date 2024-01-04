package com.teavaro.kmmSharedModule.data.models

import kotlinx.serialization.Serializable

@Serializable
data class Relationship(val id: String, val type: String, val attributes: RelationshipAttributes? = null) {
    internal companion object {
        const val AUTHOR = "author"
        const val ARTIST = "artist"
        const val COVER_ART = "cover_art"
    }
}