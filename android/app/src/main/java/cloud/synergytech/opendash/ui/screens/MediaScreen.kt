package cloud.synergytech.opendash.ui.screens

import androidx.compose.animation.core.LinearEasing
import androidx.compose.animation.core.RepeatMode
import androidx.compose.animation.core.StartOffset
import androidx.compose.animation.core.animateFloat
import androidx.compose.animation.core.infiniteRepeatable
import androidx.compose.animation.core.rememberInfiniteTransition
import androidx.compose.animation.core.tween
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
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.itemsIndexed
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.rounded.DeleteOutline
import androidx.compose.material3.Icon
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.input.pointer.pointerInput
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.text.style.TextOverflow
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import cloud.synergytech.opendash.model.DashViewModel
import cloud.synergytech.opendash.model.Track
import cloud.synergytech.opendash.ui.components.AlbumArt
import cloud.synergytech.opendash.ui.components.ViewHeading
import cloud.synergytech.opendash.ui.components.fmtTime
import cloud.synergytech.opendash.ui.theme.BodyFamily
import cloud.synergytech.opendash.ui.theme.Dash
import cloud.synergytech.opendash.ui.theme.DisplayFamily

@Composable
fun MediaScreen(vm: DashViewModel) {
    Column(Modifier.fillMaxSize().padding(20.dp)) {
        ViewHeading("Media")
        Spacer(Modifier.height(12.dp))

        Row(Modifier.fillMaxWidth(), horizontalArrangement = Arrangement.SpaceBetween) {
            Text("USB 1  ·  ${vm.tracks.size} tracks", color = Dash.dim,
                fontFamily = DisplayFamily, fontSize = 12.sp, letterSpacing = 0.9.sp)
            Text(String.format("%.1f MB / 32 GB", vm.usedMb), color = Dash.faint,
                fontFamily = DisplayFamily, fontSize = 12.sp, letterSpacing = 0.9.sp)
        }
        Spacer(Modifier.height(12.dp))

        if (vm.tracks.isEmpty()) {
            Text("Library empty — every track deleted. Bold move.",
                color = Dash.dim, fontFamily = BodyFamily, fontSize = 16.sp,
                modifier = Modifier.fillMaxWidth().padding(top = 30.dp))
            return@Column
        }

        LazyColumn(verticalArrangement = Arrangement.spacedBy(6.dp)) {
            itemsIndexed(vm.tracks, key = { _, t -> t.title }) { i, track ->
                TrackRow(track, current = i == vm.index, playing = vm.playing,
                    onPlay = { vm.playAt(i) }, onDelete = { vm.deleteAt(i) })
            }
        }
    }
}

@Composable
private fun TrackRow(track: Track, current: Boolean, playing: Boolean, onPlay: () -> Unit, onDelete: () -> Unit) {
    Row(
        Modifier.fillMaxWidth().height(64.dp).clip(RoundedCornerShape(12.dp))
            .background(if (current) Dash.panel else Color.Transparent)
            .then(if (current) Modifier.border(1.dp, Dash.line, RoundedCornerShape(12.dp)) else Modifier)
            .pointerInput(track) { detectTapGestures { onPlay() } }
            .padding(horizontal = 12.dp),
        verticalAlignment = Alignment.CenterVertically
    ) {
        AlbumArt(track.seed, Modifier.size(44.dp), corner = 10.dp)
        Spacer(Modifier.width(14.dp))
        Column(Modifier.weight(1f)) {
            Text(track.title, color = Dash.ink, fontFamily = BodyFamily, fontSize = 15.sp,
                fontWeight = FontWeight.SemiBold, maxLines = 1, overflow = TextOverflow.Ellipsis)
            Text(track.artist, color = Dash.dim, fontFamily = BodyFamily, fontSize = 13.sp,
                maxLines = 1, overflow = TextOverflow.Ellipsis)
        }
        if (current && playing) {
            Equalizer()
        } else {
            Text(fmtTime(track.duration), color = Dash.faint, fontFamily = DisplayFamily, fontSize = 13.sp)
        }
        Spacer(Modifier.width(6.dp))
        Box(
            Modifier.size(38.dp).clip(RoundedCornerShape(10.dp))
                .pointerInput(track) { detectTapGestures { onDelete() } },
            contentAlignment = Alignment.Center
        ) {
            Icon(Icons.Rounded.DeleteOutline, "Delete ${track.title}",
                tint = Dash.faint, modifier = Modifier.size(19.dp))
        }
    }
}

@Composable
private fun Equalizer() {
    val t = rememberInfiniteTransition(label = "eq")
    Row(Modifier.height(16.dp), verticalAlignment = Alignment.Bottom,
        horizontalArrangement = Arrangement.spacedBy(2.dp)) {
        repeat(4) { i ->
            val h by t.animateFloat(
                initialValue = 5f, targetValue = 16f,
                animationSpec = infiniteRepeatable(
                    tween(450, easing = LinearEasing),
                    RepeatMode.Reverse,
                    initialStartOffset = StartOffset(i * 90),
                ), label = "bar$i"
            )
            Box(Modifier.width(3.dp).height(h.dp).clip(RoundedCornerShape(2.dp)).background(Dash.amber))
        }
    }
}
