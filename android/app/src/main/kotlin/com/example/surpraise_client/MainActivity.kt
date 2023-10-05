package com.viniciusamelio.surpraise_client

import android.os.Bundle
import io.embrace.android.embracesdk.Embrace
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {

  override fun onCreate(savedInstanceState: Bundle?) {
    super.onCreate(savedInstanceState)
    Embrace.getInstance().start(this, false, Embrace.AppFramework.FLUTTER)
  }

}
