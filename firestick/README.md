# Fire TV Stick: debloat and make it child-safe

## 1. Run the debloat script (on a computer on the same Wi-Fi)

1. On the Firestick, go to **Settings > My Fire TV > About** and click **Fire TV Stick** 7 times to enable Developer Options.
2. Go to **Settings > My Fire TV > Developer Options** and turn on **ADB debugging**.
3. Note the IP address shown in **Settings > My Fire TV > About > Network**.
4. Install Android platform-tools (`adb`):
   - macOS: `brew install android-platform-tools`
   - Linux: `sudo apt install adb`
   - Windows: download platform-tools from developer.android.com and run the script in Git Bash.
5. Run `./debloat.sh 192.168.x.x` and accept the **Allow USB debugging** prompt on the TV.

Packages are **disabled, not deleted**. `./restore.sh 192.168.x.x` re-enables all of them.
Edit `packages.txt` to change the list. Do not add the launcher, Appstore or system update packages.

## 2. Ad settings on the Firestick (no tools needed)

- **Settings > Preferences > Privacy Settings**: turn off **Interest-based Ads**, **Device Usage Data** and **Collect App Usage Data**.
- **Settings > Preferences > Featured Content**: turn off **Allow Video Autoplay** and **Allow Audio Autoplay**.
- **Settings > Display & Sounds > Screensaver**: pick your own photos or turn the screensaver off.

## 3. Child safety: this is what actually stops unsuitable ads

The big banner on the Amazon home screen is built into the launcher. Fire OS 7 and later
blocks replacing or disabling the launcher, so no script can fully remove those ads.
What works instead:

- **Parental controls**: **Settings > Preferences > Parental Controls**. Set a PIN and limit
  viewing to an age rating. This hides mature titles from rows and banners, and requires the
  PIN for purchases, app launches and the Appstore.
- **Amazon Kids profile** (Amazon Kids+ subscription optional): a separate home screen with
  only child-appropriate content and no regular Amazon promotions.
- **Family DNS filter on your router** (e.g. a family/adult-content-blocking DNS from
  your ISP, Cloudflare for Families, or a NextDNS profile). This filters adult content and
  ad networks inside apps on every device. Blocking Amazon's own ad domains can break parts
  of the home screen, so start with a family filter only.
