package cloud.synergytech.opendash.ui.screens

import androidx.compose.foundation.background
import androidx.compose.foundation.border
import androidx.compose.foundation.gestures.detectHorizontalDragGestures
import androidx.compose.foundation.gestures.detectTapGestures
import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.aspectRatio
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
import androidx.compose.material.icons.rounded.DeleteOutline
import androidx.compose.material.icons.rounded.Pause
import androidx.compose.material.icons.rounded.PlayArrow
import androidx.compose.material.icons.rounded.Repeat
import androidx.compose.material.icons.rounded.Shuffle
import androidx.compose.material.icons.rounded.SkipNext
import androidx.compose.material.icons.rounded.SkipPrevious
import androidx.compose.material.icons.rounded.VolumeUp
import androidx.compose.material3.Icon
import androidx.compose.material3.Slider
import androidx.compose.material3.SliderDefaults
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.graphics.vector.ImageVector
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import cloud.synergytech.opendash.model.DashViewModel
import cloud.synergytech.opendash.ui.components.AlbumArt
import cloud.synergytech.opendash.ui.components.ViewHeading
import cloud.synergytech.opendash.ui.components.fmtTime
import cloud.synergytech.opendash.ui.theme.BodyFamily
import cloud.synergytech.opendash.ui.theme.Dash
import cloud.synergytech.opendash.ui.theme.DisplayFamily

@Composable
fun NowPlayingScreen(vm: DashViewModel) {
    Column(
        Modifier
            .fillMaxSize()
            .verticalScroll(rememberScrollState())
            .padding(20.dp)
    ) {
        ViewHeading("Now Playing")
        Spacer(Modifier.height(16.dp))

        val track = vm.current
        if (track == null) {
            Text(
                "Nothing loaded. Add a thumb drive or pick a source.",
                color = Dash.dim, fontFamily = BodyFamily, fontSize = 16.sp,
                modifier = Modifier.padding(top = 40.dp)
            )
            return@Column
        }

        Row(verticalAlignment = Alignment.CenterVertically) {
            Box(Modifier.width(220.dp).aspectRatio(1f)) {
                AlbumArt(track.seed, Modifier.fillMaxSize(), corner = 18.dp)
                Box(
                    Modifier.align(Alignment.BottomStart).padding(14.dp)
                        .clip(RoundedCornerShape(20.dp)).background(Color(0x47000000))
                        .padding(horizontal = 9.dp, vertical = 4.dp)
                ) {
                    Text(vm.source.uppercase(), color = Color.White,
                        fontFamily = DisplayFamily, fontSize = 11.sp, letterSpacing = 1.4.sp)
                }
            }
            Spacer(Modifier.width(26.dp))

            Column(Modifier.weight(1f)) {
                Text(track.title, color = Dash.ink, fontFamily = BodyFamily,
                    fontSize = 30.sp, fontWeight = FontWeight.Bold,
                    maxLines = 1, overflow = TextOverflow.Ellipsis)
                Text(track.artist, color = Dash.dim, fontFamily = BodyFamily, fontSize = 16.sp)
                Spacer(Modifier.height(18.dp))

                // progress (tap / drag to seek)
                val pct = if (track.duration > 0) (vm.position.toFloat() / track.duration).coerceIn(0f, 1f) else 0f
                Box(
                    Modifier.fillMaxWidth().height(6.dp)
                        .clip(RoundedCornerShape(3.dp)).background(Dash.raise)
                        .pointerInput(track) {
                            detectTapGestures { vm.seekFraction(it.x / size.width) }
                        }
                        .pointerInput(track) {
                            detectHorizontalDragGestures { change, _ ->
                                vm.seekFraction(change.position.x / size.width)
                            }
                        }
                ) {
                    Box(
                        Modifier.fillMaxWidth(pct).height(6.dp).clip(RoundedCornerShape(3.dp))
                            .background(Brush.horizontalGradient(listOf(Dash.amberDim, Dash.amber)))
                    )
                }
                Spacer(Modifier.height(7.dp))
                Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
                    Text(fmtTime(vm.position), color = Dash.faint, fontFamily = DisplayFamily, fontSize = 12.sp)
                    Text("-" + fmtTime(track.duration - vm.position), color = Dash.faint,
                        fontFamily = DisplayFamily, fontSize = 12.sp)
                }

                Spacer(Modifier.height(16.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    RoundButton(Icons.Rounded.Shuffle, 44.dp, active = vm.shuffle) { vm.toggleShuffle() }
                    Spacer(Modifier.width(10.dp))
                    RoundButton(Icons.Rounded.SkipPrevious, 52.dp) { vm.prev() }
                    Spacer(Modifier.width(10.dp))
                    RoundButton(if (vm.playing) Icons.Rounded.Pause else Icons.Rounded.PlayArrow,
                        66.dp, primary = true) { vm.playPause() }
                    Spacer(Modifier.width(10.dp))
                    RoundButton(Icons.Rounded.SkipNext, 52.dp) { vm.next() }
                    Spacer(Modifier.width(10.dp))
                    RoundButton(Icons.Rounded.Repeat, 44.dp, active = vm.repeat) { vm.toggleRepeat() }
                    Spacer(Modifier.weight(1f))
                    DeleteButton { vm.deleteCurrent() }
                }

                Spacer(Modifier.height(18.dp))
                Row(verticalAlignment = Alignment.CenterVertically) {
                    Icon(Icons.Rounded.VolumeUp, null, tint = Dash.dim, modifier = Modifier.size(18.dp))
                    Spacer(Modifier.width(10.dp))
                    Slider(
                        value = vm.volume.toFloat(), onValueChange = { vm.volume = it.toInt() },
                        valueRange = 0f..100f, modifier = Modifier.weight(1f),
                        colors = SliderDefaults.colors(
                            thumbColor = Dash.amber, activeTrackColor = Dash.amber,
                            inactiveTrackColor = Dash.raise,
                        )
                    )
                    Spacer(Modifier.width(16.dp))
                    SourceToggle(vm)
                }
            }
        }
    }
}

@Composable
private fun RoundButton(
    icon: ImageVector, diameter: androidx.compose.ui.unit.Dp,
    primary: Boolean = false, active: Boolean = false, onClick: () -> Unit
) {
    val bg = if (primary) Dash.amber else Dash.panel
    Box(
        Modifier.size(diameter).clip(CircleShape).background(bg)
            .then(if (primary) Modifier else Modifier.border(1.dp, if (active) Dash.amberDim else Dash.line, CircleShape))
            .pointerInput(Unit) { detectTapGestures { onClick() } },
        contentAlignment = Alignment.Center
    ) {
        Icon(icon, null,
            tint = if (primary) Dash.onAmber else if (active) Dash.amber else Dash.ink,
            modifier = Modifier.size(diameter * 0.42f))
    }
}

@Composable
private fun DeleteButton(onClick: () -> Unit) {
    Row(
        Modifier.height(52.dp).clip(RoundedCornerShape(26.dp))
            .background(Color(0x14FF5F57)).border(1.dp, Color(0xFF4A2530), RoundedCornerShape(26.dp))
            .pointerInput(Unit) { detectTapGestures { onClick() } }
            .padding(horizontal = 18.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        Icon(Icons.Rounded.DeleteOutline, null, tint = Dash.bad, modifier = Modifier.size(18.dp))
        Spacer(Modifier.width(9.dp))
        Text("DELETE", color = Dash.bad, fontFamily = DisplayFamily,
            fontSize = 12.sp, letterSpacing = 1.2.sp, fontWeight = FontWeight.SemiBold)
    }
}

@Composable
private fun SourceToggle(vm: DashViewModel) {
    Row(
        Modifier.clip(RoundedCornerShape(22.dp)).background(Dash.panel)
            .border(1.dp, Dash.line, RoundedCornerShape(22.dp)).padding(4.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        listOf("USB", "Bluetooth", "Radio").forEach { s ->
            val on = vm.source == s
            Box(
                Modifier.clip(RoundedCornerShape(18.dp))
                    .background(if (on) Dash.raise else Color.Transparent)
                    .pointerInput(s) { detectTapGestures { vm.selectSource(s) } }
                    .padding(horizontal = 14.dp, vertical = 7.dp)
            ) {
                Text(s.uppercase(), color = if (on) Dash.ink else Dash.dim,
                    fontFamily = DisplayFamily, fontSize = 12.sp, letterSpacing = 0.9.sp)
            }
        }
    }
}
