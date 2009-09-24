/* 

= Examples =

$('one').animate('red short');
$$('.hey').animate('red short');
$$('.hey').animate('red short', { startClassNames : 'blue long', duration : '2000', onComplete : function() { alert('done'); } });

$('one').animateSwap('blue short', 'red long', { duration : '4000' });
$('one').animateAdd('blue short', { duration : '4000' });
$('one').animateRemove('blue short', { duration : '4000' });

= Transitions =

* Animator.tx.easeInOut is the default transition, and creates a smooth effect
* Animator.tx.linear maintains a constant rate of animation
* Animator.tx.easeIn starts slow, gets faster
* Animator.tx.strongEaseIn exaggerated version of the above
* Animator.tx.easeOut starts fast, gets slower
* Animator.tx.strongEaseOut exaggerated version of the above
* Animator.tx.elastic go slightly past the target point, then be drawn back
* Animator.tx.veryElastic as above, but with an extra pass
* Animator.tx.bouncy Hit the target point then bounce back
* Animator.tx.veryBouncy as above, but with an extra 2 bounces

= Options =

 * delay : 3 // seconds to delay execution
 * startClassNames : 'small white'
 * interval: 20,  // time between animation frames
 * duration: 400, // length of animation
 * onComplete: function(){}
 * onStep: function(){}
 * transition: Animator.tx.easeInOut

*/

var AnimationAdapter = {
	animate : function(elements, destClassNames, animationOptions) {
		var performAnimation = function() {
		  var animator = null;
			if (animationOptions != null && animationOptions.startClassNames != null) {
				animator = Animator.apply(elements, [ animationOptions.startClassNames, destClassNames ], animationOptions);
			} else { // use current styles as starting state
			  animator = Animator.apply(elements, destClassNames, animationOptions);
			}
		  animator.play();
		};
		var delaySeconds = animationOptions && animationOptions.delay;
		delaySeconds ? performAnimation.delay(delaySeconds) : performAnimation.call();
    return elements;
	},
	// changes the element by removing start class names, and adding dest class names through animations
	// leaves classes that are not mentioned untouched on element
	animateSwap : function(el, startClassNames, destClassNames, animationOptions) {
		var currentClassNames = $w(el.className); startClassNames = $w(startClassNames); destClassNames = $w(destClassNames);
	  var resultClassNames = currentClassNames.reject(function(e) { return startClassNames.include(e); }).concat(destClassNames);
		AnimationAdapter.animate(el, resultClassNames.join(" "), animationOptions);
		return el;
	},
	// appends and animates adding class names onto an element
	animateAdd : function(el, addedClassNames, animationOptions) {
	  AnimationAdapter.animateSwap(el, '', addedClassNames, animationOptions);
	},
	// appends and animates removing class names onto an element
	animateRemove : function(el, removedClassNames, animationOptions) {
	  AnimationAdapter.animateSwap(el, removedClassNames, '', animationOptions);
	}
};

var ArrayAnimationAdapter = {
	animate : function(destClassNames, animationOptions) {
		AnimationAdapter.animate(this, destClassNames, animationOptions);
	}
};

Element.addMethods(AnimationAdapter);
Object.extend(Array.prototype, ArrayAnimationAdapter); 
