package org.mytonwallet.app_air.walletcore.moshi

import com.squareup.moshi.JsonClass

@JsonClass(generateAdapter = true)
data class ApiSubmitTransferResult(
    val activityId: String,
)
