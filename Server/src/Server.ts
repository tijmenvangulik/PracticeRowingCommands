/**
 * Created by tijmen on 14-11-13.
 */
import * as http from 'http';
import * as express from 'express';
import * as configuration from './Configuration.json';
import * as messages from './MessageData.js';
import * as utilities from './Utilities.js';
import * as gm from './GameManager.js';
import {handleErrorConsole,handleError} from "./ErrorHandler.js";
import * as activityLog from './ActivityLog.js';
import {getDefaultRepository,setDefaultRepository,FeedBack} from "./Repository.js";
import {RepositoryMongo} from "./RepositoryMongo.js";

async  function main() {

    var jsonParser = express.json();

    process.on('uncaughtException', handleError);

    var app : any = express(),
        server  : http.Server= http.createServer(app),
        gameManager = new gm.GameManager();

    if (configuration.debug) {
        console.log('Version node : ' + process.version);
    }
    console.log("Set up mongo")         
    let repositoryMongo : RepositoryMongo = new RepositoryMongo();
    await repositoryMongo.db(); //only connect once
    console.log("connected to mongo")
    setDefaultRepository(repositoryMongo) ;
    console.log("Set up repository")
    
    async function writeLog() {
        let log=activityLog.getActivityLog();
        if (log.length>0) {
          await getDefaultRepository().saveActivityLog(log);
          activityLog.clear();
        }
      }
    
    setInterval(()=>writeLog().catch(handleErrorConsole),configuration.saveLog || 60000);
    gameManager.load();

    //start the server
    server.listen(configuration.port,configuration.ipAddress);
    if (configuration.debug)
    console.log("listening to port "+configuration.port.toString());

    
    function addCrossOrginHeader(res) {
    res.header("Access-Control-Allow-Origin", "*"); //allow cross domain requests
    }

    app.get('/gameHighScores',jsonParser, function(req, res){
        try {
            if (configuration.debug)
                console.log("read activity log");
            addCrossOrginHeader(res);
            var params=req.query.data;
            var queryData : messages.GameHighScoreQuery ={
                game:parseInt(params.game),
                level:parseInt(params.level)
            }
            
            var gameType=utilities.checkNumber("game", false,queryData.game,(v)=>messages.GameType.Shark>=0&&v<=messages.GameType.StarGame);
            var level=utilities.checkNumber("level", false,queryData.level);
            var  scores= gameManager.queryHighScores(gameType,level);
            
            var resultList : messages.GameHighScoresResult= {
                scores:[]

            }
            scores.forEach(s=>{
                resultList.scores.push({
                    game : gameType,
                    level : s.level,
                    score : s.score,
                    name : s.name
                })
            })
            res.send(resultList);
        }
        catch (err)  {
            res.status(501);
            res.send("Can not query high scores: "+err);
        }
    });
    app.get('/newGameHighScore',jsonParser, function(req, res){
        try {
            
            addCrossOrginHeader(res);
            var params=req.query.data;
            var data : messages.NewGameHighScore= {
                game:parseInt(params.game),
                level:parseInt(params.level),
                checkOnly:params.checkOnly=="true",
                name:params.name,
                hash:params.hash,
                score:parseInt(params.score)
            }
            var highScore= new gm.HighScore();
            var gameType=utilities.checkNumber("game", false,data.game,(v)=>messages.GameType.Shark>=0&&v<=messages.GameType.StarGame);
            highScore.level=utilities.checkNumber("level", false,data.level);
            highScore.score=utilities.checkNumber("score", false,data.score);
            var checkOnly=utilities.checkBoolean("checkOnly", false,data.checkOnly);
            highScore.name=checkOnly?"":utilities.checkString("name", true,data.name,value=>value.length<150 &&value.length>0);
            highScore.timeStamp=new Date().getTime();
            var result=gameManager.newHighScore(gameType,highScore,data.hash,checkOnly)
            res.send({ranking:result});
        }
        catch (err)  {
            if (req && req.query)
              handleError("Error posting high score:"+err+":"+JSON.stringify(req.query));
            res.status(501);
            res.send("High score not posted: "+err);
        }
    });
    app.get('/sendFeedback',jsonParser, function(req, res){
        
        try {
            
            addCrossOrginHeader(res);
            var params : messages.SendFeedBack=req.query.data;
            var app='es'
            if (typeof params.app=="string" ) {
                app=params.app;
            }
            var data : FeedBack= {
                text:utilities.checkString("text", false,params.text,value=>value.length<5000 ),
                smiley:utilities.checkString("smiley", false,params.smiley,value=>value.length<10 ),
                app:utilities.checkString("app", false,app,value=>value.length<10 ),
                time: new Date()
            }

            getDefaultRepository().saveFeedback(data);               
            res.send("");
        }
        catch (err)  {
            if (req && req.query)
              handleError("Error posting feed back :"+err+":"+JSON.stringify(params));
            res.status(501);
            res.send("Feed back can not be posted: "+err);
            console.error("Send 501:"+err);
        }
    });
    app.get('/logFinishedActivity',jsonParser, function(req, res){
        
        try {
            
            addCrossOrginHeader(res);
            var params =req.query.data;
            
            var activityName=utilities.checkString("name", false,params.name,value=>value.length<100 );
            var language=utilities.checkString("language", false,params.language,value=>value.length<50 );
            
            var success= utilities.checkString("success", false,params.success)==="true";
            var isScull= utilities.checkString("isScull", false,params.isScull)==="true";
            var isMobile= utilities.checkString("isMobile", false,params.isMobile)==="true";
            activityLog.logText("PracticeRowingCommands","FinishedActivity",{
                name:activityName,
                success: success,
                language:language,
                isScull:isScull,
                isMobile:isMobile
            })
                    
            res.send("");
        }
        catch (err)  {
            if (req && req.query)
              handleError("Error posting feed back :"+err+":"+JSON.stringify(params));
            res.status(501);
            res.send("Feed back can not be posted: "+err);
            console.error("Send 501:"+err);
        }
    });

    app.get('/saveSharedSetting',jsonParser, async function(req, res) {
        try {
            
            addCrossOrginHeader(res);

            if (!req.query.data || req.query.data.length>20000) {
                throw "Data to long or not present";
            }
            var dataObj =JSON.parse(req.query.data);
            if (typeof dataObj != 'object' || dataObj.length> 0) {
                throw "Data is not an object";
            }
            //do not allow special mongo db properties
            for (var prop in dataObj) {
                if (prop=="_id" || prop.indexOf("$")>=0) {
                    throw "Illegal property name "+prop;
                }
            }
            //ensure the basic settings properties are present
            if (!utilities.checkPropertiesExists(dataObj,[
                "customButtonSet",
                "ruleset",
                "zoom",
                "language",
                "tooltips",
                "shortcuts",
                "textTranslations",
                "showCommandTooltips",
                "showShortCutsInButtons",
                "isScull",
                "disabledPractices",
                "disabledPracticesUseDefault"])) {
                  throw "Missing properties in shared setting";
            }
            
            var repository=getDefaultRepository();
            var returnId=await repository.saveSharedSetting(dataObj);
                    
            res.send({id:returnId});
        }
        catch (err)  {
            if (req && req.query)
              handleError("Error saving shared setting :"+err);
            res.status(501);
            res.send("Shared setting can not be stored: "+err);
            console.error("Send 501:"+err);
        }        
    });

    app.get('/getSharedSetting',jsonParser, async function(req, res) {
        try {
            
            addCrossOrginHeader(res);
            if (!req.query.data || req.query.data.length>50) {
                throw "Data to long or not present";
            }
            var params = JSON.parse(req.query.data);
            var settingId=utilities.checkString("id", true,params.id,value=>value.length<50 );
            
            var repository=getDefaultRepository();
            var result=await repository.getSharedSetting(settingId);
                    
            res.send(result);
        }
        catch (err)  {
            if (req && req.query)
              handleError("Error saving shared setting :"+err+":"+JSON.stringify(params));
            res.status(501);
            res.send("Shared setting can not be stored: "+err);
            console.error("Send 501:"+err);
        }        
    });

    
}
main().catch( handleErrorConsole);
