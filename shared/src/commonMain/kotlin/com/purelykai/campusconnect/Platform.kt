package com.purelykai.campusconnect

interface Platform {
    val name: String
}

expect fun getPlatform(): Platform