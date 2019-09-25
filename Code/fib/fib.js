const fibelements = [
/*declaring known fib numbers*/
   [false,   (vars)=>{return vars[0]==0},   (vars)=>{return 0}],
   [false,   (vars)=>{return vars[0]==1},   (vars)=>{return 1}],
/*declaring unknown fib numbers recursively*/
   [true,   (vars)=>{return true},   (vars)=>{return fib([vars[0]-1])+fib([vars[0]-2])}],
];

var fibcache = [];

/**fibonacci sequence is declared recursively*/
function fib(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fibelements, fibcache);
}

function mapfib(variablelist){
   return variablelist.map(variables => {
      return fib(variables);
   }).filter(x => x != null);
}

function htmlfib(HTMLelement, variables) {
   HTMLelement.innerHTML = fib(variables);
}


