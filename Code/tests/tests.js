const arrayConstructorelements = [
   [false,   (vars)=>{return true},   (vars)=>{return salListGenerator(1,10)}],
];

var arrayConstructorcache = [];

/***/
function arrayConstructor(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, arrayConstructorelements, arrayConstructorcache);
}

function maparrayConstructor(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return arrayConstructor(currentVariables);
   }).filter(x => x != null);
}

function htmlarrayConstructor(HTMLelement, variables) {
   HTMLelement.innerHTML = arrayConstructor(variables);
}


const arrayLengthelements = [
   [false,   (vars)=>{return true},   (vars)=>{return salLength(arrayConstructor([]))}],
];

var arrayLengthcache = [];

/***/
function arrayLength(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, arrayLengthelements, arrayLengthcache);
}

function maparrayLength(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return arrayLength(currentVariables);
   }).filter(x => x != null);
}

function htmlarrayLength(HTMLelement, variables) {
   HTMLelement.innerHTML = arrayLength(variables);
}


const concat2Arrayelements = [
   [false,   (vars)=>{return true},   (vars)=>{return arrayConstructor([]).concat(arrayConstructor([]))}],
];

var concat2Arraycache = [];

/***/
function concat2Array(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, concat2Arrayelements, concat2Arraycache);
}

function mapconcat2Array(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return concat2Array(currentVariables);
   }).filter(x => x != null);
}

function htmlconcat2Array(HTMLelement, variables) {
   HTMLelement.innerHTML = concat2Array(variables);
}


const concat1Arrayelements = [
   [false,   (vars)=>{return true},   (vars)=>{return salJoin(arrayConstructor([]))}],
];

var concat1Arraycache = [];

/***/
function concat1Array(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, concat1Arrayelements, concat1Arraycache);
}

function mapconcat1Array(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return concat1Array(currentVariables);
   }).filter(x => x != null);
}

function htmlconcat1Array(HTMLelement, variables) {
   HTMLelement.innerHTML = concat1Array(variables);
}


const addArrayelements = [
   [false,   (vars)=>{return true},   (vars)=>{return salSum(arrayConstructor([]))}],
];

var addArraycache = [];

/***/
function addArray(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, addArrayelements, addArraycache);
}

function mapaddArray(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return addArray(currentVariables);
   }).filter(x => x != null);
}

function htmladdArray(HTMLelement, variables) {
   HTMLelement.innerHTML = addArray(variables);
}


const prodArrayelements = [
   [false,   (vars)=>{return true},   (vars)=>{return salProduct(arrayConstructor([]))}],
];

var prodArraycache = [];

/***/
function prodArray(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, prodArrayelements, prodArraycache);
}

function mapprodArray(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return prodArray(currentVariables);
   }).filter(x => x != null);
}

function htmlprodArray(HTMLelement, variables) {
   HTMLelement.innerHTML = prodArray(variables);
}


const noPredelements = [
   [false,   (vars)=>{return true},   (vars)=>{return vars[0]>10}],
];

var noPredcache = [];

/***/
function noPred(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, noPredelements, noPredcache);
}

function mapnoPred(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return noPred(currentVariables);
   }).filter(x => x != null);
}

function htmlnoPred(HTMLelement, variables) {
   HTMLelement.innerHTML = noPred(variables);
}


const somePredelements = [
   [false,   (vars)=>{return true},   (vars)=>{return vars[0]>5}],
];

var somePredcache = [];

/***/
function somePred(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, somePredelements, somePredcache);
}

function mapsomePred(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return somePred(currentVariables);
   }).filter(x => x != null);
}

function htmlsomePred(HTMLelement, variables) {
   HTMLelement.innerHTML = somePred(variables);
}


const allPredelements = [
   [false,   (vars)=>{return true},   (vars)=>{return vars[0]>0}],
];

var allPredcache = [];

/***/
function allPred(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, allPredelements, allPredcache);
}

function mapallPred(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return allPred(currentVariables);
   }).filter(x => x != null);
}

function htmlallPred(HTMLelement, variables) {
   HTMLelement.innerHTML = allPred(variables);
}


const allArrayFalseelements = [
   [false,   (vars)=>{return true},   (vars)=>{return salAll(mapsomePred([arrayConstructor([])]))}],
];

var allArrayFalsecache = [];

/***/
function allArrayFalse(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, allArrayFalseelements, allArrayFalsecache);
}

function mapallArrayFalse(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return allArrayFalse(currentVariables);
   }).filter(x => x != null);
}

function htmlallArrayFalse(HTMLelement, variables) {
   HTMLelement.innerHTML = allArrayFalse(variables);
}


const allArrayTrueelements = [
   [false,   (vars)=>{return true},   (vars)=>{return salAll(mapallPred([arrayConstructor([])]))}],
];

var allArrayTruecache = [];

/***/
function allArrayTrue(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, allArrayTrueelements, allArrayTruecache);
}

function mapallArrayTrue(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return allArrayTrue(currentVariables);
   }).filter(x => x != null);
}

function htmlallArrayTrue(HTMLelement, variables) {
   HTMLelement.innerHTML = allArrayTrue(variables);
}


const anyArrayFalseelements = [
   [false,   (vars)=>{return true},   (vars)=>{return salAny(mapnoPred([arrayConstructor([])]))}],
];

var anyArrayFalsecache = [];

/***/
function anyArrayFalse(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, anyArrayFalseelements, anyArrayFalsecache);
}

function mapanyArrayFalse(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return anyArrayFalse(currentVariables);
   }).filter(x => x != null);
}

function htmlanyArrayFalse(HTMLelement, variables) {
   HTMLelement.innerHTML = anyArrayFalse(variables);
}


const anyArrayTrueelements = [
   [false,   (vars)=>{return true},   (vars)=>{return salAny(mapsomePred([arrayConstructor([])]))}],
];

var anyArrayTruecache = [];

/***/
function anyArrayTrue(variables){
   if(typeof(variables) != "object") variables = [variables];
   return salfunction(variables, anyArrayTrueelements, anyArrayTruecache);
}

function mapanyArrayTrue(variables){
   return variables.shift().map(variable => {
      var currentVariables = variables.slice(0, variables.length);
      currentVariables.unshift(variable);
      return anyArrayTrue(currentVariables);
   }).filter(x => x != null);
}

function htmlanyArrayTrue(HTMLelement, variables) {
   HTMLelement.innerHTML = anyArrayTrue(variables);
}


