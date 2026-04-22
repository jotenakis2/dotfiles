// garder cookies / historique / session
user_pref("privacy.sanitize.sanitizeOnShutdown", false);
user_pref("privacy.clearOnShutdown.cookies", false);
user_pref("privacy.clearOnShutdown.history", false);
user_pref("privacy.clearOnShutdown.formdata", true);
user_pref("browser.startup.page", 3);
user_pref("privacy.clearOnShutdown.sessions", false);
// Re-enable Wayland explicit sync for proper frame timing
 user_pref("widget.wayland.explicit-sync.enabled", true);

// Restore Firefox-stock scroll feel (Zen bakes in a faster/snappier scroll by default)
user_pref("mousewheel.default.delta_multiplier_y", 100);
user_pref("mousewheel.min_line_scroll_amount", 5);
user_pref("general.smoothScroll.mouseWheel.durationMinMS", 200);
user_pref("general.smoothScroll.msdPhysics.enabled", false);
user_pref("general.smoothScroll.stopDecelerationWeighting", "0.4");
user_pref("general.smoothScroll.currentVelocityWeighting", "0.25");
