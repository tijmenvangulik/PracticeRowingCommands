var notSupported = "Speech recognition not supported by this browser. Try to use Chrome / Edge / Safari"
var lang="nl-NL"


function soundex(stringToEncode)
{
    const arrayToEncode = stringToEncode.toLowerCase().split('');

    const codes         = {
        a: '', e: '', i: '', o: '', u: '', y: '',
        b: 1, f: 1, p: 1, v: 1,
        c: 2, g: 2, j: 2, k: 2, q: 2, s: 2, x: 2, z: 2,
        d: 3, t: 3,
        l: 4,
        m: 5, n: 5,
        r: 6
    };

    //1. Save first letter and remove all occurrences of 'h' and 'w'
    const firstLetter = arrayToEncode[0];
    const encodedArray = arrayToEncode.filter(function(v)
    {
        return (v !== 'h' && v !== 'w');
    })

    //2. Replace all consonants with digits
    .map(function(v) {return codes[v];})

    //3. Replace all adjacent same digits with one digit
    .filter(function(v, i, a)
    {
        if (i === 0)
            return true;
        else
            return v !== a[i - 1];
    })

    //4. Remove all occurrences of a,e,i,o,u,y except first letter
    .filter(function(v, i)
    {
        return ((v !== '') || (i === 0));
    });

    //5. If first symbol is a digit, replace with firstLetter from step 1
    encodedArray[0] = firstLetter;

    //6. Append 3 zeros. Remove all but first letter and 3 digits after it
    return (encodedArray.join('') + '000').slice(0, 4).toUpperCase();
}
function wordsSoundex(words) {
    return words.split(" ").map(e=>soundex(e)).join("");
}

var SpeechRecognition = SpeechRecognition || webkitSpeechRecognition
var SpeechGrammarList = SpeechGrammarList || webkitSpeechGrammarList
var SpeechRecognitionEvent = SpeechRecognitionEvent || webkitSpeechRecognitionEvent

var moves = ['halen beide boorden','laat lopen', 'bedankt', 'vastroeien','vastroeien stuurboord','vastroeien bakboord', 'halen stuurboord','halen bakboord'];
var movesIndex=moves.map(s=>wordsSoundex(s.toLowerCase()));

var replacements = {
    " bij de ":" beide ",
    "borderij":"boorden",
    "borden":"boorden",
    "haren":"halen"
}

var grammar = '#JSGF V1.0; grammar movesForGrammar; public <movesForGrammar> = ' + moves.join(' | ') + ' ;'

console.log(grammar);

class SpeachInterface {
    callbackFunc=null;
    recognition;
    supported=true;
    constructor() {
        var isFirefox = typeof InstallTrigger !== 'undefined';
        var isOpera = (!!window.opr && !!opr.addons) || !!window.opera || navigator.userAgent.indexOf(' OPR/') >= 0;
        if (isOpera || isFirefox) {
            this.supported=false;
        }

        if (this.supported) this.initSpeach()
    }
    initSpeach() {
        var recognition = new SpeechRecognition();
        var speechRecognitionList = new SpeechGrammarList();
        speechRecognitionList.addFromString(grammar, 1);
        recognition.grammars = speechRecognitionList;
        recognition.continuous = false;
        recognition.lang = lang;
        recognition.interimResults = false;
        recognition.maxAlternatives = 3;
        
        recognition.onresult=this.recognitionResult.bind(this)
        recognition.onspeechend = function() {
    //    recognition.stop();
        //           buttonStart.isEnabled = true;
        //        buttonStart.children[0].text = "Ready!";
        }
        
        recognition.onnomatch = function(event) {
        // diagnostic.textContent = "I didn't recognise that color.";
        }
        
        recognition.onerror = function(event) {
        //  diagnostic.textContent = 'Error occurred in recognition: ' + event.error;
        }
        this.recognition=recognition;
    }
    recognitionResult(event) {
        var results=result[0];
        console.log(results);
        var i=0;
        var commandNr=-1;
        var lowerText="";
        while (i<results.length && commandNr<0) {
            var result= results[i]
            var recoResult = result.transcript;
            console.log('Confidence: ' + result.confidence);
            console.log(recoResult);
            recoResult = recoResult.toLowerCase();
            console.log(recoResult);
        // Correction part :)
            
            //  Removing the last dot if exists
            if(recoResult.substring(recoResult.length, recoResult.length - 1) == ".") {
                recoResult = recoResult.substring(0, recoResult.length - 1);
                console.log("The last dot removed - " + recoResult);
            }
            console.log(recoResult);
        
            
            if(recoResult) {
                lowerText=recoResult.toLowerCase();
                for(var key in replacements)  {
                    lowerText=lowerText.replace(key,replacements[key]);
                }
                commandNr=moves.indexOf(lowerText)
                if (commandNr<0) {
                    var indexString=wordsSoundex(lowerText);
                    commandNr=movesIndex.indexOf(indexString);
                }
            }
            i++
        }
        
        this.callbackFunc(commandNr,lowerText)
    }
    waitForCommand(callbackFunc) {
        this.callbackFunc=callbackFunc;
        this.recognition.start();
    }
}
var speachInterface= new SpeachInterface();