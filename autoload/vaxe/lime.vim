function! vaxe#lime#Targets(...)
    return s:lime_targets
endfunction

function! vaxe#lime#Update(...)
    if (a:0 && a:1 != '')
        let target = split(a:1)[0]
    else
        let target = g:vaxe_lime_target
    endif
    let command = "lime update ".target
    call vaxe#Log(command)
    call s:Sys(command)
endfunction

function! vaxe#lime#ProjectLime(...)
    if exists('g:vaxe_lime')
        unlet g:vaxe_lime
    endif
    let g:vaxe_working_directory = getcwd()

    if a:0 > 0 && a:1 != ''
        let g:vaxe_lime = expand(a:1,':p')
    else
        let limes = split(glob("**/*.lime"),'\n')

        if len(limes) == 0
            " look for legacy xml files as well...
            let limes = split(glob("**/*.xml"),'\n')
            if len(limes) == 0
                echoerr "No lime/openfl project files found in current working directory"
                return
            end
        endif 

        let base_lime = vaxe#util#InputList("Select Lime", limes)

        if base_lime !~ "^\([a-zA-Z]:\)\=[/\\]"
            let base_lime = getcwd() . '/' . base_lime
        endif

        echomsg 'Project lime selected: ' . base_lime

        let g:vaxe_lime = base_lime
    endif
    if !filereadable(g:vaxe_lime)
        echoerr "Project lime file not valid, please create one."
        return
    endif
    call vaxe#lime#BuildLimeHxml(g:vaxe_lime)
    call vaxe#SetCompiler()
    return g:vaxe_lime
endfunction

function! vaxe#lime#Clean(...)
    if (a:0 && a:1 != '')
        let target = split(a:1)[0]
    else
        let target = g:vaxe_lime_target
    endif
    let command = "lime clean ".target
    call vaxe#Log(command)
    call s:Sys(command)
endfunction

"A simple system function that first changes directory to the current vaxe
"working directory
function! s:Sys(cmd)
    call system("cd ".g:vaxe_working_directory." && ".a:cmd)
endfunction

function! vaxe#lime#BuildLimeHxml(lime)
    let base_hxml = a:lime.".hxml"

    if !strlen(g:vaxe_lime_target)
        call vaxe#lime#Target(a:lime)
    endif

    let g:vaxe_working_directory = fnamemodify(a:lime, ":p:h")
    let cdcmd = 'cd "'.g:vaxe_working_directory.'" && '

    "create the lime.hxml if not present
    if !filereadable(base_hxml)
        " pipe lime display to an hxml for completions
        let escape_base = fnameescape(base_hxml)
        call s:Sys(" echo '# THIS FILE IS AUTOGENERATED BY VAXE, ANY EDITS ARE DISCARDED' " . " > " . escape_base)
        call s:Sys(" lime display " . g:vaxe_lime_target
                    \. " >> " . escape_base )
    endif

    " create the boilerplate code if missing
    let simple_target = split(g:vaxe_lime_target)[0]
    if (!isdirectory(g:vaxe_working_directory."/Exports/".simple_target.'/bin') &&
                \ !isdirectory(g:vaxe_working_directory."/bin/".simple_target))
        " build the assets dependencies
        call system(cdcmd . " lime update " . g:vaxe_lime_target)
    else
    endif

    let b:vaxe_hxml = base_hxml
    " let g:vaxe_hxml = b:vaxe_hxml " don't set a global projet var by default
endfunction

"Sets the target.  If target is missing it asks the user. Also updates the
"makeprg compiler command
function! vaxe#lime#Target(lime, ...)
    let g:vaxe_lime_target = ''
    if a:0 > 1 && a:2 != ''
        let g:vaxe_lime_target = a:2
    else
        let g:vaxe_lime_target = vaxe#util#InputList("Select Lime Target", s:lime_targets)
        let g:vaxe_lime_target = split(g:vaxe_lime_target, ":")[0]
    endif
    call vaxe#lime#BuildLimeHxml(a:lime)
    call vaxe#SetCompiler()
endfunction


" A list of all the lime targets
let s:lime_targets = [ "android : Create Google Android applications"
            \, "android -arm7 : Compile for arm-7a and arm5"
            \, "android -arm7-only : Compile for arm-7a for testing"
            \, "blackberry : Create BlackBerry applications"
            \, "blackberry -simulator : Build/test for the device simulator"
            \, "flash : Create SWF applications for Adobe Flash Player"
            \, "html5 : Create HTML5 canvas applications"
            \, "html5 -minify : Minify output using the Google Closure compiler"
            \, "html5 -minify -yui : Minify output using the YUI compressor"
            \, "ios : Create Apple iOS applications"
            \, "ios -simulator : Build/test for the device simulator"
            \, "ios -simulator -ipad : Build/test for the iPad Simulator"
            \, "linux : Create Linux applications"
            \, "linux -64 : Compile for 64-bit instead of 32-bit"
            \, "linux -neko : Build with Neko instead of C++"
            \, "linux -neko -64 : Build with Neko 64-bit instead of C++"
            \, "mac : Create Apple Mac OS X applications"
            \, "mac -neko : Build with Neko instead of C++"
            \, "mac -neko -64 : Build with Neko 64-bit instead of C++"
            \, "webos : Create HP webOS applications"
            \, "windows : Create Microsoft Windows applications"
            \, "windows -neko : Build with Neko instead of C++"
            \, "windows -neko -64 : Build with Neko 64-bit instead of C++" ]

  " -D : Specify a define to use when processing other commands
  " -debug : Use debug configuration instead of release
  " -verbose : Print additional information (when available)
  " -clean : Add a "clean" action before running the current command
  " (display) -hxml : Print HXML information for the project
  " (display) -lime : Print lime information for the project
