package cloud.synergytech.opendash.ui.theme

import androidx.compose.ui.text.font.FontFamily

/**
 * The web preview uses Chakra Petch (instrument / numeric) and Barlow (body).
 * To match exactly, drop the .ttf files in res/font and swap these to
 * FontFamily(Font(R.font.chakra_petch)) / FontFamily(Font(R.font.barlow)).
 * Until then they fall back to the platform sans, which reads fine on a dash.
 */
val DisplayFamily = FontFamily.SansSerif
val BodyFamily = FontFamily.SansSerif
