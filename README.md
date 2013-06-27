Vaxe is a vim bundle for [Haxe](http://www.haxe.org).  It provides support for
syntax highlighting, indenting, compiling, and many more options.  vaxe has
"vimdoc" documentation.  You can see the current vimdoc documentation
[here](https://raw.github.com/jdonaldson/vaxe/master/doc/vaxe.txt), as well as
through using `:help vaxe` within vim.  This page will describe some of the
special or optional features that vaxe supports, in addition to recommended
configuration settings.

![Vaxe Screenshot](http://i.imgur.com/JFvze.png) (screenshot shows
neocomplcache completion mode, vim-powerline, tagbar, and monokai color theme)

The recommended way to install vaxe is using a bundle management system such
as [pathogen][], [vundle][], or [vam][].

# Install with Pathogen

1. Install pathogen using the [instructions][pathogen].
2. Create/cd into `~/.vim/bundle/`
3. Make a clone of the vaxe repo:
    `git clone https://github.com/jdonaldson/vaxe.git`

To update:

1. cd into `~/.vim/bundle/vaxe/`
2. git pull

# Install with Vundle

1. Install vundle using the [instructions][vundle]
2. Add vaxe to your bundle list in `.vimrc` and re-source it:
    `Bundle 'jdonaldson/vaxe'`
3. Run `:BundleInstall`

To update, just run `:BundleUpdate`

# Install with VAM

1. Install VAM using the [instructions][vam]
2. Add vaxe to the list of your activated bundles and re-source it:
    `call vam#ActivateAddons(['github:jdonaldson/vaxe'])`


[pathogen]:https://github.com/tpope/vim-pathogen

[vundle]:https://github.com/gmarik/vundle

[vam]:https://github.com/MarcWeber/vim-addon-manager

# Compiling Haxe Projects with vaxe

## HXML File Support
Vaxe supports [hxml build files](http://haxe.org/doc/compiler), which provide
all of the arguments for the compiler, similar to a  [make
file](http://en.wikipedia.org/wiki/Make_(software).

Vaxe will automatically try to determine the appropriate hxml file you are
using.  It will also let you easily override this with a specific file
(see vim docs for more details).

Vaxe will specify a custom
[makeprg](http://vimdoc.sourceforge.net/htmldoc/options.html#'makeprg') using
the given hxml file. The makeprg will cd to the directory containing the hxml,
execute the haxe compiler with the hxml file, and pipe output to stdout.

Vaxe will also specify an
[errorformat](http://vimdoc.sourceforge.net/htmldoc/options.html#'errorformat'),
so that errors and trace messages show up in the
[quickfix](http://vimdoc.sourceforge.net/htmldoc/quickfix.html#quickfix)
window.

## NME Project Support
![Nme](http://i.imgur.com/rc8vLi2.png)

Vaxe supports [NME](http://www.nme.io) workflows.  If an Nmml project is
found, Vaxe will use it for builds and completions. You can specify a default
target if you only work with one platform.

## Openfl Project Support

Vaxe supports [Openfl](https://github.com/openfl/openfl/wiki/Get-Started)
workflows.  If an Openfl project is found, Vaxe will use it for builds and
completions. You can specify a default target if you only work with one
platform.

## Omni-completions

Vaxe provides an
[omnicompletion](http://vimdoc.sourceforge.net/htmldoc/version7.html#new-omni-completion)
function that can use the haxe compiler in order to [display field
completions](http://haxe.org/manual/completion).  Visual Studio users will
recognize this as being similar to "intellisense".

eou can trigger an omnicompletion (C-X C-O in Insert Mode) after the period at
the start of a field, submodule, or class access, or after the first
parentheses of a function invocation. See the [haxe
documentation](http://haxe.org/manual/completion) for more details.

### Active Targets: Dealing with --next

In some cases, an hxml file may specify multiple targets via a `--next`
directive.  Vaxe will use the first target it finds in order to generate
completions.  It is possible to specify a different target by
inserting a line like this into your hxml:

    # display completions

If Vaxe finds that line, it will use that target to generate completions and
perform other miscellaneous tasks.  The target that Vaxe uses is called the
"active" target here.

# Recommended Plugins/Additions/Config

Vaxe will work fine on its own, but it is designed to integrate cleanly with
a number of other bundles and plugins. Once again, it is recommended to use
pathogen, vundle, or vam to manage installation and updates.

## Misc Config
Vaxe provides a full completion specification for vim, which includes providing
function documentation via the [preview
window]( http://vimdoc.sourceforge.net/htmldoc/windows.html#preview-window ).
This can be turned off with:

```viml
set completeopt=menu
```

This will only use the menu, and not the preview window.  See ```:help
preview-window``` for more details.

## Powerline

Powerline ( [by Kim Silkebækken](https://github.com/lokaltog)) is a handy
[status line](http://vimdoc.sourceforge.net/htmldoc/windows.html#status-line)
replacement.  I think it looks better, and provides a good deal more
functionality over a normal status line setting.  Unfortunately, Powerline is
still fairly new, and doesn't have a plugin framework for it yet.  So, I have a
special branch of it available [here on
github](https://github.com/jdonaldson/vim-powerline).

When it is installed, the current hxml build file will be displayed next to the
file info.

## Tags

Vim has great support for
[ctags](http://vimdoc.sourceforge.net/htmldoc/tagsrch.html), which are really
useful for navigating a large code base.

You'll need to define some patterns for ctags in order for it to work with
Haxe.  Put these lines in your `.ctags` file in your home directory:

```bash
    --langdef=haxe
    --langmap=haxe:.hx
    --regex-haxe=/^[ \t]*((@:?[a-zA-Z]+) )*((macro|private|public|static|inline) )*function[ \t]+([A-Za-z0-9_]+)/\5/f,function,functions/
    --regex-haxe=/^[ \t]*((@:?[a-zA-Z]+) )*((private|public|static|inline) )+var[ \t]+([A-Za-z0-9_]+)/\5/v,variable,variables/
    --regex-haxe=/^[ \t]*package[ \t]*([A-Za-z0-9_\.]+)/\1/p,package/
    --regex-haxe=/^[ \t]*((@:?[a-zA-Z]+) )*(extern[ \t]+)?class[ \t]+([A-Za-z0-9_]+)[ \t]*[^\{]*/\4/c,class,classes/
    --regex-haxe=/^[ \t]*((@:?[a-zA-Z]+) )*(extern[ \t]+)?interface[ \t]+([A-Za-z0-9_]+)/\4/i,interface/
    --regex-haxe=/^[ \t]*typedef[ \t]+([A-Za-z0-9_]+)/\1/t,typedef/
    --regex-haxe=/^[ \t]*enum[ \t]+([A-Za-z0-9_]+)/\1/e,enum/
```

Vaxe can generate a set of tags specific to the given build by running:
    vaxe#Ctags()
This will feed the paths used by the compiler into ctags.  Only the relevant
paths for the current target will be used.

Other utilities, like vaxe#ImportClass() can then use this tag information in
order to programmatically import classes.  E.g. calling vaxe#ImportClass on
this line:

```as3
    var l = new FastList<Int>();
```

will generate:

```as3
    import haxe.FastList;
    ...
    var l = new FastList<Int>();
```


## Tagbar

Using the ctags lines above, the
[Tagbar](http://majutsushi.github.com/tagbar/) bundle can display a nice
overview of the classes, methods, and variables in your current haxe file.  You
do not need to call `vaxe#Ctags()` in order to use Tagbar, it works
automatically, but only for the current vaxe buffer.

## Neocomplcache

[Neocomplcache](https://github.com/Shougo/neocomplcache) is a
plugin for vim that can manage virtually any type of
completion (omni, keyword, file, etc). It won't use omnicompletion by default
since it is slow for some languages.  However, since completions are built into
the compiler with Haxe, they are very fast.  In fact, it's possible to check
for completions as you are typing using Neocomplcache.  Neocomplcache can be
tricky to set up.  Here's a self-contained vimrc that gives you a minimal
vaxe and neocomplcache config.  

```viml
" set the bundle root, and vundle directory
let root = '~/.vim/bundle'
let src = 'http://github.com/gmarik/vundle.git'

" clone vundle if it's missing
if !isdirectory(expand(root, 1).'/vundle')
  exec '!git clone '.src.' '.shellescape(expand(root.'/vundle', 1))
endif

" immediately make vundle accessible in the rtp
exec 'set rtp+='.root.'/vundle'

" initialise vundle's boot script
call vundle#rc(root)

set autowrite " vaxe likes autowrite
set nocompatible " we need fancy new vim 7.0 features
syntax enable on " turn on syntax highlighting

" This disables the preview window for function completions.
" This window can get distracting, so I often just turn it off.
" set completeopt=menuone

filetype off " turn off filetype settings, which is required for vundle

" load vaxe, and neocomplcache with the given config"
Bundle 'jdonaldson/vaxe'
Bundle 'Shougo/neocomplcache'
    let g:neocomplcache_enable_at_startup = 1 " always load neocc
    let g:neocomplcache_enable_auto_select = 1 " auto-popup!
    if !exists('g:neocomplcache_omni_patterns')
        let g:neocomplcache_omni_patterns = {} " set a default pattern dict
    endif

    " this tells neocc when to try for completions... after '.', '(', etc.
    let g:neocomplcache_omni_patterns.haxe = '\v([\]''"\)]|\w|(^\s*))(\.|\()'

filetype plugin indent on " re-enable plugin settings
```
After you start vim the first time, run:
```viml
:BundleInstall
```
Then, restart vim and your completions should work.

Once enabled, Neocomplcache will automatically invoke vaxe omnicompletion
when you type a "." after a variable with fields, etc.

# Acknowledgements
* Marc Weber (marco-oweber@gmx.de) : Most of the syntax and snippets are based
off of his [vim bundle](https://github.com/MarcWeber/vim-haxe).

* Ganesh Gunasegaran(me at itsgg.com) : I based my hxml syntax file off of [his
version](http://lists.motion-twin.com/pipermail/haxe/2008-July/018220.html).

* Laurence Taylor (polysemantic at gmail): I based my ctags description of of [his mailing list post]
(http://haxe.org/forum/thread/3395#nabble-td3443583)
