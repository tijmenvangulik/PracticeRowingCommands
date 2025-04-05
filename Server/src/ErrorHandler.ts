import * as activityLog from './ActivityLog.js';

export function handleErrorConsole(e : any) {
  console.error(e);
}

export function handleError(e :any,roomName? : string ){
  handleErrorConsole(e);
  try {
    if (typeof activityLog!="undefined" && activityLog)
      activityLog.logText(roomName,"error",e);
  }
  catch(e) {
    handleErrorConsole(e);
  }
}