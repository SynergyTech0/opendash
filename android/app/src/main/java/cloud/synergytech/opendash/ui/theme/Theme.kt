package cloud.synergytech.opendash.ui.theme

import androidx.compose.runtime.Composable
import androidx.compose.runtime.CompositionLocalProvider
import androidx.compose.runtime.Immutable
import androidx.compose.runtime.staticCompositionLocalOf
import androidx.compose.ui.graphics.Color

/**
 * OpenDash design tokens, straight from the web preview's CSS variables. Two
 * instances — [NightColors] and [DayColors] — flip the whole instrument look.
 * Provided down the tree via [LocalDash] so any composable can read `Dash.amber`.
 */
@Immutable
data class DashColors(
    val bg: Color,
    val screen: Color,
    val panel: Color,
    val panel2: Color,
    val raise: Color,
    val line: Color,
    val ink: Color,
    val dim: Color,
    val faint: Color,
    val amber: Color,
    val amberDim: Color,
    val cyan: Color,
    val good: Color,
    val bad: Color,
    val onAmber: Color,
)

val NightColors = DashColors(
    bg = Color(0xFF070A0F),
    screen = Color(0xFF0B0F16),
    panel = Color(0xFF121824),
    panel2 = Color(0xFF19212F),
    raise = Color(0xFF212B3B),
    line = Color(0xFF242F40),
    ink = Color(0xFFEEF3F9),
    dim = Color(0xFF8896A8),
    faint = Color(0xFF5C6879),
    amber = Color(0xFFFF9E2C),
    amberDim = Color(0xFFB96F1C),
    cyan = Color(0xFF3AD0D8),
    good = Color(0xFF54E07F),
    bad = Color(0xFFFF5F57),
    onAmber = Color(0xFF0B0F16),
)

val DayColors = DashColors(
    bg = Color(0xFFC9D1DC),
    screen = Color(0xFFEEF1F6),
    panel = Color(0xFFFFFFFF),
    panel2 = Color(0xFFF3F6FB),
    raise = Color(0xFFE7ECF3),
    line = Color(0xFFD3DAE4),
    ink = Color(0xFF161D29),
    dim = Color(0xFF5A6879),
    faint = Color(0xFF8B98A8),
    amber = Color(0xFFE07A12),
    amberDim = Color(0xFFC9690C),
    cyan = Color(0xFF0E9AA2),
    good = Color(0xFF54E07F),
    bad = Color(0xFFFF5F57),
    onAmber = Color(0xFFFFFFFF),
)

val LocalDash = staticCompositionLocalOf { NightColors }

/** Shorthand: `Dash.amber` inside any composable under [OpenDashTheme]. */
val Dash: DashColors
    @Composable get() = LocalDash.current

@Composable
fun OpenDashTheme(day: Boolean, content: @Composable () -> Unit) {
    CompositionLocalProvider(LocalDash provides (if (day) DayColors else NightColors)) {
        content()
    }
}
