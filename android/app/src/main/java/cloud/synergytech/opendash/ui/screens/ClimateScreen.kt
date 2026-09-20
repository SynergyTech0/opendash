package cloud.synergytech.opendash.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.gestures.detectTapGestures
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
import androidx.compose.foundation.rememberScrollState
import androidx.compose.foundation.shape.CircleShape
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.foundation.verticalScroll
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.AcUnit
import androidx.compose.material.icons.rounded.Air
import androidx.compose.material.icons.rounded.Autorenew
import androidx.compose.material.icons.rounded.Loop
import androidx.compose.material.icons.rounded.Waves
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import cloud.synergytech.opendash.model.DashViewModel
import cloud.synergytech.opendash.ui.components.ViewHeading
import cloud.synergytech.opendash.ui.theme.BodyFamily
import cloud.synergytech.opendash.ui.theme.Dash
import cloud.synergytech.opendash.ui.theme.DisplayFamily

@Composable
fun ClimateScreen(vm: DashViewModel) {
    Column(
        Modifier.fillMaxSize().verticalScroll(rememberScrollState()).padding(20.dp)
    ) {
        ViewHeading("Climate")
        Spacer(Modifier.height(16.dp))

        Row(horizontalArrangement = Arrangement.spacedBy(16.dp)) {
            Zone(Modifier.weight(1f), "Driver", vm.driverTemp, vm.seatLeft,
                onMinus = { vm.nudgeTemp("driver", -1) }, onPlus = { vm.nudgeTemp("driver", 1) },
                onSeat = { vm.setSeat("left", it) })
            Zone(Modifier.weight(1f), "Passenger", vm.passengerTemp, vm.seatRight,
                onMinus = { vm.nudgeTemp("passenger", -1) }, onPlus = { vm.nudgeTemp("passenger", 1) },
                onSeat = { vm.setSeat("right", it) })
        }

        Spacer(Modifier.height(16.dp))
        // fan
        Row(
            Modifier.fillMaxWidth().height(54.dp).clip(RoundedCornerShape(18.dp))
                .background(Dash.panel).border(1.dp, Dash.line, RoundedCornerShape(18.dp))
                .padding(horizontal = 18.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(Icons.Rounded.Air, null, tint = Dash.dim, modifier = Modifier.size(20.dp))
            Spacer(Modifier.width(9.dp))
            Text("FAN", color = Dash.dim, fontFamily = DisplayFamily, fontSize = 12.sp, letterSpacing = 1.sp)
            Spacer(Modifier.width(14.dp))
            Row(Modifier.weight(1f), horizontalArrangement = Arrangement.spacedBy(5.dp)) {
                (1..6).forEach { level ->
                    Box(
                        Modifier.weight(1f).height(22.dp).clip(RoundedCornerShape(5.dp))
                            .background(if (vm.fan >= level) Dash.cyan else Dash.raise)
                            .pointerInput(level) { detectTapGestures { vm.setFanSpeed(level) } }
                    )
                }
            }
        }

        Spacer(Modifier.height(10.dp))
        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
            Toggle(Modifier.weight(1f), Icons.Rounded.AcUnit, "A/C", vm.ac) { vm.toggleClimate("ac") }
            Toggle(Modifier.weight(1f), Icons.Rounded.Autorenew, "Auto", vm.auto) { vm.toggleClimate("auto") }
            Toggle(Modifier.weight(1f), Icons.Rounded.Loop, "Recirculate", vm.recirc) { vm.toggleClimate("recirc") }
        }
        Spacer(Modifier.height(10.dp))
        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.spacedBy(10.dp)) {
            Toggle(Modifier.weight(1f), Icons.Rounded.Waves, "Front Defrost", vm.defrostFront) { vm.toggleClimate("defrostFront") }
            Toggle(Modifier.weight(1f), Icons.Rounded.Waves, "Rear Defrost", vm.defrostRear) { vm.toggleClimate("defrostRear") }
            Spacer(Modifier.weight(1f))
        }
    }
}

@Composable
private fun Zone(
    modifier: Modifier, label: String, temp: Int, seat: Int,
    onMinus: () -> Unit, onPlus: () -> Unit, onSeat: (Int) -> Unit
) {
    Column(
        modifier.height(210.dp).clip(RoundedCornerShape(18.dp)).background(Dash.panel)
            .border(1.dp, Dash.line, RoundedCornerShape(18.dp)).padding(18.dp),
        horizontalAlignment = Alignment.CenterHorizontally,
        verticalArrangement = Arrangement.spacedBy(10.dp)
    ) {
        Text(label.uppercase(), color = Dash.dim, fontFamily = DisplayFamily,
            fontSize = 11.sp, letterSpacing = 1.6.sp)
        Row(verticalAlignment = Alignment.Top) {
            Text("$temp", color = Dash.ink, fontFamily = DisplayFamily,
                fontSize = 52.sp, fontWeight = FontWeight.Bold)
            Text("°F", color = Dash.amber, fontFamily = DisplayFamily, fontSize = 22.sp)
        }
        Row(horizontalArrangement = Arrangement.spacedBy(14.dp)) {
            Stepper("−", onMinus); Stepper("+", onPlus)
        }
        Row(verticalAlignment = Alignment.CenterVertically, horizontalArrangement = Arrangement.spacedBy(6.dp)) {
            Text("SEAT", color = Dash.faint, fontFamily = DisplayFamily, fontSize = 10.sp, letterSpacing = 1.sp)
            (1..3).forEach { level ->
                Box(
                    Modifier.width(26.dp).height(14.dp).clip(RoundedCornerShape(4.dp))
                        .background(if (seat >= level) Dash.amber else Dash.raise)
                        .then(if (seat >= level) Modifier else Modifier.border(1.dp, Dash.line, RoundedCornerShape(4.dp)))
                        .pointerInput(level) { detectTapGestures { onSeat(level) } }
                )
            }
        }
    }
}

@Composable
private fun Stepper(glyph: String, onClick: () -> Unit) {
    Box(
        Modifier.size(46.dp).clip(CircleShape).background(Dash.panel2)
            .border(1.dp, Dash.line, CircleShape)
            .pointerInput(Unit) { detectTapGestures { onClick() } },
        contentAlignment = Alignment.Center
    ) {
        Text(glyph, color = Dash.ink, fontSize = 24.sp)
    }
}

@Composable
private fun Toggle(modifier: Modifier, icon: ImageVector, label: String, on: Boolean, onClick: () -> Unit) {
    Row(
        modifier.height(52.dp).clip(RoundedCornerShape(14.dp))
            .background(if (on) Dash.amber else Dash.panel)
            .border(1.dp, if (on) Dash.amber else Dash.line, RoundedCornerShape(14.dp))
            .pointerInput(Unit) { detectTapGestures { onClick() } }
            .padding(horizontal = 14.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(icon, null, tint = if (on) Dash.onAmber else Dash.dim, modifier = Modifier.size(20.dp))
        Spacer(Modifier.width(10.dp))
        Text(label, color = if (on) Dash.onAmber else Dash.dim,
            fontFamily = BodyFamily, fontSize = 14.sp, fontWeight = FontWeight.SemiBold)
    }
}
