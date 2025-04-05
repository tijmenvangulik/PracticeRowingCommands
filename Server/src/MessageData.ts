export enum GameType {
  Shark = 0,
  StarGame = 1,
}

export interface BaseGameHighScore {
  game : GameType;
  level : number;
  score : number;

  name : string;
}
export interface NewGameHighScore extends BaseGameHighScore {
  hash : string;
  checkOnly : boolean;
}

export interface GameHighScore extends BaseGameHighScore {

}

export interface GameHighScoresResult {
  scores : GameHighScore[]
}
export interface GameHighScoreQuery {
  game : GameType;
  level : number;
}
export interface SendFeedBack {
  text : string;
  smiley : string;
  app : string;
}