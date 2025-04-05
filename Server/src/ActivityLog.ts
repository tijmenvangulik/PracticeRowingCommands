/**
 * Created by tijmen on 22-01-14.
 */

import * as config from './Configuration.json';

export interface ActivityLog {
    serverName : string;
    room : string;
    log : string;
    timeStamp : Date;
    data? : any
}

var _activityLog : ActivityLog[] = [];

var maxLog = config.maxLog||1000;

export function logText(roomName : string, logText : string, data? : any) {
    if (config.activityLog){
        if (_activityLog.length>maxLog)
          _activityLog.shift();
        _activityLog.push({
            serverName : config.logServerName,
            room :  roomName,
            log  : logText,
            timeStamp: new Date(),
            data: data
        });
    }
}
export function getActivityLog() : ActivityLog[]{
    return _activityLog;
}

export function clear() {
  _activityLog=[];  
}