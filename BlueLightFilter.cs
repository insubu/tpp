using System;
using System.Drawing;
using System.Runtime.InteropServices;
using System.Windows.Forms;

class BlueLightOverlay : Form
{
    // Win32 constants
    const int WS_EX_LAYERED = 0x80000;
    const int WS_EX_TRANSPARENT = 0x20;
    const int WS_EX_TOOLWINDOW = 0x80;
    const int GWL_EXSTYLE = -20;

    [DllImport("user32.dll")]
    static extern int GetWindowLong(IntPtr hWnd, int nIndex);

    [DllImport("user32.dll")]
    static extern int SetWindowLong(IntPtr hWnd, int nIndex, int dwNewLong);

    [DllImport("user32.dll")]
    static extern bool SetLayeredWindowAttributes(IntPtr hwnd, uint crKey, byte bAlpha, uint dwFlags);

    const uint LWA_COLORKEY = 0x1;
    const uint LWA_ALPHA = 0x2;

    public BlueLightOverlay(Screen screen)
    {
        this.FormBorderStyle = FormBorderStyle.None;
        this.Bounds = screen.Bounds;
        this.TopMost = true;
        this.ShowInTaskbar = false;
        this.StartPosition = FormStartPosition.Manual;
        this.BackColor = Color.OrangeRed;
        this.Opacity = 0.3; // adjust for strength
        this.Load += OnLoad;
    }

    private void OnLoad(object sender, EventArgs e)
    {
        IntPtr hWnd = this.Handle;

        int exStyle = GetWindowLong(hWnd, GWL_EXSTYLE);
        exStyle |= WS_EX_LAYERED | WS_EX_TRANSPARENT | WS_EX_TOOLWINDOW;
        SetWindowLong(hWnd, GWL_EXSTYLE, exStyle);

        // Optional: true transparency (not needed if using Opacity)
        // SetLayeredWindowAttributes(hWnd, 0, 255, LWA_ALPHA);
    }

    [STAThread]
    static void Main()
    {
        Screen[] screens = Screen.AllScreens;

        if (screens.Length < 2)
        {
            MessageBox.Show("At least 2 monitors are required.");
            return;
        }

        Application.EnableVisualStyles();
        Application.SetCompatibleTextRenderingDefault(false);

        var overlay = new BlueLightOverlay(screens[1]); // 2nd monitor
        Application.Run(overlay);
    }
}
