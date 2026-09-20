package cloud.synergytech.opendash.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
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
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.Call
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import cloud.synergytech.opendash.model.DashViewModel
import cloud.synergytech.opendash.ui.components.ViewHeading
import cloud.synergytech.opendash.ui.theme.BodyFamily
import cloud.synergytech.opendash.ui.theme.Dash
import cloud.synergytech.opendash.ui.theme.DisplayFamily

private data class RecentCall(val name: String, val sub: String)

@Composable
fun PhoneScreen(@Suppress("UNUSED_PARAMETER") vm: DashViewModel) {
    val calls = listOf(
        RecentCall("Boden Research", "Mobile · 2m ago"),
        RecentCall("Shop", "Missed · 1h ago"),
        RecentCall("Voicemail", "1 new"),
    )
    Column(Modifier.fillMaxSize().padding(20.dp)) {
        ViewHeading("Phone")
        Spacer(Modifier.height(14.dp))

        // connected device
        Row(
            Modifier.fillMaxWidth().height(74.dp).clip(RoundedCornerShape(18.dp))
                .background(Dash.panel).border(1.dp, Dash.line, RoundedCornerShape(18.dp))
                .padding(horizontal = 18.dp),
            verticalAlignment = Alignment.CenterVertically
        ) {
            Icon(Icons.Rounded.Call, null, tint = Dash.good, modifier = Modifier.size(26.dp))
            Spacer(Modifier.width(14.dp))
            Column(Modifier.weight(1f)) {
                Text("Pixel 8 — Shane", color = Dash.ink, fontFamily = BodyFamily,
                    fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
                Text("Connected via Bluetooth · calls & media", color = Dash.dim,
                    fontFamily = BodyFamily, fontSize = 13.sp)
            }
            Box(
                Modifier.clip(RoundedCornerShape(20.dp)).background(Dash.panel2)
                    .border(1.dp, Dash.line, RoundedCornerShape(20.dp))
                    .padding(horizontal = 12.dp, vertical = 6.dp)
            ) {
                Text("HD VOICE", color = Dash.dim, fontFamily = DisplayFamily,
                    fontSize = 11.sp, letterSpacing = 0.8.sp)
            }
        }

        Spacer(Modifier.height(14.dp))
        // recents
        Column(
            Modifier.fillMaxWidth().clip(RoundedCornerShape(18.dp)).background(Dash.panel)
                .border(1.dp, Dash.line, RoundedCornerShape(18.dp)).padding(10.dp)
        ) {
            calls.forEachIndexed { i, c ->
                Row(Modifier.fillMaxWidth().height(60.dp), verticalAlignment = Alignment.CenterVertically) {
                    Box(
                        Modifier.size(40.dp).clip(RoundedCornerShape(11.dp)).background(Dash.panel2),
                        contentAlignment = Alignment.Center
                    ) { Icon(Icons.Rounded.Call, null, tint = Dash.dim, modifier = Modifier.size(20.dp)) }
                    Spacer(Modifier.width(14.dp))
                    Column(Modifier.weight(1f)) {
                        Text(c.name, color = Dash.ink, fontFamily = BodyFamily,
                            fontSize = 15.sp, fontWeight = FontWeight.SemiBold)
                        Text(c.sub, color = Dash.dim, fontFamily = BodyFamily, fontSize = 13.sp)
                    }
                    Text("Call", color = Dash.dim, fontFamily = DisplayFamily, fontSize = 14.sp)
                }
                if (i < calls.lastIndex) {
                    Box(Modifier.fillMaxWidth().height(1.dp).background(Dash.line))
                }
            }
        }
    }
}
