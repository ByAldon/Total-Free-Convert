# Security policy

## Reporting

Do not post private images, credentials or exploit details in a public issue.
If the repository maintainer enables GitHub private vulnerability reporting, use
that channel. Otherwise ask the maintainer for a private reporting channel
without publishing sensitive details.

## Application boundaries

- Files are processed locally. There is no backend, database or upload endpoint.
- Filenames are shown using text content rather than interpreted as HTML.
- The queue decodes and converts one file at a time. Completed output files stay
  in browser memory until downloaded, removed or invalidated. Per-file and
  dimension limits reduce accidental memory exhaustion, but a very large queue,
  browser decoders or hostile files can still freeze a tab. This is not a sandbox
  for examining malware.
- Keep browsers up to date. TFC relies on the browser's image decoders and canvas.
- Custom host security headers may need adjustment because this single-file
  application uses inline scripts and styles. Use CSP hashes for the exact file
  if deploying a strict policy; update them whenever the file changes.

## Windows desktop app

- The desktop shell maps the bundled `wwwroot` directory to the private
  `https://tfc.local/` WebView2 origin. It does not listen on a network port.
- Navigation outside that local origin is blocked. File downloads use a native
  Save As dialog; selected images remain inside the local WebView2 process.
- The app stores only WebView2 runtime data below the current user's local app
  data directory. It has no TFC account, image database or cloud sync.
- The distributed binaries are not code-signed. Verify the published SHA-256
  checksum before running a downloaded copy. A SmartScreen warning is therefore
  possible and must not be bypassed on an untrusted download.
- Microsoft WebView2 and Windows image decoders are part of the trusted computing
  base. Keep Windows and the WebView2 Runtime updated.

## Before publishing a repository

Publish the clean distribution, not local development or hosting state. Exclude
`.git/`, `.openai/`, `.sites-runtime/`, `work/`, `outputs/`, environment files,
tokens, private keys, test images and personal paths. The supplied `.gitignore`
helps with new files but does not remove files already tracked or present in Git
history. Review staged changes and scan the entire history before publishing an
existing repository. Rotate any real credential that was exposed.

The GitHub-ready ZIP contains no previous Git history or hosting manifest. Start
a new repository from that ZIP. The original working directory has local hosting
metadata in its history and is not the clean public distribution.

The release was checked for obvious credentials, local paths and hosted project
identifiers. This is not an independent security audit or a guarantee against all
vulnerabilities. The software is supplied under the MIT license without warranty.
