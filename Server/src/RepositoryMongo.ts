import {IRepository,StoredGame,FeedBack} from "./Repository.js";
import {Collection, Db, MongoClient,MongoClientOptions,ObjectId} from "mongodb";
import {ActivityLog} from "./ActivityLog.js";
import {GameType} from "./MessageData.js"
import * as secrets from './Secrets.json';
import * as config from './Configuration.json';

interface SharedSetting {
  timeStamp : Date;
  accessTimeStamp : Date;
  accessCount : number;
  settings : object;
}

export class RepositoryMongo  implements IRepository {

  private _client : MongoClient;
  private _db : Db;

  async disconnect() {
    await this._client.close()
  }

  protected async ensureDataModel() {
    let highScores= await this.highScoreCollection();
    await highScores.createIndex(["game","_id"],{unique:true}); //just ensures there is an index
    let logs = await this.logCollection();
    logs.createIndex(["timeStamp"]); //just ensures there is an index

   
  }
  private _connected=false;

  async db() : Promise<Db>{
    
// Connect using MongoClient
    if (!this._client || !this._db || !this._connected) {
      this._connected=false;
      this._client= await MongoClient.connect(secrets.mongoDbConnect,<MongoClientOptions>{  });
      this._connected=true; 
      this._db=  this._client.db(config.dataBaseName||"ergometer-space");
//      this._client.on('open', _=>{
 //     });
      this._client.on('topologyClosed', _=>{ this._connected=false;});
     
    }
    return this._db;
  }
  
  //for now leave out the high scores
  protected async highScoreCollection() : Promise<Collection>{
    const db= await this.db();
    return await db.collection('gameHighScores');;
  }
  protected async feedbackCollection() : Promise<Collection>{
    const db= await this.db();
    return await db.collection('feedback');;
  } 
  
  async loadHighScore(game : GameType) : Promise<StoredGame> {

    const collection= await this.highScoreCollection();
    let list=  await collection.find({ game: { $eq: game } }).sort({_id:-1}).limit(1).toArray();
    if (list && list.length>0)
      return <any>list[0];
    //get the data from the original file, this will translate it
    return null;
    
  }
  async saveGameHighScores(data : StoredGame) : Promise<void> {
   
    const collection : any= await this.highScoreCollection();
    await collection.insertMany([data])  
    
   // await this.saveHighScores(name,data);
  }
  async saveFeedback(data : FeedBack) : Promise<void> {
   
    const collection : any= await this.feedbackCollection();
    await collection.insertMany([data])  
    
   // await this.saveHighScores(name,data);
  }
  
  protected async logCollection() : Promise<Collection>{
    const db= await this.db();
    //return await db.createCollection('logs',{ capped: true, size: 5000 });
    return await db.collection('logs');
  }
  

  async saveActivityLog(logs :ActivityLog[]) {
    let logCollection=await this.logCollection();
    await logCollection.insertMany(logs);
  }

  protected async sharedSettingCollection() : Promise<Collection>{
    const db= await this.db();
    return await db.collection('sharedSettings');;
  }
  async saveSharedSetting(settings : object) : Promise<string> {
    let collection=await this.sharedSettingCollection();
    var data : SharedSetting = {
      settings:settings,
      timeStamp:new Date(),
      accessTimeStamp:null,
      accessCount:0
    }
    var result=await collection.insertOne(data);
    return result.insertedId.toHexString();
  }
  
  async getSharedSetting(id : string) : Promise<object> {
    let collection=await this.sharedSettingCollection();
    var findId=new ObjectId(id);
    let result=await collection.findOne<SharedSetting>({_id: findId});
    result.accessTimeStamp=new Date(result.timeStamp);
    result.accessCount++;
    //do not await, we do not need to wait for the result
    collection.updateOne({_id: findId}, {
      $set: {
        accessTimeStamp: result.accessTimeStamp,
        accessCount: result.accessCount
      }
    });
    return result.settings;
  }
}