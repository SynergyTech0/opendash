package cloud.synergytech.opendash.ui.screens

import android.content.Intent
import androidx.activity.compose.rememberLauncherForActivityResult
import androidx.activity.result.contract.ActivityResultContracts
import androidx.compose.animation.core.animateDpAsState
import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.horizontalScroll
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.BoxScope
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
import androidx.compose.material.icons.rounded.Block
import androidx.compose.material.icons.rounded.Bolt
import androidx.compose.material.icons.rounded.Code
import androidx.compose.material.icons.rounded.DarkMode
import androidx.compose.material.icons.rounded.Image
import androidx.compose.material.icons.rounded.Thermostat
import androidx.compose.material.icons.rounded.Wallpaper
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import cloud.synergytech.opendash.model.DashViewModel
import cloud.synergytech.opendash.ui.components.BgPresetKeys
import cloud.synergytech.opendash.ui.components.UriImage
import cloud.synergytech.opendash.ui.components.ViewHeading
import cloud.synergytech.opendash.ui.components.bgPresetBrush
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
        BackgroundCard(vm)

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
private fun BackgroundCard(vm: DashViewModel) {
    val context = LocalContext.current
    // OpenDocument (not GetContent) so the read grant is persistable — the chosen
    // photo survives app restarts, matching the web/Qt builds.
    val picker = rememberLauncherForActivityResult(ActivityResultContracts.OpenDocument()) { uri ->
        if (uri != null) {
            runCatching {
                context.contentResolver.takePersistableUriPermission(uri, Intent.FLAG_GRANT_READ_URI_PERMISSION)
            }
            vm.setBgImage(uri.toString())
        }
    }
    Column(
        Modifier.fillMaxWidth().clip(RoundedCornerShape(18.dp)).background(Dash.panel)
            .border(1.dp, Dash.line, RoundedCornerShape(18.dp)).padding(14.dp)
    ) {
        Row(verticalAlignment = Alignment.CenterVertically) {
            Box(
                Modifier.size(40.dp).clip(RoundedCornerShape(11.dp)).background(Dash.panel2),
                contentAlignment = Alignment.Center
            ) { Icon(Icons.Rounded.Wallpaper, null, tint = Dash.dim, modifier = Modifier.size(20.dp)) }
            Spacer(Modifier.width(14.dp))
            Column(Modifier.weight(1f)) {
                Text("Dash background", color = Dash.ink, fontFamily = BodyFamily, fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
                Text("A backdrop behind the dash — a preset or your own photo", color = Dash.dim, fontFamily = BodyFamily, fontSize = 13.sp)
            }
        }
        Spacer(Modifier.height(12.dp))
        Row(
            Modifier.fillMaxWidth().horizontalScroll(rememberScrollState()),
            horizontalArrangement = Arrangement.spacedBy(10.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            // none
            SwatchBox(selected = vm.bgType == "none", onTap = { vm.clearBg() }) {
                Icon(Icons.Rounded.Block, null, tint = Dash.faint, modifier = Modifier.size(18.dp))
            }
            // built-in presets
            BgPresetKeys.forEach { key ->
                SwatchBox(
                    selected = vm.bgType == "preset" && vm.bgKey == key,
                    brush = bgPresetBrush(key),
                    onTap = { vm.setBgPreset(key) },
                )
            }
            // current photo (tap to clear)
            if (vm.bgType == "image") {
                vm.bgImageUri?.let { uri ->
                    SwatchBox(selected = true, onTap = { vm.clearBg() }) {
                        UriImage(uri, modifier = Modifier.fillMaxSize())
                    }
                }
            }
            // upload
            Row(
                Modifier.height(38.dp).clip(RoundedCornerShape(10.dp)).background(Dash.panel2)
                    .border(1.dp, Dash.line, RoundedCornerShape(10.dp))
                    .pointerInput(Unit) { detectTapGestures { picker.launch(arrayOf("image/*")) } }
                    .padding(horizontal = 12.dp),
                verticalAlignment = Alignment.CenterVertically
            ) {
                Icon(Icons.Rounded.Image, null, tint = Dash.dim, modifier = Modifier.size(16.dp))
                Spacer(Modifier.width(8.dp))
                Text(if (vm.bgType == "image") "CHANGE" else "UPLOAD", color = Dash.dim,
                    fontFamily = DisplayFamily, fontSize = 11.sp, letterSpacing = 0.8.sp)
            }
        }
    }
}

@Composable
private fun SwatchBox(
    selected: Boolean,
    brush: Brush? = null,
    onTap: () -> Unit,
    content: @Composable BoxScope.() -> Unit = {},
) {
    Box(
        Modifier.size(width = 54.dp, height = 38.dp).clip(RoundedCornerShape(10.dp))
            .then(if (brush != null) Modifier.background(brush) else Modifier.background(Dash.panel2))
            .border(2.dp, if (selected) Dash.amber else Dash.line, RoundedCornerShape(10.dp))
            .pointerInput(Unit) { detectTapGestures { onTap() } },
        contentAlignment = Alignment.Center,
        content = content,
    )
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
