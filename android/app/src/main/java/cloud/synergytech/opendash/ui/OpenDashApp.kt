package cloud.synergytech.opendash.ui

import androidx.compose.animation.AnimatedVisibility
import androidx.compose.animation.fadeIn
import androidx.compose.animation.fadeOut
import androidx.compose.animation.slideInVertically
import androidx.compose.animation.slideOutVertically
import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Bluetooth
import androidx.compose.material.icons.rounded.Bolt
import androidx.compose.material.icons.rounded.DeleteOutline
import androidx.compose.material.icons.rounded.FormatListBulleted
import androidx.compose.material.icons.rounded.MusicNote
import androidx.compose.material.icons.rounded.NetworkCell
import androidx.compose.material.icons.rounded.Phone
import androidx.compose.material.icons.rounded.Settings
import androidx.compose.material.icons.rounded.Thermostat
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.LaunchedEffect
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.remember
import androidx.compose.runtime.setValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import cloud.synergytech.opendash.model.DashViewModel
import cloud.synergytech.opendash.model.Screen
import cloud.synergytech.opendash.model.Toast
import cloud.synergytech.opendash.ui.components.richText
import cloud.synergytech.opendash.ui.screens.ClimateScreen
import cloud.synergytech.opendash.ui.screens.MediaScreen
import cloud.synergytech.opendash.ui.screens.NowPlayingScreen
import cloud.synergytech.opendash.ui.screens.PhoneScreen
import cloud.synergytech.opendash.ui.screens.SettingsScreen
import cloud.synergytech.opendash.ui.theme.BodyFamily
import cloud.synergytech.opendash.ui.theme.Dash
import cloud.synergytech.opendash.ui.theme.DisplayFamily
import kotlinx.coroutines.delay

@Composable
fun OpenDashApp(vm: DashViewModel) {
    Box(Modifier.fillMaxSize().background(Dash.screen)) {
        Column(Modifier.fillMaxSize()) {
            StatusBar(vm)
            Row(Modifier.fillMaxSize()) {
                Box(Modifier.weight(1f).fillMaxSize()) {
                    when (vm.screen) {
                        Screen.NOW -> NowPlayingScreen(vm)
                        Screen.MEDIA -> MediaScreen(vm)
                        Screen.CLIMATE -> ClimateScreen(vm)
                        Screen.PHONE -> PhoneScreen(vm)
                        Screen.SETTINGS -> SettingsScreen(vm)
                    }
                }
                NavRail(vm)
            }
        }
        ToastHost(vm)
    }
}

@Composable
private fun StatusBar(vm: DashViewModel) {
    Column {
        Row(
            Modifier.fillMaxWidth().height(58.dp)
                .background(Dash.panel.copy(alpha = 0.6f))
                .padding(horizontal = 18.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Column {
                Text(vm.clock, color = Dash.ink, fontFamily = DisplayFamily,
                    fontSize = 20.sp, fontWeight = FontWeight.SemiBold)
                Text(vm.date, color = Dash.dim, fontFamily = DisplayFamily,
                    fontSize = 11.sp, letterSpacing = 1.sp)
            }
            Spacer(Modifier.weight(1f))
            Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(16.dp)) {
                StatusChip(Icons.Rounded.Thermostat, "${vm.outsideTempF}°", strong = true)
                StatusChip(Icons.Rounded.Bluetooth, "BT", strong = false)
                StatusChip(Icons.Rounded.NetworkCell, "4G", strong = true)
            }
        }
        Box(Modifier.fillMaxWidth().height(1.dp).background(Dash.line))
    }
}

@Composable
private fun StatusChip(icon: ImageVector, label: String, strong: Boolean) {
    Row(verticalAlignment = Alignment.CenterVertically) {
        Icon(icon, null, tint = Dash.dim, modifier = Modifier.size(16.dp))
        Spacer(Modifier.width(6.dp))
        Text(label, color = if (strong) Dash.ink else Dash.dim,
            fontFamily = DisplayFamily, fontSize = 13.sp,
            fontWeight = if (strong) FontWeight.SemiBold else FontWeight.Normal)
    }
}

private data class NavItem(val screen: Screen, val icon: ImageVector)

@Composable
private fun NavRail(vm: DashViewModel) {
    val items = listOf(
        NavItem(Screen.NOW, Icons.Rounded.MusicNote),
        NavItem(Screen.MEDIA, Icons.Rounded.FormatListBulleted),
        NavItem(Screen.CLIMATE, Icons.Rounded.Thermostat),
        NavItem(Screen.PHONE, Icons.Rounded.Phone),
        NavItem(Screen.SETTINGS, Icons.Rounded.Settings),
    )
    Row {
        Box(Modifier.width(1.dp).fillMaxSize().background(Dash.line))
        Column(
            Modifier.width(91.dp).fillMaxSize().background(Dash.panel).padding(8.dp),
            verticalArrangement = Arrangement.spacedBy(6.dp)
        ) {
            items.forEach { item ->
                val on = vm.screen == item.screen
                Column(
                    Modifier.fillMaxWidth().height(66.dp)
                        .background(if (on) Dash.amber else androidx.compose.ui.graphics.Color.Transparent,
                            RoundedCornerShape(14.dp))
                        .pointerInput(item.screen) { detectTapGestures { vm.screen = item.screen } },
                    horizontalAlignment = Alignment.CenterHorizontally,
                    verticalArrangement = Arrangement.Center
                ) {
                    Icon(item.icon, null, tint = if (on) Dash.onAmber else Dash.dim, modifier = Modifier.size(26.dp))
                    Spacer(Modifier.height(6.dp))
                    Text(item.screen.label.uppercase(), color = if (on) Dash.onAmber else Dash.dim,
                        fontFamily = DisplayFamily, fontSize = 10.sp, letterSpacing = 0.6.sp)
                }
            }
        }
    }
}

@Composable
private fun ToastHost(vm: DashViewModel) {
    var toast by remember { mutableStateOf<Toast?>(null) }
    LaunchedEffect(Unit) {
        vm.toasts.collect { t -> toast = t; delay(2600); toast = null }
    }
    Box(Modifier.fillMaxSize().padding(bottom = 30.dp), contentAlignment = Alignment.BottomCenter) {
        AnimatedVisibility(
            visible = toast != null,
            enter = fadeIn() + slideInVertically { it / 2 },
            exit = fadeOut() + slideOutVertically { it / 2 },
        ) {
            val t = toast
            Row(
                Modifier.background(Dash.raise, RoundedCornerShape(14.dp))
                    .padding(horizontal = 18.dp, vertical = 12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(if (t?.danger == true) Icons.Rounded.DeleteOutline else Icons.Rounded.Bolt, null,
                    tint = if (t?.danger == true) Dash.bad else Dash.amber, modifier = Modifier.size(20.dp))
                Spacer(Modifier.width(11.dp))
                Text(richText(t?.message ?: ""), color = Dash.ink, fontFamily = BodyFamily, fontSize = 14.sp)
            }
        }
    }
}
