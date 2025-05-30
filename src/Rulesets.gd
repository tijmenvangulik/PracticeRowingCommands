extends Node

class_name RuleSets

# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var defaultRuleset="RulesetDefault"
var currentRulleset=defaultRuleset

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func getRuleset()->BaseRuleset :
	var rulset=currentRulleset
	if GameState.collectGameState==Constants.CollectGameState.DoStart:
		return $RulesetDefault as BaseRuleset
#	if rulset==defaultRuleset:
#		rulset=Utilities.getDefaultSetting("LanguageRuleSet")	
	var ruleset=get_node(rulset)
	if ruleset==null:
		ruleset=$RulesetDefault
	return ruleset

func getRulesets():
	var result=[]
	for N in self.get_children():
		result.append(N.name)
	return result
	
func setRuleset(ruleSet):
	currentRulleset=ruleSet
