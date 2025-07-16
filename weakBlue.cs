using System;
using System.Runtime.InteropServices;
using System.Windows.Forms;

class ColorTemperatureAdjuster
{
    [DllImport("gdi32.dll")]
    static extern bool SetDeviceGammaRamp(IntPtr hDC, ref RAMP lpRamp);

    [DllImport("user32.dll")]
    static extern IntPtr GetDC(IntPtr hWnd);

    [StructLayout(LayoutKind.Sequential, CharSet = CharSet.Ansi)]
    struct RAMP
    {
        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 256)]
        public ushort[] Red;

        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 256)]
        public ushort[] Green;

        [MarshalAs(UnmanagedType.ByValArray, SizeConst = 256)]
        public ushort[] Blue;
    }

    static void Main()
    {
        Console.WriteLine("Applying warm color filter...");

        IntPtr hdc = GetDC(IntPtr.Zero);

        RAMP ramp = new RAMP();
        ramp.Red = new ushort[256];
        ramp.Green = new ushort[256];
        ramp.Blue = new ushort[256];

        // Adjust these values to change warmth
        double redFactor = 1.0;   // full red
        double greenFactor = 0.85;
        double blueFactor = 0.65; // reduce blue for warmth

        for (int i = 0; i < 256; i++)
        {
            int val = i * 256;

            ramp.Red[i] = (ushort)Math.Min(65535, val * redFactor);
            ramp.Green[i] = (ushort)Math.Min(65535, val * greenFactor);
            ramp.Blue[i] = (ushort)Math.Min(65535, val * blueFactor);
        }

        bool result = SetDeviceGammaRamp(hdc, ref ramp);

        if (result)
            Console.WriteLine("Warm filter applied!");
        else
            Console.WriteLine("Failed to apply gamma ramp.");
    }
}
