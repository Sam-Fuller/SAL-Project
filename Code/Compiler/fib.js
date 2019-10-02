const fibelements = [
/*declaring known fib numbers*/
   [false,   (vars)=>{return vars[0]==0},   (vars)=>{return 0}],
   [false,   (vars)=>{return vars[0]==1},   (vars)=>{return 1}],
/*declaring unknown fib numbers recursively*/
   [true,   (vars)=>{return true},   (vars)=>{var a=fib([vars[0]-1]); return a+fib([vars[0]-2])}],
];

var fibcache = [];

/**fibonacci sequence is declared recursively*/
function fib(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fibelements, fibcache);
}

function mapfib(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return fib(currentVariables);
   }).filter(x => x != null);
}

function htmlfib(HTMLelement, variables) {
   HTMLelement.innerHTML = fib(variables);
}


