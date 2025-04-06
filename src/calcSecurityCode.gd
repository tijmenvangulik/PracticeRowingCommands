extends Node

func calcHashString(privateKey,name ,level ,score ):
	var hashString  = Secrets.GameSharedKey+str(level)+str(score)+privateKey+name+ Secrets.GameSharedKey;
	return hashString;    

func calcHash(dataStr):
	return dataStr.sha256_text()
	
func calcHashScore(name ,level ,score ):
	var hashkey=calcHashString(Secrets.StarGameKey,name ,level ,score)
	var result=calcHash(hashkey)
	return result
