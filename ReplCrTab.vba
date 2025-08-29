from PIL import ImageGrab, BmpImagePlugin
import win32clipboard
import io

# 捕获主显示器
img = ImageGrab.grab()  # 默认主屏幕

# 将图片转换为 BMP 格式（Windows 剪贴板需要 DIB）
output = io.BytesIO()
img.convert("RGB").save(output, "BMP")
data = output.getvalue()[14:]  # BMP 文件去掉前 14 字节文件头
output.close()

# 复制到剪贴板
win32clipboard.OpenClipboard()
win32clipboard.EmptyClipboard()
win32clipboard.SetClipboardData(win32clipboard.CF_DIB, data)
win32clipboard.CloseClipboard()

print("屏幕已复制到剪贴板！")
