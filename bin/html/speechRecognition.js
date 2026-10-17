var notSupported = "Speech recognition not supported by this browser. Try to use Chrome / Edge / Safari"
var lang="nl-NL"

var SpeechRecognition = window.SpeechRecognition || window.webkitSpeechRecognition;
var SpeechRecognitionPhrase = window.SpeechRecognitionPhrase;

// Filled from Godot with setCommands(): every text (full command text and button text)
// with the command number it belongs to.
var commands = [];
var commandNrs = [];

// minimal similarity (0..1) for a transcript to count as a command
var minScore = 0.75;

function normalizeWords(s) {
    return s.toLowerCase().replace(/[.,!?]/g, "").split(/\s+/).filter(w => w);
}

function normalize(s) {
    // ignore spaces so "vast roeien" matches "vastroeien"
    return normalizeWords(s).join("");
}

// similar sounding letters are made equal,
// so "light battle" or "light paddel" is close to "light paddle"
function soundAlike(s) {
    return s.replace(/ph/g, "f").replace(/ck/g, "k").replace(/c/g, "k")
        .replace(/b/g, "p").replace(/d/g, "t").replace(/g/g, "k")
        .replace(/v/g, "f").replace(/z/g, "s").replace(/y/g, "i");
}

// edit distance, two swapped letters count as one difference
function levenshtein(a, b) {
    var d = [];
    for (var i = 0; i <= a.length; i++) {
        d[i] = [i];
        for (var j = 1; j <= b.length; j++) {
            if (i == 0) { d[i][j] = j; continue; }
            d[i][j] = Math.min(d[i - 1][j] + 1, d[i][j - 1] + 1,
                               d[i - 1][j - 1] + (a[i - 1] === b[j - 1] ? 0 : 1));
            if (i > 1 && j > 1 && a[i - 1] === b[j - 2] && a[i - 2] === b[j - 1])
                d[i][j] = Math.min(d[i][j], d[i - 2][j - 2] + 1);
        }
    }
    return d[a.length][b.length];
}

function similarity(a, b) {
    return 1 - levenshtein(a, b) / Math.max(a.length, b.length);
}

var commandsNorm = [];
var commandsSound = [];

// longest number of words in one spoken command
var maxCommandWords = 6;

// best matching command for a piece of text (spaces removed),
// the best of the normal and the sound alike comparison
function matchCommand(t) {
    var best = {nr: -1, score: 0};
    var tSound = soundAlike(t);
    commandsNorm.forEach(function(m, nr) {
        var score = Math.max(similarity(t, m), similarity(tSound, commandsSound[nr]));
        if (score > best.score) best = {nr: nr, score: score};
    });
    return best;
}

// Split a sentence into a sequence of commands, e.g. "laat lopen bedankt".
// Words which do not belong to a command are skipped.
function matchSentence(text) {
    var words = normalizeWords(text);
    // best[i]: best result for the first i words
    var best = [{total: 0, nrs: []}];
    for (var i = 1; i <= words.length; i++) {
        best[i] = best[i - 1]; // skip word i-1
        for (var j = Math.max(0, i - maxCommandWords); j < i; j++) {
            var chunk = words.slice(j, i).join("");
            var match = matchCommand(chunk);
            if (match.score < minScore) continue;
            var total = best[j].total + match.score * chunk.length;
            if (total > best[i].total) best[i] = {total: total, nrs: best[j].nrs.concat([match.nr])};
        }
    }
    return {total: best[words.length].total, nrs: best[words.length].nrs, text: text};
}

function bestMatch(alternatives) {
    var best = {total: 0, nrs: [], text: alternatives.length ? alternatives[0] : ""};
    alternatives.forEach(function(alt) {
        var match = matchSentence(alt);
        if (match.total > best.total) best = match;
    });
    console.log("Best match", best, best.nrs.map(nr => commands[nr]));
    return best;
}

// translation keys (shown by Godot) for the recognition errors
var errorKeys = {
    // no speech service, or speech/Siri disabled, for example in Vivaldi, Opera or Chromium
    "network": "SpeechNotSupported",
    "service-not-allowed": "SpeechNotSupported",
    "audio-capture": "SpeechNoMicrophone",
    "not-allowed": "SpeechMicrophoneBlocked",
    "no-speech": "SpeechNothingHeard",
    // aborted by the browser (a stop by the user is not reported): ask to repeat the command
    "aborted": "SpeechRepeatCommand",
    "language-not-supported": "SpeechLanguageNotSupported"
};

// Chrome also reports a missing microphone as not-allowed: check if there is a microphone
function hasMicrophone() {
    if (!navigator.mediaDevices || !navigator.mediaDevices.enumerateDevices) return Promise.resolve(true);
    return navigator.mediaDevices.enumerateDevices()
        .then(devices => devices.some(d => d.kind == "audioinput"))
        .catch(() => true);
}

// translation key for an error ("" when there is none)
function errorKey(error) {
    var key = errorKeys[error] || "";
    if (error != "not-allowed") return Promise.resolve(key);
    return hasMicrophone().then(found => found ? key : "SpeechNoMicrophone");
}

class SpeachInterface {
    callbackFunc=null;
    recognition=null;
    listening=false;
    alternatives=[];
    // Brave has the SpeechRecognition object, but its speech service is disabled (always a network error)
    supported=!!SpeechRecognition && !navigator.brave;
    // set when the browser reports phrases-not-supported, then phrases are never used again
    phrasesNotSupported=false;
    lastError="";
    retry=false;

    // a new recognition object for every start: an aborted object can stay unusable
    initSpeach() {
        this.detach();
        var recognition = new SpeechRecognition();
        recognition.continuous = false;
        recognition.lang = lang;
        recognition.interimResults = false;
        recognition.maxAlternatives = 5;
        // Contextual biasing: the replacement for grammars (which Chrome ignores).
        // Only supported in some browsers / with on-device recognition; ignore if not.
        if (!this.phrasesNotSupported && SpeechRecognitionPhrase && "phrases" in recognition) {
            try {
                recognition.phrases = commands.map(m => new SpeechRecognitionPhrase(m, 5.0));
            } catch (e) {
                console.log("Phrases not supported", e);
                this.phrasesNotSupported = true;
            }
        }
        // ignore events of an old recognition object
        recognition.onresult = e => { if (recognition === this.recognition) this.recognitionResult(e); };
        recognition.onerror = e => { if (recognition === this.recognition) this.recognitionError(e); };
        recognition.onend = () => { if (recognition === this.recognition) this.recognitionEnd(); };
        this.recognition = recognition;
    }
    // stop the current recognition object without a result
    detach() {
        var recognition = this.recognition;
        this.recognition = null;
        if (!recognition) return;
        recognition.onresult = null;
        recognition.onerror = null;
        recognition.onend = null;
        try {
            recognition.abort();
        } catch (e) {
        }
    }
    // commandsJson: JSON array of {nr, text}, language: iso culture code like nl-NL
    setCommands(commandsJson, language) {
        var items = JSON.parse(commandsJson);
        commands = [];
        commandNrs = [];
        items.forEach(function(c) {
            var text = (c.text || "").toLowerCase().trim();
            if (text && commands.indexOf(text) < 0) {
                commands.push(text);
                commandNrs.push(c.nr);
            }
        });
        commandsNorm = commands.map(normalize);
        commandsSound = commandsNorm.map(soundAlike);
        if (language) lang = language;
    }
    recognitionResult(event) {
        var result = event.results[event.resultIndex];
        for (var i = 0; i < result.length; i++) {
            console.log('Heard: "' + result[i].transcript + '" confidence: ' + result[i].confidence);
            this.alternatives.push(result[i].transcript);
        }
    }
    recognitionError(event) {
        console.error('Error occurred in recognition: ' + event.error);
        if (event.error == "phrases-not-supported" && !this.phrasesNotSupported) {
            // retry without biasing
            this.phrasesNotSupported = true;
            this.retry = true;
            return;
        }
        this.lastError = event.error;
    }
    recognitionEnd() {
        this.listening = false;
        this.recognition = null;
        if (this.retry) {
            this.retry = false;
            this.start();
            return;
        }
        if (this.alternatives.length == 0) {
            // nothing heard (because of an error): 4th argument is the translation key of the message
            var error = this.lastError || "no-speech";
            var callbackFunc = this.callbackFunc;
            errorKey(error).then(key => {
                if (callbackFunc) callbackFunc("[]", error, "", key);
            });
            return;
        }
        var match = bestMatch(this.alternatives);
        var nrs = match.nrs.map(nr => commandNrs[nr]);
        var commandText = match.nrs.map(nr => commands[nr]).join(", ");
        // callback(JSON array of command numbers, heard text, matched command texts)
        if (this.callbackFunc) this.callbackFunc(JSON.stringify(nrs), match.text, commandText);
    }
    start() {
        this.lastError = "";
        this.alternatives = [];
        this.retry = false;
        this.initSpeach();
        this.listening = true;
        try {
            this.recognition.start();
        } catch (e) {
            console.error(e);
            this.listening = false;
            this.detach();
            if (this.callbackFunc) this.callbackFunc("[]", String(e.message || e), "");
        }
    }
    waitForCommand(callbackFunc) {
        this.callbackFunc = callbackFunc;
        if (!this.supported) {
            if (callbackFunc) callbackFunc("[]", notSupported, "");
            return;
        }
        // also when a previous recognition is still running (or stuck): start a new one
        this.start();
    }
    // stopped by the user: no result
    stopListening() {
        this.listening = false;
        this.retry = false;
        this.detach();
    }
}
var speachInterface = new SpeachInterface();
