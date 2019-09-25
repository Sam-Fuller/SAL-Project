const fuzzyInputselements = [
   [false,   (vars)=>{return vars[0]=="any"&&true},   (vars)=>{return null}],
   [false,   (vars)=>{return vars[0]=="temp-cold"&&true},   (vars)=>{return fuzzyInMFTriangular([0,5,30,vars[1][0]])}],
   [false,   (vars)=>{return vars[0]=="temp-warm"&&true},   (vars)=>{return fuzzyInMFGaussian([40,20,vars[1][0]])}],
   [false,   (vars)=>{return vars[0]=="temp-hot"&&true},   (vars)=>{return fuzzyInMFTrapezoidal([50,85,95,100,vars[1][0]])}],
];

var fuzzyInputscache = [];

/***/
function fuzzyInputs(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyInputselements, fuzzyInputscache);
}

function mapfuzzyInputs(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return fuzzyInputs(currentVariables);
   }).filter(x => x != null);
}

function htmlfuzzyInputs(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyInputs(variables);
}


const fuzzyOutputselements = [
   [false,   (vars)=>{return vars[0]=="any"&&true},   (vars)=>{return null}],
   [false,   (vars)=>{return vars[0]=="time-short"&&true},   (vars)=>{return fuzzyOutMFTriangular([0,5,10,vars[1]])}],
   [false,   (vars)=>{return vars[0]=="time-long"&&true},   (vars)=>{return fuzzyOutMFTriangular([5,30,35,vars[1]])}],
];

var fuzzyOutputscache = [];

/***/
function fuzzyOutputs(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyOutputselements, fuzzyOutputscache);
}

function mapfuzzyOutputs(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return fuzzyOutputs(currentVariables);
   }).filter(x => x != null);
}

function htmlfuzzyOutputs(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyOutputs(variables);
}


const rule1elements = [
   [false,   (vars)=>{return true},   (vars)=>{return [["temp-cold"],"time-short"]}],
];

var rule1cache = [];

/***/
function rule1(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, rule1elements, rule1cache);
}

function maprule1(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return rule1(currentVariables);
   }).filter(x => x != null);
}

function htmlrule1(HTMLelement, variables) {
   HTMLelement.innerHTML = rule1(variables);
}


const rule2elements = [
   [false,   (vars)=>{return true},   (vars)=>{return [["temp-warm"],"time-short"]}],
];

var rule2cache = [];

/***/
function rule2(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, rule2elements, rule2cache);
}

function maprule2(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return rule2(currentVariables);
   }).filter(x => x != null);
}

function htmlrule2(HTMLelement, variables) {
   HTMLelement.innerHTML = rule2(variables);
}


const rule3elements = [
   [false,   (vars)=>{return true},   (vars)=>{return [["temp-warm"],"time-long"]}],
];

var rule3cache = [];

/***/
function rule3(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, rule3elements, rule3cache);
}

function maprule3(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return rule3(currentVariables);
   }).filter(x => x != null);
}

function htmlrule3(HTMLelement, variables) {
   HTMLelement.innerHTML = rule3(variables);
}


const rule4elements = [
   [false,   (vars)=>{return true},   (vars)=>{return [["temp-hot"],"time-long"]}],
];

var rule4cache = [];

/***/
function rule4(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, rule4elements, rule4cache);
}

function maprule4(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return rule4(currentVariables);
   }).filter(x => x != null);
}

function htmlrule4(HTMLelement, variables) {
   HTMLelement.innerHTML = rule4(variables);
}


const ruleListelements = [
   [false,   (vars)=>{return true},   (vars)=>{return [rule1([]),rule2([]),rule3([]),rule4([])]}],
];

var ruleListcache = [];

/***/
function ruleList(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, ruleListelements, ruleListcache);
}

function mapruleList(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return ruleList(currentVariables);
   }).filter(x => x != null);
}

function htmlruleList(HTMLelement, variables) {
   HTMLelement.innerHTML = ruleList(variables);
}


const fuzzyExampleelements = [
   [false,   (vars)=>{return true},   (vars)=>{return fuzzyAssessInput([ruleList([]),vars[0]])}],
];

var fuzzyExamplecache = [];

/***/
function fuzzyExample(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyExampleelements, fuzzyExamplecache);
}

function mapfuzzyExample(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return fuzzyExample(currentVariables);
   }).filter(x => x != null);
}

function htmlfuzzyExample(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyExample(variables);
}


const fuzzyAssessAllRuleselements = [
   [false,   (vars)=>{return true},   (vars)=>{return fuzzyOutputs([vars[0][1],(salSum(mapfuzzyInputs([vars[0][0],vars[1]]))/salLength(vars[1]))])}],
];

var fuzzyAssessAllRulescache = [];

/***/
function fuzzyAssessAllRules(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyAssessAllRuleselements, fuzzyAssessAllRulescache);
}

function mapfuzzyAssessAllRules(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return fuzzyAssessAllRules(currentVariables);
   }).filter(x => x != null);
}

function htmlfuzzyAssessAllRules(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyAssessAllRules(variables);
}


const fuzzyTotalMembershipelements = [
   [false,   (vars)=>{return true},   (vars)=>{return salSum(mapfuzzyInputs([vars[0][0],vars[1]]))/salLength(vars[1])}],
];

var fuzzyTotalMembershipcache = [];

/***/
function fuzzyTotalMembership(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyTotalMembershipelements, fuzzyTotalMembershipcache);
}

function mapfuzzyTotalMembership(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return fuzzyTotalMembership(currentVariables);
   }).filter(x => x != null);
}

function htmlfuzzyTotalMembership(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyTotalMembership(variables);
}


const fuzzyAssessInputelements = [
   [false,   (vars)=>{return true},   (vars)=>{return salSum(mapfuzzyAssessAllRules([vars[0],vars[1]]))/salSum(mapfuzzyTotalMembership([vars[0],vars[1]]))}],
];

var fuzzyAssessInputcache = [];

/***/
function fuzzyAssessInput(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyAssessInputelements, fuzzyAssessInputcache);
}

function mapfuzzyAssessInput(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return fuzzyAssessInput(currentVariables);
   }).filter(x => x != null);
}

function htmlfuzzyAssessInput(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyAssessInput(variables);
}


const fuzzyOutMFTriangularelements = [
/*case: membership is 0*/
   [false,   (vars)=>{return vars[3]==0},   (vars)=>{return null}],
/*case: mebership is 1*/
   [false,   (vars)=>{return vars[3]==1},   (vars)=>{return vars[1]}],
/*general case*/
   [false,   (vars)=>{return true},   (vars)=>{return (((vars[3]*(vars[1]-vars[0])+vars[0])+(1-vars[3])*(vars[2]-vars[1])+vars[1])/2)*vars[3]}],
];

var fuzzyOutMFTriangularcache = [];

/**a fuzzy triangular membership function
*fuzzyInMFTriangular(leftFoot, shoulder, rightFoot, membership)*/
function fuzzyOutMFTriangular(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyOutMFTriangularelements, fuzzyOutMFTriangularcache);
}

function mapfuzzyOutMFTriangular(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return fuzzyOutMFTriangular(currentVariables);
   }).filter(x => x != null);
}

function htmlfuzzyOutMFTriangular(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyOutMFTriangular(variables);
}


const fuzzyOutMFTrapezoidalelements = [
/*case: membership is 0*/
   [false,   (vars)=>{return vars[4]==0},   (vars)=>{return null}],
/*case: mebership is 1*/
   [false,   (vars)=>{return vars[4]==1},   (vars)=>{return (vars[1]+vars[2])/2}],
/*general case*/
   [false,   (vars)=>{return true},   (vars)=>{return (((vars[4]*(vars[1]-vars[0])+vars[0])+(1-vars[4])*(vars[3]-vars[2])+vars[2])/2)*vars[4]}],
];

var fuzzyOutMFTrapezoidalcache = [];

/**a fuzzy trapezoidal membership function
*fuzzyOutMFTrapezoidal(leftFoot, leftShoulder, rightShoulder, rightFoot, membership)*/
function fuzzyOutMFTrapezoidal(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyOutMFTrapezoidalelements, fuzzyOutMFTrapezoidalcache);
}

function mapfuzzyOutMFTrapezoidal(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return fuzzyOutMFTrapezoidal(currentVariables);
   }).filter(x => x != null);
}

function htmlfuzzyOutMFTrapezoidal(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyOutMFTrapezoidal(variables);
}


const fuzzyOutMFGaussianelements = [
   [false,   (vars)=>{return true},   (vars)=>{return vars[0]*vars[2]}],
];

var fuzzyOutMFGaussiancache = [];

/**a fuzzy gaussian membership function 
*fuzzyOutMFGaussian(center, deviation, membership)*/
function fuzzyOutMFGaussian(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyOutMFGaussianelements, fuzzyOutMFGaussiancache);
}

function mapfuzzyOutMFGaussian(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return fuzzyOutMFGaussian(currentVariables);
   }).filter(x => x != null);
}

function htmlfuzzyOutMFGaussian(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyOutMFGaussian(variables);
}


const fuzzyInMFTriangularelements = [
/*case: input is left of the left foot*/
   [false,   (vars)=>{return vars[3]<=vars[0]},   (vars)=>{return 0}],
/*case: input is between the left foot and the shoulder*/
   [false,   (vars)=>{return vars[3]>vars[0]&&vars[3]<=vars[1]},   (vars)=>{return (vars[3]-vars[0])/(vars[1]-vars[0])}],
/*case: input is between the shoulder and the right foot*/
   [false,   (vars)=>{return vars[3]>vars[1]&&vars[3]<vars[2]},   (vars)=>{return 1-(vars[3]-vars[1])/(vars[2]-vars[1])}],
/*case: input is right of the right foot*/
   [false,   (vars)=>{return vars[3]>=vars[2]},   (vars)=>{return 0}],
];

var fuzzyInMFTriangularcache = [];

/**a fuzzy triangular membership function
*fuzzyInMFTriangular(leftFoot, shoulder, rightFoot, input)*/
function fuzzyInMFTriangular(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyInMFTriangularelements, fuzzyInMFTriangularcache);
}

function mapfuzzyInMFTriangular(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return fuzzyInMFTriangular(currentVariables);
   }).filter(x => x != null);
}

function htmlfuzzyInMFTriangular(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyInMFTriangular(variables);
}


const fuzzyInMFTrapezoidalelements = [
/*case: input is left of the left foot*/
   [false,   (vars)=>{return vars[4]<=vars[0]},   (vars)=>{return 0}],
/*case: input is between the left foot and the right shoulder*/
   [false,   (vars)=>{return vars[4]>vars[0]&&vars[4]<=vars[1]},   (vars)=>{return (vars[4]-vars[0])/(vars[1]-vars[0])}],
/*case: input is between the two shoulders*/
   [false,   (vars)=>{return vars[4]>vars[1]&&vars[4]<vars[2]},   (vars)=>{return 1}],
/*case: input is between the left shoulder and the right foot*/
   [false,   (vars)=>{return vars[4]>=vars[2]&&vars[4]<vars[3]},   (vars)=>{return 1-(vars[4]-vars[2])/(vars[3]-vars[2])}],
   [false,   (vars)=>{return vars[4]>=vars[3]},   (vars)=>{return 0}],
];

var fuzzyInMFTrapezoidalcache = [];

/**a trapezoidal membershi function
*fuzzyTrapezoidal(leftFoot, leftShoulder, rightShoulder, rightFoot, input)*/
function fuzzyInMFTrapezoidal(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyInMFTrapezoidalelements, fuzzyInMFTrapezoidalcache);
}

function mapfuzzyInMFTrapezoidal(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return fuzzyInMFTrapezoidal(currentVariables);
   }).filter(x => x != null);
}

function htmlfuzzyInMFTrapezoidal(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyInMFTrapezoidal(variables);
}


const fuzzyInMFGaussianelements = [
   [false,   (vars)=>{return true},   (vars)=>{return Math.E**(-0.5*((vars[2]-vars[0])/vars[1])**2)}],
];

var fuzzyInMFGaussiancache = [];

/**a fuzzy gaussian membership function
*fuzzyGaussian(center, deviation, input)*/
function fuzzyInMFGaussian(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyInMFGaussianelements, fuzzyInMFGaussiancache);
}

function mapfuzzyInMFGaussian(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return fuzzyInMFGaussian(currentVariables);
   }).filter(x => x != null);
}

function htmlfuzzyInMFGaussian(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyInMFGaussian(variables);
}


