({
    onInit: function(component, event, helper) {
        component.handleClick = $A.getCallback(function() {
            if (!component.isValid()) {
                window.removeEventListener('click', component.handleClick);

                return;
            }

            helper.closeMenu(component, event, helper);
        });

        window.addEventListener('click', component.handleClick); 

        component.set('v.initCallsRunning', 2);

        helper.getRecentRecords(component, event, helper);
        helper.getRecordByValue(component, event, helper);

        var randomNumber = Math.floor(1000 + Math.random() * 9000);

        component.set('v.idNumber', randomNumber);

        component.set('v.isMobile', $A.get('$Browser.formFactor') === 'DESKTOP' ? false : true);
    },
    handleInputClick: function(component, event, helper) {
        event.stopPropagation();
    },
    handleSearchingClick: function(component, event, helper) {
        component.set('v.searching', false);
    },
    handleInputFocus: function(component, event, helper) {
        $A.util.addClass(component.find('lookup'), 'sl-lookup--open');

        if (component.get('v.disabled')) {
            return;
        }

        helper.getRecordsBySearchTerm(component, event, helper);
    },
    cancelLookup: function(component, event, helper) {
        helper.closeMobileLookup(component, event, helper);
    },
    handleInputKeyDown: function(component, event, helper) {
        if (component.get('v.disabled')) {
            return;
        }

        var KEYCODE_TAB = 9;

        var keyCode = event.which || event.keyCode || 0;

        if (keyCode === KEYCODE_TAB) {
            helper.closeMenu(component, event, helper);
        }
    },
    handleInputKeyPress: function(component, event, helper) {
        if (component.get('v.disabled')) {
            return;
        }
    },
    handleInputKeyUp: function(component, event, helper) {
        if (component.get('v.disabled')) {
            return;
        }

        var KEYCODE_ENTER = 13;
        var KEYCODE_UP = 38;
        var KEYCODE_DOWN = 40;

        var keyCode = event.which || event.keyCode || 0;

        if (keyCode === KEYCODE_ENTER) {
            helper.updateValueByFocusIndex(component, event, helper);
        } else if (keyCode === KEYCODE_UP) {
            helper.moveRecordFocusUp(component, event, helper);
        } else if (keyCode === KEYCODE_DOWN) {
            helper.moveRecordFocusDown(component, event, helper);
        } else {
            
            helper.getRecordsBySearchTerm(component, event, helper);
        }
    },
    handleRecordClick: function(component, event, helper) {
        event.preventDefault();
        event.stopPropagation();

        var focusIndex = event.currentTarget.dataset.index;

        component.set('v.focusIndex', focusIndex);

        helper.updateValueByFocusIndex(component, event, helper);
    },
    handleNewRecordClick: function(component, event, helper) {
        event.preventDefault();
        event.stopPropagation();

        helper.addNewRecord(component, event, helper);
    },
    handleFocusIndexChange: function(component, event, helper) {
        var focusIndex = component.get('v.focusIndex');
        var lookupMenu = component.find('lookupMenu').getElement();
        var options = lookupMenu.getElementsByTagName('li');
        var focusScrollTop = 0;
        var focusScrollBottom = 0;

        for (var i = 0; i < options.length; i++) {
            var optionSpan = options[i].getElementsByTagName('span')[0];

            if (i === focusIndex) {
                $A.util.addClass(optionSpan, 'slds-has-focus');
            } else {
                if (i < focusIndex) {
                    focusScrollTop += options[i].scrollHeight;
                }

                $A.util.removeClass(optionSpan, 'slds-has-focus');
            }
        }

        if (focusIndex !== null) {
            focusScrollBottom = focusScrollTop + options[focusIndex].scrollHeight;
        }

        if (focusScrollTop < lookupMenu.scrollTop) {
            lookupMenu.scrollTop = focusScrollTop;
        } else if (focusScrollBottom > lookupMenu.scrollTop + lookupMenu.clientHeight) {
            lookupMenu.scrollTop = focusScrollBottom - lookupMenu.clientHeight;
        }
    },
    handleValueChange: function(component, event, helper) {
        var value = component.get('v.value');
        var internalValue = component.get('v.internalValue');

        if ($A.util.isEmpty(value)) {
            var tiles = component.find('tiles');

            component.set('v.valueLabel', '');
            if(!$A.util.isEmpty(tiles)){
                if(!Array.isArray(tiles)){
                    tiles = [tiles];
                }

                tiles.forEach(function(tile){
                    tile.destroyTile();
                });
            }
        } else if(value !== internalValue){
            helper.getRecordByValue(component, event, helper);
        }
    },
    handleFilterChange: function(component, event, helper) {
        component.set('v.initCallsRunning', 2);

        helper.getRecordByValue(component, event, helper);
        helper.getRecentRecords(component, event, helper);

        component.find('lookupInput').getElement().value = '';
        helper.getRecordsBySearchTerm(component, event, helper);
        component.set('v.value', '');
    },
    handleLimitChange: function(component, event, helper) {
        component.find('lookupInput').getElement().value = '';
        helper.getRecordsBySearchTerm(component, event, helper);
    },
    handleObjectChange: function(component, event, helper) {
        component.set('v.initCallsRunning', 2);

        helper.getRecentRecords(component, event, helper);
        helper.getRecordByValue(component, event, helper);

        component.find('lookupInput').getElement().value = '';

        helper.getRecordsBySearchTerm(component, event, helper);
        component.set('v.value', '');
    },
    handleOrderChange: function(component, event, helper) {
        component.set('v.initCallsRunning', 1);

        helper.getRecentRecords(component, event, helper);

        component.find('lookupInput').getElement().value = '';
        helper.getRecordsBySearchTerm(component, event, helper);
    },
    handleSearchfieldChange: function(component, event, helper) {
        component.set('v.initCallsRunning', 2);

        helper.getRecentRecords(component, event, helper);
        helper.getRecordByValue(component, event, helper);

        component.find('lookupInput').getElement().value = '';
        helper.getRecordsBySearchTerm(component, event, helper);
    },
    handleSubtitlefieldChange: function(component, event, helper) {
        component.set('v.initCallsRunning', 1);

        helper.getRecentRecords(component, event, helper);

        component.find('lookupInput').getElement().value = '';
        helper.getRecordsBySearchTerm(component, event, helper);
    },
    handleComponentDestroyed: function(component, event, helper){
        var sourceCmpValue = event.getSource().get('v.value');
        if (sourceCmpValue){
            helper.removeOptionTile(component, event, sourceCmpValue);
            helper.removeFromComponentValue(component, event, sourceCmpValue);
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
    }
})