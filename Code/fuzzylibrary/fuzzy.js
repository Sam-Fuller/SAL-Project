const fuzzyTriangularelements = [
/*case: input is left of the left foot*/
   [false,   (vars)=>{return vars[3]<=vars[0]},   (vars)=>{return 0}],
/*case: input is between the left foot and the shoulder*/
   [false,   (vars)=>{return vars[3]>vars[0]&&vars[3]<=vars[1]},   (vars)=>{return (vars[3]-vars[0])/(vars[1]-vars[0])}],
/*case: input is between the shoulder and the right foot*/
   [false,   (vars)=>{return vars[3]>vars[1]&&vars[3]<vars[2]},   (vars)=>{return 1-(vars[3]-vars[1])/(vars[2]-vars[1])}],
/*case: input is right of the right foot*/
   [false,   (vars)=>{return vars[3]>=vars[2]},   (vars)=>{return 0}],
];

var fuzzyTriangularcache = [];

/**a fuzzy triangular membership function
*fuzzyTriangular(leftFoot, shoulder, rightFoot, input)*/
function fuzzyTriangular(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyTriangularelements, fuzzyTriangularcache);
}

function mapfuzzyTriangular(variablelist){
   return variablelist.map(variables => {
      return fuzzyTriangular(variables);
   }).filter(x => x != null);
}

function htmlfuzzyTriangular(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyTriangular(variables);
}


const fuzzyTrapezoidalelements = [
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

var fuzzyTrapezoidalcache = [];

/**a trapezoidal membershi function
*fuzzyTrapezoidal(leftFoot, leftShoulder, rightShoulder, rightFoot, input)*/
function fuzzyTrapezoidal(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyTrapezoidalelements, fuzzyTrapezoidalcache);
}

function mapfuzzyTrapezoidal(variablelist){
   return variablelist.map(variables => {
      return fuzzyTrapezoidal(variables);
   }).filter(x => x != null);
}

function htmlfuzzyTrapezoidal(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyTrapezoidal(variables);
}


const fuzzyGaussianelements = [
   [false,   (vars)=>{return true},   (vars)=>{return Math.E**(-0.5*((vars[2]-vars[0])/vars[1])**2)}],
];

var fuzzyGaussiancache = [];

/**a fuzzy gaussian membership function
*fuzzyGaussian(center, deviation, input)*/
function fuzzyGaussian(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyGaussianelements, fuzzyGaussiancache);
}

function mapfuzzyGaussian(variablelist){
   return variablelist.map(variables => {
      return fuzzyGaussian(variables);
   }).filter(x => x != null);
}

function htmlfuzzyGaussian(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyGaussian(variables);
}


const fuzzyBellelements = [
   [false,   (vars)=>{return true},   (vars)=>{return 1/(1+Math.abs((vars[3]-vars[2])/vars[0])**(2*vars[1]))}],
];

var fuzzyBellcache = [];

/**a fuzzy bell membership function
*fuzzyBell(a, b, c, input)*/
function fuzzyBell(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fuzzyBellelements, fuzzyBellcache);
}

function mapfuzzyBell(variablelist){
   return variablelist.map(variables => {
      return fuzzyBell(variables);
   }).filter(x => x != null);
}

function htmlfuzzyBell(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyBell(variables);
}


