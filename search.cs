using System;
using System.Windows.Automation;

class Program
{
    static void Main()
    {
        // Find the taskbar window
        AutomationElement taskbar = AutomationElement.RootElement.FindFirst(
            TreeScope.Children,
            new PropertyCondition(AutomationElement.ClassNameProperty, "Shell_TrayWnd"));

        if (taskbar != null)
        {
            // Find the search box inside the taskbar
            AutomationElement searchBox = taskbar.FindFirst(
                TreeScope.Descendants,
                new PropertyCondition(AutomationElement.ControlTypeProperty, ControlType.Edit));

            if (searchBox != null)
            {
                Console.WriteLine("Search box found!");
                // Set focus to the search box
                searchBox.SetFocus();
            }
            else
            {
                Console.WriteLine("Search box not found.");
            }
        }
        else
        {
            Console.WriteLine("Taskbar not found.");
        }
    }
}
