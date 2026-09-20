package cloud.synergytech.opendash.ui.components

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.width
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.draw.drawWithCache
import androidx.compose.ui.geometry.Offset
import androidx.compose.ui.graphics.Brush
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.text.AnnotatedString
import androidx.compose.ui.text.SpanStyle
import androidx.compose.ui.text.buildAnnotatedString
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.Dp
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import cloud.synergytech.opendash.ui.theme.Dash
import cloud.synergytech.opendash.ui.theme.DisplayFamily
import kotlin.math.max

// Generated album-art palettes (inner, outer), keyed by track seed — the same
// set every OpenDash stack ships, so the art matches across web / Qt / Android.
private val Palettes = listOf(
    Color(0xFFFF9E2C) to Color(0xFF7A3BFF),
    Color(0xFF3AD0D8) to Color(0xFF155E75),
    Color(0xFFFF5F7E) to Color(0xFF7A1F3D),
    Color(0xFF54E07F) to Color(0xFF1C5E3A),
    Color(0xFFFFCF5C) to Color(0xFFB45309),
    Color(0xFF6AA1FF) to Color(0xFF1E2F66),
    Color(0xFFFF7A3C) to Color(0xFF7A2410),
    Color(0xFFC58BFF) to Color(0xFF3B1470),
)

/** A radial-gradient "album cover" derived from the track seed. */
@Composable
fun AlbumArt(seed: Int, modifier: Modifier = Modifier, corner: Dp = 12.dp) {
    val (c0, c1) = Palettes[(seed % Palettes.size + Palettes.size) % Palettes.size]
    Box(
        modifier
            .clip(RoundedCornerShape(corner))
            .drawWithCache {
                val brush = Brush.radialGradient(
                    0f to c0, 0.55f to c1, 1f to Color(0xFF0A0E15),
                    center = Offset(size.width * 0.2f, size.height * 0.15f),
                    radius = max(size.width, size.height) * 1.1f,
                )
                onDrawBehind { drawRect(brush) }
            }
    ) {}
}

/** The "h2.view" section heading: uppercase label + a hairline to the edge. */
@Composable
fun ViewHeading(text: String, modifier: Modifier = Modifier) {
    Row(modifier.fillMaxWidth(), verticalAlignment = Alignment.CenterVertically) {
        Text(
            text.uppercase(),
            color = Dash.dim,
            fontFamily = DisplayFamily,
            fontSize = 14.sp,
            letterSpacing = 2.2.sp,
            fontWeight = FontWeight.SemiBold,
        )
        Spacer(Modifier.width(10.dp))
        Box(
            Modifier
                .weight(1f)
                .height(1.dp)
                .background(Dash.line)
        )
    }
}

/** Convert the tiny "<b>…</b>" markup used in toast/about copy to bold spans. */
fun richText(html: String): AnnotatedString = buildAnnotatedString {
    var i = 0
    var bold = false
    while (i < html.length) {
        when {
            html.startsWith("<b>", i) -> { bold = true; i += 3 }
            html.startsWith("</b>", i) -> { bold = false; i += 4 }
            else -> {
                if (bold) pushStyle(SpanStyle(fontWeight = FontWeight.Bold))
                append(html[i]); i += 1
                if (bold) pop()
            }
        }
    }
}

/** m:ss like the players everyone knows. */
fun fmtTime(seconds: Int): String {
    val s = seconds.coerceAtLeast(0)
    return "${s / 60}:${(s % 60).toString().padStart(2, '0')}"
}
