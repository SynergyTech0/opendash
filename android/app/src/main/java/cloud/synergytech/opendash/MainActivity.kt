package cloud.synergytech.opendash

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.runtime.getValue
import androidx.lifecycle.viewmodel.compose.viewModel
import cloud.synergytech.opendash.model.DashViewModel
import cloud.synergytech.opendash.ui.OpenDashApp
import cloud.synergytech.opendash.ui.theme.OpenDashTheme

class MainActivity : ComponentActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()
        setContent {
            val vm: DashViewModel = viewModel()
            OpenDashTheme(day = vm.day) {
                OpenDashApp(vm)
            }
        }
    }
}
