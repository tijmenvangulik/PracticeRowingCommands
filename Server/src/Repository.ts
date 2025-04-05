import { GameType } from './MessageData.js';
import {ActivityLog} from './ActivityLog.js';
export interface StoredHighScore {
  name : string;
  isoDateTime : Date;
  score : number;
  level : number;
}
export interface StoredGame  {
  highscores : StoredHighScore[];
  isoDateTime : Date;
  game : GameType;
}

export interface FeedBack {
  text : string;
  smiley : string;
  time : Date;
  app : string;
}

export interface IRepository {
  saveFeedback(data: FeedBack);
  saveGameHighScores(data : StoredGame) : Promise<void>;
  loadHighScore(game : GameType) : Promise<StoredGame>;
  saveActivityLog(logs :ActivityLog[]): Promise<void>;

  saveSharedSetting(settings : object) : Promise<string>
  getSharedSetting(id : string) : Promise<object> 
}

var defaultRepository : IRepository =null;

export function getDefaultRepository() :  IRepository {
 return defaultRepository;
}

export function setDefaultRepository(value : IRepository) {
  defaultRepository=value;
}
