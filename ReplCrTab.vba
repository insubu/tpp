from PIL import ImageGrab
from pyperclip_image import copy

# 捕获主显示器
img = ImageGrab.grab()  # 默认抓主屏幕

# 复制到剪贴板
copy(img)

print("屏幕已复制到剪贴板！")
