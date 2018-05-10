({
    onInit: function(component, event, helper) {
        // create a pill component with null value and label to enter the markup into cache
        helper.createOptionPill(component, event, helper);

        component.closeMenu = $A.getCallback(function() {
            if (component.isValid()) {

                component.set('v.menuIsOpen', false);

            } else {
                window.removeEventListener('click', component.closeMenu);
            }
        });

        window.addEventListener('click', component.closeMenu);

        var randomNumber = Math.floor(1000 + Math.random() * 9000);

        component.set('v.idNumber', randomNumber);
        component.set('v.isMobile', $A.get('$Browser.formFactor') === 'DESKTOP' ? false : false);
        component.set('v.isMobileTemp', $A.get('$Browser.formFactor') === 'DESKTOP' ? false : true);
    },
    handleDoneRendering: function(component,event,helper){

        var value = component.get('v.value');
        var alreadyRendered = component.get('v.alreadyRendered');

        if(!alreadyRendered){
            if(value){
                helper.handleValueOnInit(component, event, helper);
            }
        }
        component.set('v.alreadyRendered', true);

    },
    handleOnfocus: function(component, event, helper) {
        var isMobile = component.get('v.isMobile');

        event.stopPropagation();
        helper.openMenu(component);

        if (isMobile) {
            window.setTimeout($A.getCallback(function() {
                component.find('mobileInputField').getElement().focus();
            }), 1);
        }
    },
    handleOnclick: function(component, event, helper) {
        event.stopPropagation();
        helper.openMenu(component);
    },
    handleNotifyParent: function(component, event, helper) {

        helper.addToComponentValue(component, event, helper);
        helper.createOptionPill(component, event, helper);
        helper.removeOptionFromList(component, event, helper);
        helper.closeMenu(component);
        helper.clearInputValue(component);
        component.getEvent('onchange').fire();
    },
    handleComponentDestroyed: function(component, event, helper) {
    	
	    if(component.get('v.controlling')){
	    	var removeControlling = event.getParam('data').value;
	    	console.log('removeControlling-->'+removeControlling);
	    	component.getEvent("onKeyCountryRemove").setParams({"value" : removeControlling }).fire();
	    }
	    console.log('component.get(v.controlling)-->'+component.get('v.controlling'));
	    if(!component.get('v.controlling')){
	    	var removeControlling = event.getParam('data').value;
	    	console.log('removeCity-->'+removeControlling);
	    	component.getEvent("onKeyCityRemove").setParams({"value" : removeControlling }).fire();
	    }
        helper.removeOptionPill(component, event);
        helper.addOptionToList(component, event, helper);
        helper.removeFromComponentValue(component, event);
        component.set('v.scrollPosition', window.scrollY);
        helper.doSearch(component, event, helper, component.get('v.searchTerm'), component);
        component.getEvent('onchange').fire();
       
        
    },
    handleOnblur: function(component, event, helper) {
        var isMobile = component.get('v.isMobile');
        var eventSourceId = event.target.id;
        var mobileInputId = 'strike-multi-select-' + component.get('v.idNumber') + '--mobile';
        var shouldCloseMenu = ((isMobile && eventSourceId === mobileInputId) || !isMobile);

        if (shouldCloseMenu) {
            helper.closeMenu(component);
        }
    },
    handleOnkeyup: function(component, event, helper) {
        var KEYCODE_ENTER = 13;
        var KEYCODE_UP = 38;
        var KEYCODE_DOWN = 40;
        
        var isMobile = component.get('v.isMobile');
        var searchTerm;

        if (isMobile) {
            searchTerm = component.find('mobileInputField').getElement().value;
        } else {
            searchTerm = component.find('inputField').getElement().value;
        }

        var menuIsOpen = component.get('v.menuIsOpen');
        if(!menuIsOpen){component.set('v.menuIsOpen', true);}

        var keyCode = event.which || event.keyCode || 0;

        if (keyCode === KEYCODE_ENTER) {
            helper.updateValueByFocusIndex(component, event, helper);
            
        } else if (keyCode === KEYCODE_UP) {
            component.set('v.scrollPosition', window.scrollY);
            helper.moveRecordFocusUp(component, event, helper);

        } else if (keyCode === KEYCODE_DOWN) {
            component.set('v.scrollPosition', window.scrollY);
            helper.moveRecordFocusDown(component, event, helper);

        } else {
            helper.doSearch(component, event, helper, searchTerm, component);
        }
    },
    showError: function(component, event, helper) {
        var errorMessage = event.getParam('arguments').errorMessage;

        component.set('v.errorMessage', errorMessage);
        component.set('v.error', true);
    },
    hideError: function(component, event, helper) {
        component.set('v.errorMessage', null);
        component.set('v.error', false);
    },
    externalValueChange: function(component,event,helper){

        var externalValue = event.getParam('arguments').externalValue;
        component.set('v.value', externalValue);
console.log("111111");
        var inputField = component.find('inputField');
        inputField.getElement().value = '';

        if(externalValue || externalValue === ''){
            helper.handleValueOnInit(component,event,helper);
        }
    }
})