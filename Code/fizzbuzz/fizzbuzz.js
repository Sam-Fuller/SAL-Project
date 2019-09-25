const fizzelements = [
   [false,   (vars)=>{return vars[0]<3},   (vars)=>{return ""}],
   [false,   (vars)=>{return vars[0]==3},   (vars)=>{return "fizz"}],
   [false,   (vars)=>{return true},   (vars)=>{return fizz([vars[0]-3])}],
];

var fizzcache = [];

/**defining fizz recursively*/
function fizz(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fizzelements, fizzcache);
}

function mapfizz(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return fizz(currentVariables);
   }).filter(x => x != null);
}

function htmlfizz(HTMLelement, variables) {
   HTMLelement.innerHTML = fizz(variables);
}


const buzzelements = [
   [false,   (vars)=>{return vars[0]<5},   (vars)=>{return ""}],
   [false,   (vars)=>{return vars[0]==5},   (vars)=>{return "buzz"}],
   [false,   (vars)=>{return true},   (vars)=>{return buzz([vars[0]-5])}],
];

var buzzcache = [];

/***/
function buzz(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, buzzelements, buzzcache);
}

function mapbuzz(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return buzz(currentVariables);
   }).filter(x => x != null);
}

function htmlbuzz(HTMLelement, variables) {
   HTMLelement.innerHTML = buzz(variables);
}


const stringoutelements = [
   [true,   (vars)=>{return true},   (vars)=>{return fizz([vars[0]])+buzz([vars[0]])}],
];

var stringoutcache = [];

/**if the cardinality of out for x is 0, return x, else return the concatenation of out*/
function stringout(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, stringoutelements, stringoutcache);
}

function mapstringout(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return stringout(currentVariables);
   }).filter(x => x != null);
}

function htmlstringout(HTMLelement, variables) {
   HTMLelement.innerHTML = stringout(variables);
}


const singleoutelements = [
   [true,   (vars)=>{return stringout([vars[0]])==""},   (vars)=>{return vars[0]}],
   [true,   (vars)=>{return true},   (vars)=>{return stringout([vars[0]])}],
];

var singleoutcache = [];

/***/
function singleout(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, singleoutelements, singleoutcache);
}

function mapsingleout(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return singleout(currentVariables);
   }).filter(x => x != null);
}

function htmlsingleout(HTMLelement, variables) {
   HTMLelement.innerHTML = singleout(variables);
}


const fizzbuzzelements = [
   [false,   (vars)=>{return vars[0]>0},   (vars)=>{return mapsingleout([salListGenerator(0,vars[0])])}],
];

var fizzbuzzcache = [];

/***/
function fizzbuzz(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, fizzbuzzelements, fizzbuzzcache);
}

function mapfizzbuzz(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return fizzbuzz(currentVariables);
   }).filter(x => x != null);
}

function htmlfizzbuzz(HTMLelement, variables) {
   HTMLelement.innerHTML = fizzbuzz(variables);
}


