import * as crypto from "crypto";
import {getDefaultRepository, IRepository, StoredHighScore} from "./Repository.js";
import * as configuration from './Configuration.json';
import * as secrets from './Secrets.json';
import * as utilities from './Utilities.js';

export enum GameType {
    None=0,
    StarGame=1}

export class HighScore { 
  level : number;
  score : number;
  name : string;
  timeStamp : number;
}
export interface IMultiHighScoreResult  {
    ranking : number;
    quarterRanking: number;
} 

export class Game {

    constructor (
        public game : GameType,
        public maxLevel : number,

        public privateKey : string,
        public highIsBetter : boolean) {}

    public highScores : HighScore[]= [];

    public insert(index : number,score : HighScore) {
        this.highScores.splice(index,0,score);
    }
    public add(score : HighScore) {
        this.highScores.push(score);
    }
    public delete(index: number) {
        this.highScores.splice(index,1);
    }
    public clearScores() {
        this.highScores=[];
    }
}
export class GameManager {

     _
     private _repository : IRepository;

    private games : Game[] = [
        new Game( GameType.None,5,"",false),//removed
        new Game( GameType.StarGame,5,secrets.StarGameKey,false)
        
    ]
    private HASH_SHARED_SECRET : string= secrets.GameSharedKey;

    private _lastQuery : number;
    //this.serverSessionId ,value.timeStamp, value.endDistance,value.endDuration)
    private internalHashCalc(serverSessionId :string,timeStamp : string,endDistance : number,endDuration : number) {
        var hashString : string =
            this.HASH_SHARED_SECRET+
            endDistance.toString()+
            endDuration.toString()+
            serverSessionId+
            timeStamp+
            this.HASH_SHARED_SECRET;
        return hashString;    
    }
    public async load() {
        this._lastQuery= new Date().getTime();
        this._repository=getDefaultRepository();
        let loaders=[];
        this.games.forEach(game=>{
            loaders.push(this.loadGame(game));
        });
        return Promise.all(loaders);
    }
    public async loadGame(game : Game) {
        if (this._repository) {
            let loaded= await this._repository.loadHighScore(<number>game.game);
            if (loaded) {
                game.clearScores();
                loaded.highscores.forEach(score=>{
                    
                    let newScore=new HighScore;
                    newScore.level=score.level;
                    newScore.name=score.name;
                    newScore.score=score.score;
                    newScore.timeStamp=score.isoDateTime.getTime();
                    game.add(newScore)
                })
            }
        }
        
    }
    public calcHash(game : GameType,score : HighScore): string {
        var settings= this.getGame(game);
        var hashString : string =
              this.internalHashCalc(settings.privateKey,score.name,score.level,score.score);
            
        var sha256 = crypto.createHash("sha256");
        sha256.update(hashString, "ascii");
        var newHash : string = sha256.digest("hex");
        return newHash;
    }

    public getGame(game : GameType) : Game {
        return this.games[<number>game]
        
    }
    
    public newHighScore(gameType: GameType,score : HighScore,hashCheck : string,checkOnly :boolean,skipCheck=false,skipSave=false) : number {
        var result=-1;
        let game= this.getGame(gameType);
        if (!skipCheck) {
            let calcHash=this.calcHash(gameType,score);
            if (calcHash != hashCheck) {
                throw "High score not accepted"
            }   
        }
        
        var addAtEnd=false;
        let levelCount=0;
        if (game.highScores.length==0) {
            addAtEnd=true;
        }
        else {
            //make sure that a user only has one score (the best score)
            //first remove existing scores which are lower 
            //and check if there is a score which is higher

            var hasAlreadyHigherScore=false;
            for(var i=0;i<game.highScores.length;i++) {
                var current=game.highScores[i];
                if (current.level==score.level) {
                    levelCount++;
                    if (result<0 && !hasAlreadyHigherScore && current.name.toLowerCase()==score.name.toLowerCase() && current.level==score.level) {
                    
                        if (((game.highIsBetter && current.score<score.score) || 
                           (!game.highIsBetter && current.score>score.score) ) ) {
                            //remove the existing score, the user has a better score
                            game.delete(i);
                            i--;
                            levelCount--;
                        }                    
                        else {
                            //score is worse do not add this score, keep the best score
                            hasAlreadyHigherScore=true;
                            
                            result= levelCount;
                        }
                    }   
    
                }

            }
            if (!hasAlreadyHigherScore && result<0) {
                levelCount=0;
                for(var i=0;i<game.highScores.length;i++) {
                    var current=game.highScores[i];
                    if ( current.level==score.level) {
                        levelCount++;
                        if (levelCount<=game.maxLevel && result<0) {
                            if (((game.highIsBetter && current.score<score.score) || 
                                (!game.highIsBetter && current.score>score.score) ) && result<0)  {  
                                result=levelCount;                
                                if (!checkOnly) {
                                    game.insert(i,score); 
                                    //levelCount++;
                                }
                                
                            }
                            else if (i==game.highScores.length-1 ) {
                                addAtEnd=true;
                            }
                        }
                        else {
                            if (levelCount>game.maxLevel && i<game.highScores.length) {
                                if (!checkOnly) {
                                    game.delete(i);
                                    i--;
                                }
                            } 
                        }                              
                        
                    }
                    else if (current.level>score.level) { //the insert after the last of the level
                        if (levelCount<game.maxLevel && result<0) {
                            //there should be room in the level
                              if (i<game.highScores.length) {
                                if (!checkOnly) game.insert(i,score);
                                levelCount++;
                                result=levelCount;                            
                              } 
                              else {
                                  levelCount++;
                                  result=levelCount;
                                  if (!checkOnly) game.add(score);
                              }
                              i++;
                            
                        }
                    }
                    if (result<0 && i==game.highScores.length-1 
                         && current.level<score.level 
                         && levelCount<game.maxLevel) {
                        addAtEnd=true;
                    }
                }
    
            }
    
        }
        if (addAtEnd && levelCount<game.maxLevel) {
            levelCount++;
            result=levelCount;
            if (!checkOnly) {
              game.add(score);  
            }
        }
        if (result>=0 && !checkOnly && !skipSave) this.saveHighScores(game);
        return result;
        
    }
    public newMultiHighScore(gameType: number, highScore: HighScore, hash : string,checkOnly: boolean) : IMultiHighScoreResult {
        var game= this.getGame(gameType);
        if (gameType === GameType.StarGame) {
            highScore.level = 0;//auto determine level never let the user set the level, because this is used for quarter ranking rankings
        }
        this.cleanUpHighScores(game);
        var ranking = this.newHighScore(gameType, highScore, hash, checkOnly, false, true);
        var quarterRanking = -1;
        if (gameType === GameType.StarGame) {
            
            var quarterHighScore: HighScore = utilities.clone(highScore);
            let quarterLevel = this.calcQuarterHighScoreLevel();
            quarterHighScore.level = quarterLevel;
            quarterRanking = this.newHighScore(gameType, quarterHighScore, hash, checkOnly, true, true);
        }
        if (!checkOnly && (ranking >= 0 || quarterRanking >= 0)) {
            this.saveHighScores(game);
        }
        return { ranking,  quarterRanking };
    }

    protected saveHighScores(game : Game) {
        var highscores  : StoredHighScore[]= [];
        //clean old month high scores from memory and the database, the old
        game.highScores.forEach(s=>{
            highscores.push({
                    name:s.name,
                    level:s.level,
                    score:s.score,
                    isoDateTime:new Date(s.timeStamp)
                });
        })
        if (this._repository) {
            this._repository.saveGameHighScores({
                game: <number>game.game,
                isoDateTime: new Date(),
                highscores:highscores
            });
        }
        
    }
    
    private cleanUpHighScores(game: Game) {
        if (game.game == GameType.StarGame) {
            var currentLevel = this.calcQuarterHighScoreLevel();
            //keep only scores which are not from level 0 and not from the current level
            game.highScores = game.highScores.filter((score) => 
                (score.level == 0 || score.level === currentLevel));;
        }
    }

    public checkReload() {
        //more than one hour 
        let loadDelay=configuration.loadGamesTime||3600000;
        if ((new Date().getTime()- this._lastQuery)>loadDelay) {
            setTimeout(()=>{
                this.load();
            });            
        }
    }
    public queryHighScores(game : GameType,level? :number) : HighScore[] {
        this.checkReload();
        let gameObj=this.getGame(game);
        this.cleanUpHighScores(gameObj);
        return gameObj.highScores.filter( score=>(!level || score.level===level))
       
    }
    
    public calcQuarterHighScoreLevel() : number {
        //return 202601;
        var date = new Date();
        //calc start of quater year
        var month=  Math.floor((date.getMonth() - 1) / 3) * 3 + 1
        var level = month+ date.getFullYear() * 100;
        return level;
    }
}