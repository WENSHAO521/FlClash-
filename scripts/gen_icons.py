"""
Panorama Secure Access flat icon generator.

All generated official icons use a fully transparent background and flat,
opaque mark colors. No glass panel, sheen, gradient, shadow, or catchlight.
"""
from pathlib import Path

from PIL import Image, ImageDraw


BASE = Path(__file__).resolve().parents[1]

TRANSPARENT = (0, 0, 0, 0)

ARC_OUTER = (224, 224, 224, 255)  # #E0E0E0
ARC_MID = (189, 189, 189, 255)    # #BDBDBD
ARC_INNER = (117, 117, 117, 255)  # #757575
RED = (198, 40, 40, 255)          # #C62828
DARK_BASE = (66, 66, 66, 255)     # #424242


def _make_icon(size, inner_arc=ARC_INNER):
    img = Image.new("RGBA", (size, size), TRANSPARENT)
    draw = ImageDraw.Draw(img)
    s = size / 200.0
    sw = max(1, int(8 * s))
    cx = cy = int(100 * s)

    for radius, color in ((60, ARC_OUTER), (45, ARC_MID), (30, inner_arc)):
        rv = int(radius * s)
        bbox = [cx - rv, cy - rv, cx + rv, cy + rv]
        draw.arc(bbox, start=180, end=360, fill=color, width=sw)

    px0, py0 = int(94 * s), int(80 * s)
    px1, py1 = int(106 * s), int(140 * s)
    rr = max(1, int(2 * s))
    draw.rounded_rectangle([px0, py0, px1, py1], radius=rr, fill=RED)

    bx0, by0 = int(40 * s), int(145 * s)
    bx1 = int(160 * s)
    by1 = max(by0 + 1, int(149 * s))
    draw.rectangle([bx0, by0, bx1, by1], fill=DARK_BASE)

    return img


def icon_square(size):
    return _make_icon(size)


def status_icon(size, state):
    colors = {
        1: (16, 185, 129, 255),
        2: (245, 158, 11, 255),
        3: (80, 80, 80, 255),
    }
    return _make_icon(size, colors[state])


def save_ico(path, sizes=(256, 128, 64, 48, 32, 16)):
    imgs = [icon_square(s) for s in sizes]
    imgs[0].save(path, format="ICO", append_images=imgs[1:])
    print(f"  {path}")


def save_png(img, path):
    img.save(path, format="PNG")
    print(f"  {path}")


def save_webp(img, path, quality=92):
    img.save(path, format="WEBP", quality=quality, method=6)
    print(f"  {path}")


print("Main app icons")
save_png(icon_square(550), BASE / "assets/images/icon.png")
save_ico(BASE / "assets/images/icon.ico")

print("Windows runner icon")
save_ico(BASE / "windows/runner/resources/app_icon.ico")

print("Status / tray icons")
for state in (1, 2, 3):
    bp = BASE / f"assets/images/icon/status_{state}"
    save_png(status_icon(108, state), bp.with_suffix(".png"))
    imgs = [status_icon(sz, state) for sz in (64, 32, 22, 16)]
    imgs[0].save(bp.with_suffix(".ico"), format="ICO", append_images=imgs[1:])
    print(f"  {bp.with_suffix('.ico')}")

print("Android launcher icons")
android_res = BASE / "android/app/src/main/res"
for folder, sz in {
    "mipmap-mdpi": 48,
    "mipmap-hdpi": 72,
    "mipmap-xhdpi": 96,
    "mipmap-xxhdpi": 144,
    "mipmap-xxxhdpi": 192,
}.items():
    d = android_res / folder
    save_webp(icon_square(sz), d / "ic_launcher.webp")
    save_webp(icon_square(sz), d / "ic_launcher_round.webp")

print("Android Play Store icon")
save_png(icon_square(512), BASE / "android/app/src/main/ic_launcher-playstore.png")

print("Android TV banner")
bw, bh = 320, 180
banner = Image.new("RGBA", (bw, bh), TRANSPARENT)
ic = icon_square(bh - 16)
banner.paste(ic, (8, 8), ic)
save_png(banner, android_res / "mipmap-xhdpi/ic_banner.png")

print("macOS app icons")
macos_iconset = BASE / "macos/Runner/Assets.xcassets/AppIcon.appiconset"
for sz in (16, 32, 64, 128, 256, 512, 1024):
    save_png(icon_square(sz), macos_iconset / f"app_icon_{sz}.png")

print("\nDone - flat transparent icons generated.")
