package com.teavaro.kmmSharedModule.data.models

import kotlinx.serialization.Serializable
import kotlinx.serialization.json.JsonNames

@Serializable
data class RelationshipAttributes(@JsonNames("name", "fileName") val name: String,
                                  val locale: String?,
                                  val volume: String?,
                                  val version: Int)