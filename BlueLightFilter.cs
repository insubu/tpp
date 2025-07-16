using System;
using System.Drawing;
using System.Windows.Forms;

class BlueLightFilter : Form
{
    public BlueLightFilter(Screen targetScreen)
    {
        this.FormBorderStyle = FormBorderStyle.None;
        this.Bounds = targetScreen.Bounds;
        this.TopMost = true;
        this.StartPosition = FormStartPosition.Manual;
        this.ShowInTaskbar = false;
        this.BackColor = Color.OrangeRed;  // Warm color overlay
        this.Opacity = 0.2;                // 20% opacity
        this.WindowState = FormWindowState.Normal;

        // Remove click-through block (optional)
        this.Load += (s, e) =>
        {
            this.Location = targetScreen.Bounds.Location;
        };
    }

    [STAThread]
    static void Main()
    {
        Application.EnableVisualStyles();
        Application.SetCompatibleTextRenderingDefault(false);

        Screen[] screens = Screen.AllScreens;

        if (screens.Length < 2)
        {
            MessageBox.Show("You need at least 2 displays.");
            return;
        }

        Screen secondScreen = screens[1]; // index 0 is primary

        Application.Run(new BlueLightFilter(secondScreen));
    }
}
