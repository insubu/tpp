using System;
using System.Runtime.InteropServices;
using System.Text;

class Program
{
    const int SQLITE_OK = 0;
    const int SQLITE_ROW = 100;

    [DllImport("sqlite3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern int sqlite3_open(string filename, out IntPtr db);

    [DllImport("sqlite3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern int sqlite3_close(IntPtr db);

    [DllImport("sqlite3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern int sqlite3_prepare_v2(IntPtr db, string sql, int numBytes, out IntPtr stmt, IntPtr pzTail);

    [DllImport("sqlite3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern int sqlite3_step(IntPtr stmt);

    [DllImport("sqlite3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern IntPtr sqlite3_column_text(IntPtr stmt, int colIndex);

    [DllImport("sqlite3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern int sqlite3_finalize(IntPtr stmt);

    [DllImport("sqlite3.dll", CallingConvention = CallingConvention.Cdecl)]
    public static extern int sqlite3_bind_text(IntPtr stmt, int index, string value, int n, IntPtr free);
    
    static void Main()
    {
        IntPtr db;
        if (sqlite3_open("your.db", out db) != SQLITE_OK)
        {
            Console.WriteLine("Failed to open database.");
            return;
        }

        string sql = "SELECT name FROM sqlite_master WHERE type='table';";
        IntPtr stmt;
        if (sqlite3_prepare_v2(db, sql, -1, out stmt, IntPtr.Zero) != SQLITE_OK)
        {
            Console.WriteLine("Failed to prepare statement.");
            sqlite3_close(db);
            return;
        }

        sqlite3_bind_text(stmt, 1, "%" + keyword + "%", -1, new IntPtr(-1));

        while (sqlite3_step(stmt) == SQLITE_ROW)
        {
            IntPtr textPtr = sqlite3_column_text(stmt, 0);
            string tableName = Marshal.PtrToStringAnsi(textPtr);
            Console.WriteLine("Table: " + tableName);
        }

        sqlite3_finalize(stmt);
        sqlite3_close(db);
    }
}
