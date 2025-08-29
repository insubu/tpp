from PIL import ImageGrab
import win32clipboard
import win32con
import io

# Capture the entire screen
img = ImageGrab.grab()

# Save image to a bytes buffer in BMP format (required for clipboard)
output = io.BytesIO()
img.save(output, format='BMP')
data = output.getvalue()[14:]  # Strip BMP header (first 14 bytes)

# Copy to clipboard
win32clipboard.OpenClipboard()
win32clipboard.EmptyClipboard()
win32clipboard.SetClipboardData(win32con.CF_DIB, data)
win32clipboard.CloseClipboard()

print("Main screen copied to clipboard.")
