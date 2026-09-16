namespace TotalFreeConvert.Desktop;

internal static class Program
{
    [STAThread]
    private static void Main(string[] args)
    {
        ApplicationConfiguration.Initialize();
        bool smokeTest = args.Contains("--smoke-test", StringComparer.OrdinalIgnoreCase);
        Application.Run(new MainForm(smokeTest));
    }
}
