package com.purelykai.campusconnect

class Greeting {
    private val platform: Platform = getPlatform()

    fun greet(): String {
        return "Hello there, ${platform.name}!"
    }
}