using System;
using System.Text;
using System.IO;
using System.Runtime.InteropServices;
using System.Diagnostics;
using System.Windows.Forms;

namespace SimpleLauncher
{
    static class Program
    {
        [STAThread]
        static void Main()
        {
            Application.EnableVisualStyles();
            Application.Run(new MainForm());
        }
    }

    public class MainForm : Form
    {
        private Button launchButton;

        public MainForm()
        {
            this.Text = "App Launcher";
            this.StartPosition = FormStartPosition.CenterScreen;
            this.Width = 300;
            this.Height = 150;

            launchButton = new Button();
            launchButton.Text = "Launch App";
            launchButton.Dock = DockStyle.Fill;
            launchButton.Font = new System.Drawing.Font("Segoe UI", 14);
            launchButton.Click += LaunchButton_Click;

            this.Controls.Add(launchButton);
        }

        private void LaunchButton_Click(object sender, EventArgs e)
        {
            string iniPath = Path.Combine(AppDomain.CurrentDomain.BaseDirectory, "config.ini");
            string exePath = IniHelper.ReadValue("App", "Path", iniPath);

            if (string.IsNullOrEmpty(exePath))
            {
                MessageBox.Show("No executable path found in config.ini.", "Missing Config");
                return;
            }

            if (!File.Exists(exePath))
            {
                MessageBox.Show("Executable not found:\n" + exePath, "Error");
                return;
            }

            try
            {
                Process.Start(exePath);
            }
            catch (Exception ex)
            {
                MessageBox.Show("Failed to start the app:\n" + ex.Message, "Error");
            }
        }
    }

    public static class IniHelper
    {
        [DllImport("kernel32.dll", CharSet = CharSet.Auto)]
        private static extern int GetPrivateProfileString(
            string section, string key, string defaultVal,
            StringBuilder returnValue, int size, string filePath);

        public static string ReadValue(string section, string key, string iniPath)
        {
            StringBuilder buffer = new StringBuilder(512);
            GetPrivateProfileString(section, key, "", buffer, buffer.Capacity, iniPath);
            return buffer.ToString();
        }
    }
}
