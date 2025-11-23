/**
 * Created by tijmen on 19-11-13.
 */


export function checkString(attributeName : string,isRequired : boolean,value? : string,check? : (value : string) => boolean) : string {
    if ( !value){
        if (isRequired) throw "Atrribute "+attributeName+" can not be null"
        else return value
    }
    else if ( typeof value === "string"  && (!check || check(value))) return value
    else throw "Atrribute "+attributeName+" has wrong value: '"+value.toString()+"'";
}

export function checkNumber(attributeName : string,isRequired : boolean,value? : number,check? : (value : number) => boolean) : number {
    if ( !value && value!=0 ){
        if (isRequired) throw "Atrribute "+attributeName+" can not be null"
        else return value
    }
    else if ( typeof value === "number" && !isNaN(value) && value!=Infinity && (!check || check(value))) return value
    else throw "Atrribute "+attributeName+" has wrong value: '"+value.toString()+"'";
}

export function checkBoolean(attributeName : string,isRequired : boolean,value? : boolean,check? : (value : boolean) => boolean) : boolean {
    if ( value !=false && value !=true){
        if (isRequired) throw "Atrribute "+attributeName+" can not be null"
        else return value
    }
    else if ( typeof value === "boolean"  && (!check || check(value))) return value
    else throw "Atrribute "+attributeName+" has wrong value: '"+(<any>value).toString()+"'";
}

export function checkPropertiesExists(data :object,properties : string[]) : boolean {

    for (let i=0;i<properties.length;i++) {
        let name=properties[i];
        if (!data.hasOwnProperty(name))  {
            console.debug("missing property: "+name);
            return false;
        }
    }
    return true;
}
export function clone(obj : any) : any {
    if (obj == null || typeof(obj) != 'object')
        return obj;    
    var result= Object.assign({}, obj);      
    return result; 
}