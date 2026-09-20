package cloud.synergytech.opendash.model

import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateListOf
import androidx.compose.runtime.mutableStateOf
import androidx.compose.runtime.setValue
import androidx.compose.runtime.snapshots.SnapshotStateList
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import kotlinx.coroutines.channels.Channel
import kotlinx.coroutines.delay
import kotlinx.coroutines.flow.receiveAsFlow
import kotlinx.coroutines.launch
import java.text.SimpleDateFormat
import java.util.Date
import java.util.Locale
import kotlin.random.Random

data class Track(val title: String, val artist: String, val duration: Int, val seed: Int)

enum class Screen(val label: String) { NOW("Now Playing"), MEDIA("Media"), CLIMATE("Climate"), PHONE("Phone"), SETTINGS("Settings") }

/** A toast request surfaced to the UI. */
data class Toast(val message: String, val danger: Boolean)

/**
 * All OpenDash state and behaviour. The UI is a pure function of this; the
 * delete button removes a row from [tracks] (a real observable list), the
 * position advances on a 1 Hz coroutine, and the clock ticks the same way.
 */
class DashViewModel : ViewModel() {

    // ---- media library ----
    val tracks: SnapshotStateList<Track> = mutableStateListOf(
        Track("Cold Start", "Idle Hands", 222, 1),
        Track("Amber Cluster", "Nightdrive", 255, 2),
        Track("Other Side of the Pillow", "Kova", 178, 3),
        Track("Thumb Drive Symphony", "USB 1", 320, 4),
        Track("Delete Button", "The Engineers", 187, 5),
        Track("Ham Radio Heartbreak", "Clusterfunk", 231, 6),
        Track("DIN Mount Blues", "Scary Side", 242, 7),
    )
    val usedMb: Float get() = tracks.size * 7.4f

    // ---- playback ----
    var index by mutableIntStateOf(1); private set
    var position by mutableIntStateOf(64); private set
    var playing by mutableStateOf(true); private set
    var volume by mutableIntStateOf(62)
    var source by mutableStateOf("USB"); private set
    var shuffle by mutableStateOf(false); private set
    var repeat by mutableStateOf(false); private set

    val hasTrack: Boolean get() = tracks.isNotEmpty()
    val current: Track? get() = tracks.getOrNull(index)

    // ---- climate ----
    var driverTemp by mutableIntStateOf(70); private set
    var passengerTemp by mutableIntStateOf(72); private set
    var fan by mutableIntStateOf(3); private set
    var ac by mutableStateOf(true); private set
    var auto by mutableStateOf(true); private set
    var recirc by mutableStateOf(false); private set
    var defrostFront by mutableStateOf(false); private set
    var defrostRear by mutableStateOf(false); private set
    var seatLeft by mutableIntStateOf(2); private set
    var seatRight by mutableIntStateOf(0); private set

    // ---- shell ----
    var screen by mutableStateOf(Screen.NOW)
    var day by mutableStateOf(false)
    var units by mutableStateOf("F"); private set
    val brightness = 80
    val outsideTempF = 41
    var clock by mutableStateOf(""); private set
    var date by mutableStateOf(""); private set

    // ---- toast channel ----
    private val _toasts = Channel<Toast>(Channel.CONFLATED)
    val toasts = _toasts.receiveAsFlow()

    init {
        updateClock()
        // playback tick
        viewModelScope.launch {
            while (true) { delay(1000); tick() }
        }
        // clock tick
        viewModelScope.launch {
            while (true) { delay(1000); updateClock() }
        }
    }

    // ---- transport ----
    fun playPause() { if (hasTrack) playing = !playing }

    fun next() {
        if (!hasTrack) return
        index = if (shuffle && tracks.size > 1) {
            var n = index; while (n == index) n = Random.nextInt(tracks.size); n
        } else (index + 1) % tracks.size
        position = 0; playing = true
    }

    fun prev() {
        if (!hasTrack) return
        if (position > 4) position = 0
        else { index = (index - 1 + tracks.size) % tracks.size; position = 0 }
        playing = true
    }

    fun toggleShuffle() { shuffle = !shuffle; toast(if (shuffle) "Shuffle on" else "Shuffle off") }
    fun toggleRepeat() { repeat = !repeat; toast(if (repeat) "Repeat on" else "Repeat off") }

    fun selectSource(s: String) { source = s; toast("Source: <b>$s</b>") }

    fun playAt(i: Int) {
        if (i in tracks.indices) { index = i; position = 0; playing = true; screen = Screen.NOW }
    }

    fun seekFraction(frac: Float) {
        val t = current ?: return
        position = (frac.coerceIn(0f, 1f) * t.duration).toInt()
    }

    fun deleteAt(i: Int) {
        if (i !in tracks.indices) return
        val gone = tracks.removeAt(i)
        if (index >= tracks.size) index = (tracks.size - 1).coerceAtLeast(0)
        if (tracks.isEmpty()) playing = false
        toast("Removed <b>${gone.title}</b> — see? A delete button. Was that so hard?", danger = true)
    }

    fun deleteCurrent() = deleteAt(index)

    // ---- climate ----
    fun nudgeTemp(zone: String, delta: Int) {
        when (zone) {
            "driver" -> driverTemp = (driverTemp + delta).coerceIn(60, 85)
            "passenger" -> passengerTemp = (passengerTemp + delta).coerceIn(60, 85)
        }
    }

    fun setFanSpeed(f: Int) { fan = f.coerceIn(0, 6) }

    fun toggleClimate(key: String) {
        when (key) {
            "ac" -> ac = !ac
            "auto" -> auto = !auto
            "recirc" -> recirc = !recirc
            "defrostFront" -> defrostFront = !defrostFront
            "defrostRear" -> defrostRear = !defrostRear
        }
    }

    fun setSeat(side: String, level: Int) {
        when (side) {
            "left" -> seatLeft = if (seatLeft == level) level - 1 else level
            "right" -> seatRight = if (seatRight == level) level - 1 else level
        }
        seatLeft = seatLeft.coerceIn(0, 3); seatRight = seatRight.coerceIn(0, 3)
    }

    // ---- settings ----
    fun toggleUnits() { units = if (units == "F") "C" else "F" }

    private fun toast(message: String, danger: Boolean = false) {
        _toasts.trySend(Toast(message, danger))
    }

    private fun tick() {
        if (!playing || !hasTrack) return
        val t = current ?: return
        position += 1
        if (position >= t.duration) {
            position = 0
            if (!repeat) index = (index + 1) % tracks.size
        }
    }

    private val clockFmt = SimpleDateFormat("HH:mm:ss", Locale.US)
    private val dateFmt = SimpleDateFormat("EEE MMM d", Locale.US)
    private fun updateClock() {
        val now = Date()
        clock = clockFmt.format(now)
        date = dateFmt.format(now).uppercase(Locale.US)
    }
}
