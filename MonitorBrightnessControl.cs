
using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;

class MonitorBrightnessControl
{
    const int PHYSICAL_MONITOR_DESCRIPTION_SIZE = 128;

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
    struct PHYSICAL_MONITOR
    {
        public IntPtr hPhysicalMonitor;

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = PHYSICAL_MONITOR_DESCRIPTION_SIZE)]
        public string szPhysicalMonitorDescription;
    }

    [DllImport("user32.dll", SetLastError = true)]
    static extern bool GetMonitorInfo(IntPtr hMonitor, ref MONITORINFOEX lpmi);

    [DllImport("user32.dll")]
    static extern bool EnumDisplayMonitors(IntPtr hdc, IntPtr lprcClip,
        MonitorEnumProc lpfnEnum, IntPtr dwData);

    [DllImport("dxva2.dll", SetLastError = true)]
    static extern bool GetMonitorBrightness(IntPtr hMonitor, out uint minBrightness, out uint currentBrightness, out uint maxBrightness);

    [DllImport("dxva2.dll", SetLastError = true)]
    static extern bool SetMonitorBrightness(IntPtr hMonitor, uint newBrightness);

    [DllImport("dxva2.dll", SetLastError = true)]
    static extern bool GetNumberOfPhysicalMonitorsFromHMONITOR(IntPtr hMonitor, out uint pdwNumberOfPhysicalMonitors);

    [DllImport("dxva2.dll", SetLastError = true)]
    static extern bool GetPhysicalMonitorsFromHMONITOR(IntPtr hMonitor, uint dwPhysicalMonitorArraySize,
        [Out] PHYSICAL_MONITOR[] pPhysicalMonitorArray);

    [DllImport("dxva2.dll", SetLastError = true)]
    static extern bool DestroyPhysicalMonitor(IntPtr hMonitor);

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
    struct MONITORINFOEX
    {
        public uint cbSize;
        public RECT rcMonitor;
        public RECT rcWork;
        public uint dwFlags;

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = 32)]
        public string szDevice;
    }

    [StructLayout(LayoutKind.Sequential)]
    struct RECT
    {
        public int left;
        public int top;
        public int right;
        public int bottom;
    }

    delegate bool MonitorEnumProc(IntPtr hMonitor, IntPtr hdcMonitor, ref RECT lprcMonitor, IntPtr dwData);

    static void Main()
    {
        EnumDisplayMonitors(IntPtr.Zero, IntPtr.Zero, MonitorEnum, IntPtr.Zero);
    }

    static bool MonitorEnum(IntPtr hMonitor, IntPtr hdcMonitor, ref RECT lprcMonitor, IntPtr dwData)
    {
        if (GetNumberOfPhysicalMonitorsFromHMONITOR(hMonitor, out uint numMonitors))
        {
            var monitors = new PHYSICAL_MONITOR[numMonitors];
            if (GetPhysicalMonitorsFromHMONITOR(hMonitor, numMonitors, monitors))
            {
                foreach (var pm in monitors)
                {
                    Console.WriteLine("Monitor: " + pm.szPhysicalMonitorDescription);

                    if (GetMonitorBrightness(pm.hPhysicalMonitor, out uint min, out uint current, out uint max))
                    {
                        Console.WriteLine($"Brightness: Min={min}, Current={current}, Max={max}");

                        //uint newBrightness = Math.Min(max, current + 10); // increase brightness by 10
                        uint newBrightness = (uint)(max * 0.3); // ~30% brightness for night mode

                        if (SetMonitorBrightness(pm.hPhysicalMonitor, newBrightness))
                        {
                            Console.WriteLine($"Brightness set to: {newBrightness}");
                        }
                        else
                        {
                            Console.WriteLine("Failed to set brightness.");
                        }
                    }
                    else
                    {
                        Console.WriteLine("Failed to get brightness.");
                    }

                    DestroyPhysicalMonitor(pm.hPhysicalMonitor);
                }
            }
        }
        return true; // continue enumeration
    }
}
