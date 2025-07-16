using System;
using System.Runtime.InteropServices;

class MonitorNightMode
{
    const int PHYSICAL_MONITOR_DESCRIPTION_SIZE = 128;

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Auto)]
    struct PHYSICAL_MONITOR
    {
        public IntPtr hPhysicalMonitor;

        [MarshalAs(UnmanagedType.ByValTStr, SizeConst = PHYSICAL_MONITOR_DESCRIPTION_SIZE)]
        public string szPhysicalMonitorDescription;
    }

    [DllImport("user32.dll")]
    static extern bool EnumDisplayMonitors(IntPtr hdc, IntPtr lprcClip,
        MonitorEnumProc lpfnEnum, IntPtr dwData);

    [DllImport("dxva2.dll", SetLastError = true)]
    static extern bool GetMonitorBrightness(IntPtr hMonitor, out uint pdwMinimumBrightness, out uint pdwCurrentBrightness, out uint pdwMaximumBrightness);

    [DllImport("dxva2.dll", SetLastError = true)]
    static extern bool SetMonitorBrightness(IntPtr hMonitor, uint dwNewBrightness);

    [DllImport("dxva2.dll", SetLastError = true)]
    static extern bool GetNumberOfPhysicalMonitorsFromHMONITOR(IntPtr hMonitor, out uint pdwNumberOfPhysicalMonitors);

    [DllImport("dxva2.dll", SetLastError = true)]
    static extern bool GetPhysicalMonitorsFromHMONITOR(IntPtr hMonitor, uint dwPhysicalMonitorArraySize,
        [Out] PHYSICAL_MONITOR[] pPhysicalMonitorArray);

    [DllImport("dxva2.dll", SetLastError = true)]
    static extern bool DestroyPhysicalMonitor(IntPtr hMonitor);

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
        Console.WriteLine("Setting brightness to night mode...");
        EnumDisplayMonitors(IntPtr.Zero, IntPtr.Zero, new MonitorEnumProc(MonitorEnum), IntPtr.Zero);
        Console.WriteLine("Done.");
    }

    static bool MonitorEnum(IntPtr hMonitor, IntPtr hdcMonitor, ref RECT lprcMonitor, IntPtr dwData)
    {
        uint numMonitors;
        if (!GetNumberOfPhysicalMonitorsFromHMONITOR(hMonitor, out numMonitors))
        {
            Console.WriteLine("Failed to get monitor count.");
            return true;
        }

        PHYSICAL_MONITOR[] monitors = new PHYSICAL_MONITOR[numMonitors];
        if (!GetPhysicalMonitorsFromHMONITOR(hMonitor, numMonitors, monitors))
        {
            Console.WriteLine("Failed to get monitor handles.");
            return true;
        }

        for (int i = 0; i < monitors.Length; i++)
        {
            PHYSICAL_MONITOR pm = monitors[i];
            uint min, curr, max;

            if (GetMonitorBrightness(pm.hPhysicalMonitor, out min, out curr, out max))
            {
                uint nightBrightness = (uint)(max * 0.2); // 20% brightness
                Console.WriteLine("Monitor: " + pm.szPhysicalMonitorDescription);
                Console.WriteLine("Current: " + curr + ", Target: " + nightBrightness);
                if (SetMonitorBrightness(pm.hPhysicalMonitor, nightBrightness))
                {
                    Console.WriteLine("Brightness set.");
                }
                else
                {
                    Console.WriteLine("Failed to set brightness.");
                }
            }
            else
            {
                Console.WriteLine("Cannot get brightness for: " + pm.szPhysicalMonitorDescription);
            }

            DestroyPhysicalMonitor(pm.hPhysicalMonitor);
        }

        return true; // continue
    }
}
