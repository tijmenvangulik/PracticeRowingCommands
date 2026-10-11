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

function levenshtein(a, b) {
    var prev = [];
    for (var j = 0; j <= b.length; j++) prev[j] = j;
    for (var i = 1; i <= a.length; i++) {
        var cur = [i];
        for (var j = 1; j <= b.length; j++) {
            cur[j] = Math.min(prev[j] + 1, cur[j - 1] + 1,
                              prev[j - 1] + (a[i - 1] === b[j - 1] ? 0 : 1));
        }
        prev = cur;
    }
    return prev[b.length];
}

var commandsNorm = [];

// longest number of words in one spoken command
var maxCommandWords = 6;

// best matching command for a piece of text (spaces removed)
function matchCommand(t) {
    var best = {nr: -1, score: 0};
    commandsNorm.forEach(function(m, nr) {
        var score = 1 - levenshtein(t, m) / Math.max(t.length, m.length);
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

// errors which mean speech recognition does not work in this browser (no speech service,
// or speech/Siri disabled), for example in Vivaldi, Opera or Chromium
var unsupportedErrors = ["network", "service-not-allowed"];

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

    constructor() {
        if (this.supported) this.initSpeach();
    }
    initSpeach() {
        var recognition = new SpeechRecognition();
        recognition.continuous = false;
        recognition.lang = lang;
        recognition.interimResults = false;
        recognition.maxAlternatives = 5;

        recognition.onresult = this.recognitionResult.bind(this);
        recognition.onerror = this.recognitionError.bind(this);
        recognition.onend = this.recognitionEnd.bind(this);
        this.recognition = recognition;
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
        if (language) lang = language;
        if (!this.recognition) return;
        this.recognition.lang = lang;
        // Contextual biasing: the replacement for grammars (which Chrome ignores).
        // Only supported in some browsers / with on-device recognition; ignore if not.
        if (!this.phrasesNotSupported && SpeechRecognitionPhrase && "phrases" in this.recognition) {
            try {
                this.recognition.phrases = commands.map(m => new SpeechRecognitionPhrase(m, 5.0));
            } catch (e) {
                console.log("Phrases not supported", e);
                this.phrasesNotSupported = true;
            }
        }
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
            // retry without biasing, with a new recognition object (clearing phrases may throw)
            this.phrasesNotSupported = true;
            this.retry = true;
            return;
        }
        if (event.error != "aborted") this.lastError = event.error;
    }
    recognitionEnd() {
        this.listening = false;
        if (this.cancelled) {
            // stopped by the user: no result
            this.cancelled = false;
            return;
        }
        if (this.retry) {
            this.retry = false;
            this.initSpeach();
            this.start();
            return;
        }
        if (this.alternatives.length == 0 && this.lastError) {
            // nothing heard because of an error, show the error
            // 4th argument: the error means speech recognition does not work in this browser
            var unsupported = unsupportedErrors.indexOf(this.lastError) >= 0;
            if (this.callbackFunc) this.callbackFunc("[]", this.lastError, "", unsupported);
            return;
        }
        var match = bestMatch(this.alternatives);
        var nrs = match.nrs.map(nr => commandNrs[nr]);
        var commandText = match.nrs.map(nr => commands[nr]).join(", ");
        // callback(JSON array of command numbers, heard text, matched command texts)
        if (this.callbackFunc) this.callbackFunc(JSON.stringify(nrs), match.text, commandText);
    }
    start() {
        this.cancelled = false;
        this.lastError = "";
        this.alternatives = [];
        this.listening = true;
        try {
            this.recognition.start();
        } catch (e) {
            console.error(e);
            this.listening = false;
            if (this.callbackFunc) this.callbackFunc("[]", String(e.message || e), "");
        }
    }
    waitForCommand(callbackFunc) {
        this.callbackFunc = callbackFunc;
        if (!this.supported) {
            if (callbackFunc) callbackFunc("[]", notSupported, "");
            return;
        }
        if (this.listening) return;
        this.start();
    }
    stopListening() {
        if (!this.listening) return;
        this.cancelled = true;
        this.retry = false;
        this.recognition.abort();
    }
}
var speachInterface = new SpeachInterface();
