# powershell-git-keywords
Mimics svn keywords on git for powershell

# Installation

Git init your project if you doen't.

Download [Installer](https://github.com/barbatchov/powershell-git-keywords/blob/install/setup-keywords.ps1) and run:

Options are
1. project path (required);
2. file extensions (required);
```powershell
> .\setup-keywords.ps1 c:\project .cs,.js,.html
```

It gonna download the files and sets up the project for parse the following keywords:

    $Id$
    $Date$
    $Author$
    $Source$
    $File$
    $Revision$

Any bugs, please contact me or feel free for help improve this.