import pyautogui
from PIL import Image

# 捕获屏幕
screenshot = pyautogui.screenshot()

# 保存临时文件
screenshot.save("screenshot.png")
print("已保存 screenshot.png，可手动复制到剪贴板")
