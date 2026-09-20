package cloud.synergytech.opendash.ui.screens

import androidx.compose.animation.core.animateDpAsState
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.offset
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.layout.size
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Bolt
import androidx.compose.material.icons.rounded.Code
import androidx.compose.material.icons.rounded.DarkMode
import androidx.compose.material.icons.rounded.Thermostat
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import cloud.synergytech.opendash.model.DashViewModel
import cloud.synergytech.opendash.ui.components.ViewHeading
import cloud.synergytech.opendash.ui.components.richText
import cloud.synergytech.opendash.ui.theme.BodyFamily
import cloud.synergytech.opendash.ui.theme.Dash
import cloud.synergytech.opendash.ui.theme.DisplayFamily

@Composable
fun SettingsScreen(vm: DashViewModel) {
    Column(
        Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(20.dp)
    ) {
        ViewHeading("Settings")
        Spacer(Modifier.height(14.dp))

        // preferences card
        Column(
            Modifier.fillMaxWidth().clip(RoundedCornerShape(18.dp)).background(Dash.panel)
                .border(1.dp, Dash.line, RoundedCornerShape(18.dp)).padding(8.dp)
        ) {
            SettingRow(Icons.Rounded.DarkMode, "Night mode", "Dark instrument look for driving after dark", divider = true) {
                PillSwitch(on = !vm.day) { vm.day = !vm.day }
            }
            SettingRow(Icons.Rounded.Bolt, "Screen brightness", "Auto-dims with the headlights", divider = true) {
                Text("${vm.brightness}%", color = Dash.dim, fontFamily = DisplayFamily, fontSize = 14.sp)
            }
            SettingRow(Icons.Rounded.Thermostat, "Temperature units", "Cabin & outside readout", divider = false) {
                Text("°${vm.units}", color = Dash.dim, fontFamily = DisplayFamily, fontSize = 14.sp,
                    modifier = Modifier.pointerInput(Unit) { detectTapGestures { vm.toggleUnits() } })
            }
        }

        Spacer(Modifier.height(14.dp))
        // about card
        Column(
            Modifier.fillMaxWidth().clip(RoundedCornerShape(18.dp)).background(Dash.panel)
                .border(1.dp, Dash.line, RoundedCornerShape(18.dp)).padding(18.dp)
        ) {
            Row(verticalAlignment = Alignment.CenterVertically) {
                Icon(Icons.Rounded.Code, null, tint = Dash.amber, modifier = Modifier.size(20.dp))
                Spacer(Modifier.width(10.dp))
                Text("ABOUT OPENDASH", color = Dash.ink, fontFamily = DisplayFamily,
                    fontSize = 13.sp, letterSpacing = 1.sp)
            }
            Spacer(Modifier.height(12.dp))
            Text(
                richText(
                    "A head-unit UI that treats the driver like a person, not a spec sheet. " +
                        "<b>Two taps deep, max.</b> Big targets, high contrast, one accent, and every " +
                        "destructive action is reversible — including, at long last, deleting a track."
                ),
                color = Dash.dim, fontFamily = BodyFamily, fontSize = 14.sp, lineHeight = 21.sp
            )
            Spacer(Modifier.height(12.dp))
            Text("v0.1 “Delete Button” · Android / Compose build",
                color = Dash.faint, fontFamily = BodyFamily, fontSize = 13.sp)
        }
    }
}

@Composable
private fun SettingRow(icon: ImageVector, primary: String, sub: String, divider: Boolean, trailing: @Composable () -> Unit) {
    Column {
        Row(Modifier.fillMaxWidth().height(62.dp), verticalAlignment = Alignment.CenterVertically) {
            Box(
                Modifier.size(40.dp).clip(RoundedCornerShape(11.dp)).background(Dash.panel2),
                contentAlignment = Alignment.Center
            ) { Icon(icon, null, tint = Dash.dim, modifier = Modifier.size(20.dp)) }
            Spacer(Modifier.width(14.dp))
            Column(Modifier.weight(1f)) {
                Text(primary, color = Dash.ink, fontFamily = BodyFamily, fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
                Text(sub, color = Dash.dim, fontFamily = BodyFamily, fontSize = 13.sp)
            }
            trailing()
        }
        if (divider) Box(Modifier.fillMaxWidth().height(1.dp).background(Dash.line))
    }
}

@Composable
private fun PillSwitch(on: Boolean, onToggle: () -> Unit) {
    val knobX by animateDpAsState(if (on) 25.dp else 3.dp, label = "knob")
    Box(
        Modifier.width(52.dp).height(30.dp).clip(RoundedCornerShape(15.dp))
            .background(if (on) Dash.amber else Dash.raise)
            .border(1.dp, if (on) Dash.amber else Dash.line, RoundedCornerShape(15.dp))
            .pointerInput(Unit) { detectTapGestures { onToggle() } }
    ) {
        Box(
            Modifier.offset(x = knobX, y = 3.dp).size(22.dp).clip(CircleShape)
                .background(if (on) Dash.onAmber else Dash.ink)
        )
    }
}
