using Microsoft.Web.WebView2.Core;
using Microsoft.Web.WebView2.WinForms;

namespace TotalFreeConvert.Desktop;

internal sealed class MainForm : Form
{
    private const string AppOrigin = "https://tfc.local/";
    private readonly WebView2 browser = new() { Dock = DockStyle.Fill };
    private readonly bool smokeTest;
    private readonly System.Windows.Forms.Timer smokeTimer = new() { Interval = 15000 };

    public MainForm(bool smokeTest = false)
    {
        this.smokeTest = smokeTest;
        Text = $"Total Free Convert — v{Application.ProductVersion}";
        StartPosition = FormStartPosition.CenterScreen;
        MinimumSize = new Size(760, 620);
        ClientSize = new Size(1180, 780);
        BackColor = Color.FromArgb(25, 25, 25);
        if (smokeTest)
        {
            Opacity = 0;
            ShowInTaskbar = false;
            FormBorderStyle = FormBorderStyle.None;
            Size = new Size(2, 2);
            smokeTimer.Tick += (_, _) => FinishSmokeTest(2);
            smokeTimer.Start();
        }
        Controls.Add(browser);
        Shown += InitializeBrowserAsync;
    }

    private async void InitializeBrowserAsync(object? sender, EventArgs e)
    {
        Shown -= InitializeBrowserAsync;

        try
        {
            string webRoot = Path.Combine(AppContext.BaseDirectory, "wwwroot");
            string indexFile = Path.Combine(webRoot, "index.html");
            if (!File.Exists(indexFile))
                throw new FileNotFoundException("The local converter files are missing.", indexFile);

            string userData = Path.Combine(
                Environment.GetFolderPath(Environment.SpecialFolder.LocalApplicationData),
                "Total Free Convert", "WebView2");
            Directory.CreateDirectory(userData);

            CoreWebView2Environment environment = await CoreWebView2Environment.CreateAsync(null, userData);
            await browser.EnsureCoreWebView2Async(environment);
            CoreWebView2 core = browser.CoreWebView2;

            core.SetVirtualHostNameToFolderMapping(
                "tfc.local", webRoot, CoreWebView2HostResourceAccessKind.DenyCors);
            core.Settings.AreDevToolsEnabled = false;
            core.Settings.AreDefaultContextMenusEnabled = false;
            core.Settings.IsStatusBarEnabled = false;
            core.Settings.IsZoomControlEnabled = true;
            core.NavigationStarting += (_, args) =>
            {
                if (!args.Uri.StartsWith(AppOrigin, StringComparison.OrdinalIgnoreCase))
                    args.Cancel = true;
            };
            core.NewWindowRequested += (_, args) => args.Handled = true;
            core.DownloadStarting += HandleDownloadStarting;
            if (smokeTest)
                core.NavigationCompleted += (_, args) => FinishSmokeTest(args.IsSuccess ? 0 : 3);
            core.Navigate(AppOrigin + "index.html");
        }
        catch (WebView2RuntimeNotFoundException)
        {
            ShowStartupError("Microsoft Edge WebView2 Runtime is required. It is included with current Windows 10 and Windows 11 installations. Install or repair WebView2, then start TFC again.");
        }
        catch (Exception ex)
        {
            ShowStartupError($"TFC could not start.\n\n{ex.Message}");
        }
    }

    private void HandleDownloadStarting(object? sender, CoreWebView2DownloadStartingEventArgs args)
    {
        string suggestedName = Path.GetFileName(args.ResultFilePath);
        using SaveFileDialog dialog = new()
        {
            Title = "Save converted file",
            FileName = string.IsNullOrWhiteSpace(suggestedName) ? "converted-image" : suggestedName,
            Filter = "All files (*.*)|*.*",
            OverwritePrompt = true,
            AddExtension = true
        };

        if (dialog.ShowDialog(this) == DialogResult.OK)
            args.ResultFilePath = dialog.FileName;
        else
            args.Cancel = true;
    }

    private void ShowStartupError(string message)
    {
        if (smokeTest)
        {
            FinishSmokeTest(4);
            return;
        }
        MessageBox.Show(this, message, "Total Free Convert", MessageBoxButtons.OK, MessageBoxIcon.Error);
        Close();
    }

    private void FinishSmokeTest(int exitCode)
    {
        if (!smokeTest || IsDisposed) return;
        smokeTimer.Stop();
        Environment.ExitCode = exitCode;
        BeginInvoke(Close);
    }
}
