function salfunction(variables, elements, cache){
		//check cache
		//cycle all elements in cache
		if(cache.length > 0){
			for(var countcache = 0; countcache < cache.length; countcache++){
				//check inputs of each element
				var correct = false;
				//cycle cache element inputs
				for(var countcacheelement = 0; countcacheelement < cache[countcache][1].length && correct == false; countcacheelement++){
					if(cache[countcache][1][countcacheelement]==variables[countcacheelement]) correct = true;
				}
				if(correct) return cache[countcache][0];
			}
		}
		//check elements
		//cycle all elements
		for(var countelement = 0; countelement < elements.length; countelement++){
			//ensure inputs match
			if(elements[countelement][1](variables)){
				//check if caching is on
				if(elements[countelement][0]){
					//caching
					//calculate output
					var out = elements[countelement][2](variables);
					//add to cache
					cache.unshift([out, variables]);

					//return output
					return out;
				}else{
					//return function result
					return elements[countelement][2](variables);
				}
			}
		}
		//if no function found, return null
		return null;
}

function salListGenerator(a, b){
	var out = [];
	
	if(a > b){
		b = Math.ceil(b);
		a = Math.floor(a);

		while (a >= b){
			out.push(a);
			a--;
		}
	} else {
		a = Math.ceil(a);
		b = Math.floor(b);

		while (a <= b){
			out.push(a);
			a++;
		}
	}

	return out;
}

function salLength(list){
	return list.length;
}

function salJoin(list){
	return list.join('');
}

function salSum(list){
	return list.reduce((a,b) => a+b, 0);
}

function salProduct(list){
	return list.reduce((a,b) => a*b, 1);
}

function salAll(list){
	return list.reduce((a,b) => a && b, true);
}

function salAny(list){
	return list.reduce((a,b) => a || b, false);
}