package com.teavaro.kmmSharedModule.data.models.manga

import com.teavaro.kmmSharedModule.BuildKonfig
import com.teavaro.kmmSharedModule.data.models.Relationship
import com.teavaro.kmmSharedModule.utils.Serializer
import kotlinx.serialization.Serializable

@Serializable
data class Manga(val id: String,
                 val attributes: MangaAttributes,
                 val relationships: List<Relationship>) {

    val coverImageURL get() = relationships.firstOrNull { it.type == Relationship.COVER_ART }
        ?.attributes
        ?.name
        ?.let { "${BuildKonfig.imageBaseURL}${this.id}/${it}" }

    val author get() = relationships.firstOrNull { it.type == Relationship.AUTHOR }
        ?.attributes
        ?.name

    companion object {

        fun createDummyManga(): Manga {
            val json = "{\n" +
                    "   \"id\":\"34f72e29-1bda-40df-ae93-0e1c32d96ea6\",\n" +
                    "   \"type\":\"manga\",\n" +
                    "   \"attributes\":{\n" +
                    "      \"title\":{\n" +
                    "         \"en\":\"Witch Craft Works\"\n" +
                    "      },\n" +
                    "      \"description\":{\n" +
                    "         \"en\":\"Takamiya Honoka, a regular student, sits next to Kagari Ayaka, the idol of the school, and a perfect girl in every way. Her fans are hostile to the extent of harassing anyone who gets close to their princess, so Takamiya-kun is always in trouble. One day Takamiya is suddenly attacked by an unknown force, but he is rescued by a powerful sorceress of fire, who happens to be… Kagari Ayaka herself!\"\n" +
                    "      },\n" +
                    "      \"lastVolume\":\"17\",\n" +
                    "      \"lastChapter\":\"108\",\n" +
                    "      \"status\":\"completed\",\n" +
                    "      \"year\":2010,\n" +
                    "      \"contentRating\":\"safe\",\n" +
                    "      \"chapterNumbersResetOnNewVolume\":false,\n" +
                    "      \"version\":28,\n" +
                    "      \"latestUploadedChapter\":\"c9dca42b-2d60-4ec6-bd8b-641dee8621be\"\n" +
                    "   },\n" +
                    "   \"relationships\":[\n" +
                    "      {\n" +
                    "         \"id\":\"24721ec4-ed39-4527-9207-9bff7664c098\",\n" +
                    "         \"type\":\"author\"\n" +
                    "      },\n" +
                    "      {\n" +
                    "         \"id\":\"24721ec4-ed39-4527-9207-9bff7664c098\",\n" +
                    "         \"type\":\"artist\"\n" +
                    "      },\n" +
                    "      {\n" +
                    "         \"id\":\"33896ddc-bbab-49bb-8c9a-87cebc3be882\",\n" +
                    "         \"type\":\"cover_art\",\n" +
                    "         \"attributes\":{\n" +
                    "            \"description\":\"\",\n" +
                    "            \"volume\":\"18\",\n" +
                    "            \"fileName\":\"d10e9e7a-a992-4d24-9e8d-6cf240870e66.png\",\n" +
                    "            \"locale\":\"ja\",\n" +
                    "            \"createdAt\":\"2023-01-30T04:55:38+00:00\",\n" +
                    "            \"updatedAt\":\"2023-01-30T04:55:38+00:00\",\n" +
                    "            \"version\":1\n" +
                    "         }\n" +
                    "      },\n" +
                    "      {\n" +
                    "         \"id\":\"18c41d02-408a-4a84-9aba-713eb3269376\",\n" +
                    "         \"type\":\"manga\",\n" +
                    "         \"related\":\"doujinshi\"\n" +
                    "      },\n" +
                    "      {\n" +
                    "         \"id\":\"aa8ba8d4-a5fc-4c69-a536-502535e4714c\",\n" +
                    "         \"type\":\"manga\",\n" +
                    "         \"related\":\"doujinshi\"\n" +
                    "      },\n" +
                    "      {\n" +
                    "         \"id\":\"b642d874-da28-4db6-bdbe-258060666a3a\",\n" +
                    "         \"type\":\"manga\",\n" +
                    "         \"related\":\"prequel\"\n" +
                    "      }\n" +
                    "   ]\n" +
                    "}"
            return Serializer.objectFromString(json)
        }
    }
}