// an example to replace `T` with `gt`, click `Default mappings` to see how `T` works.
api.map('gt', 'T');

// an example to remove mapkey `Ctrl-i`
//api.unmap('<ctrl-i>');
//api.unmapAllExcept(['E','R','T'], /orareview.us.oracle.com|confluence.oraclecorp.com/);

api.map('<Ctrl-d>', 'd');
api.map('<Ctrl-u>', 'u');
api.map('<Ctrl-J>', 'R');
api.map('<Ctrl-K>', 'E');
//Toggle surfingkeys on/off, default is Alt+s, we remap to Ctr+i
//api.map('<Ctrl-i>', '<Alt-s>'); // hotkey must be one keystroke with/without modifier, it can not be a sequence of keystrokes like `gg`.

settings.hintAlign = "center";
settings.blocklistPattern = /.*orareview.us.oracle.com.*|.*confluence.oraclecorp.com.*|.*youtube.com.*|.*monkeytype.com.*/i;
settings.showModeStatus = true;

// set theme
settings.theme = `
.sk_theme {
    font-family: Fira Code, Input Sans Condensed, Charcoal, sans-serif;
    font-size: 10pt;
    background: #444d60;
    color: #abb2bf;
}
.sk_theme tbody {
    color: #ffffff;
}
.sk_theme input {
    color: #d0d0d0;
}
.sk_theme .url {
    color: #61afef;
}
.sk_theme .annotation {
    color: #56b6c2;
}
.sk_theme .omnibar_highlight {
    color: #528bff;
}
.sk_theme .omnibar_timestamp {
    color: #e5c07b;
}
.sk_theme .omnibar_visitcount {
    color: #98c379;
}
.sk_theme #sk_omnibarSearchResult ul li:nth-child(odd) {
    background: #303030;
}
.sk_theme #sk_omnibarSearchResult ul li.focused {
    background: #3e4452;
}
.ace_editor {
    font-family: "JetBrains Mono", "Fira Code", "Fira "Mono", monospace;
    font-size: 14px !important;
}
#sk_status, #sk_find {
    right: 1em;
    font-size: 10pt;
    padding: 2px 4px 0px 4px;
    background-color: Canvas;
    color: CanvasText;
}`;
// click `Save` button to make above settings to take effect.</ctrl-i></ctrl-y>
