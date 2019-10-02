const fuzzyOutMFTriangularelements = [
   [false,   (vars)=>{return vars[3]==0},   (vars)=>{return null}],
   [false,   (vars)=>{return true},   (vars)=>{return ((vars[3]*(vars[1]-vars[0])+vars[0])+(1-vars[3])*(vars[2]-vars[1])+vars[1])/2}],
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
      var currentVariables = variables;
      currentVariables.unshift(variable);
      return fuzzyOutMFTriangular(variable);
   }).filter(x => x != null);
}

function htmlfuzzyOutMFTriangular(HTMLelement, variables) {
   HTMLelement.innerHTML = fuzzyOutMFTriangular(variables);
}


