# patches in source code

## index.js
The following code is patched in the godot index.js

The loadFetch function has been patched to add cache buster to all file loads

``` javascript
 function loadFetch(file, tracker, fileSize, raw) {
		tracker[file] = {
			total: fileSize || 0,
			loaded: 0,
			done: false,
		};
        //patched!
		var addVersion=typeof appVersion=="string"?"?v="+appVersion:"";
		return fetch(file+addVersion).then(function (response) {
        
```

I have added calls to the window.vkEvent object to make changes to teh virtual keyboard behavior.

``` javascript
var         v = {
            textinput: null,
            textarea: null,
            available: function() {
                return GodotConfig.virtual_keyboard && "ontouchstart"in window
            },
            init: function(input_cb) {
                function create(what) {
                    const elem = document.createElement(what);
                    elem.style.display = "none";
                    elem.style.position = "absolute";
                    elem.style.zIndex = "-1";
                    elem.style.background = "transparent";
                    elem.style.padding = "0px";
                    elem.style.margin = "0px";
                    elem.style.overflow = "hidden";
                    elem.style.width = "0px";
                    elem.style.height = "0px";
                    elem.style.border = "0px";
                    elem.style.outline = "none";
                    elem.readonly = true;
                    elem.disabled = true;
                    GodotEventListeners.add(elem, "input", function(evt) {
                        const c_str = GodotRuntime.allocString(elem.value);
                        input_cb(c_str, elem.selectionEnd);
                        GodotRuntime.free(c_str)
                    }, false);
                    GodotEventListeners.add(elem, "blur", function(evt) {
                        elem.style.display = "none";
                        elem.readonly = true;
                        elem.disabled = true;
                        //patched!
                        if (typeof window.vkEvent == "object") window.vkEvent.hide();
                    }, false);
                    GodotConfig.canvas.insertAdjacentElement("beforebegin", elem);
                    return elem
                }
                GodotDisplayVK.textinput = create("input");
                GodotDisplayVK.textarea = create("textarea");
                GodotDisplayVK.updateSize()
            },
            show: function(text, multiline, start, end) {
                if (!GodotDisplayVK.textinput || !GodotDisplayVK.textarea) {
                    return
                }
                if (GodotDisplayVK.textinput.style.display !== "" || GodotDisplayVK.textarea.style.display !== "") {
                    GodotDisplayVK.hide()
                }
                GodotDisplayVK.updateSize();
                const elem = multiline ? GodotDisplayVK.textarea : GodotDisplayVK.textinput;
                elem.readonly = false;
                elem.disabled = false;
                elem.value = text;
                elem.style.display = "block";
                elem.focus();
                elem.setSelectionRange(start, end)
                //patched!
                if (typeof window.vkEvent == "object") window.vkEvent.show();
            },
            hide: function() {
                if (!GodotDisplayVK.textinput || !GodotDisplayVK.textarea) {
                    return
                }
                [GodotDisplayVK.textinput, GodotDisplayVK.textarea].forEach(function(elem) {
                    elem.blur();
                    elem.style.display = "none";
                    elem.value = ""
                })
                //patched!
                if (typeof window.vkEvent == "object") window.vkEvent.hide();
            },
            updateSize: function() {
                if (!GodotDisplayVK.textinput || !GodotDisplayVK.textarea) {
                    return
                }
                const rect = GodotConfig.canvas.getBoundingClientRect();
                function update(elem) {
                    elem.style.left = `${rect.left}px`;
                    elem.style.top = `${rect.top}px`;
                    elem.style.width = `${rect.width}px`;
                    elem.style.height = `${rect.height}px`
                }
                update(GodotDisplayVK.textinput);
                update(GodotDisplayVK.textarea)
            },
            clear: function() {
                if (GodotDisplayVK.textinput) {
                    GodotDisplayVK.textinput.remove();
                    GodotDisplayVK.textinput = null
                }
                if (GodotDisplayVK.textarea) {
                    GodotDisplayVK.textarea.remove();
                    GodotDisplayVK.textarea = null
                }
                if (typeof window.vkEvent == "object") 
                //patched!
                window.vkEvent.clear();
            }
        };
```