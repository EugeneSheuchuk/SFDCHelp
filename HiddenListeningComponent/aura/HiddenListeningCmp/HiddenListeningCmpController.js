({
    doInit: function (component, event, helper) {
        // Add a listener to open a contact only on the active tab
        if (!window.visibilityChangeListener) { 
            window.visibilityChangeListener = true;
            document.addEventListener('visibilitychange', function (event) {
                if (document.hidden) {
                    component.set("v.isTabActive", false);
                } else {
                    component.set("v.isTabActive", true);
                }
            });
        }
        
        // Get the empApi component
        const empApi = component.find('empApi');
        const channel = '/event/Mustalinja_Event__e';
        const replayId = -1;

        const callback = function (message) {
            var isTabActive = component.get("v.isTabActive");
            console.log('isTabActive ', isTabActive);
            if (isTabActive) { 
                var obj = message.data.payload;
                console.log('obj', JSON.stringify(obj));
                component.set("v.userId", obj.userId__c);
                component.set("v.contactId", obj.contactId__c);
                component.set("v.phoneNumber", obj.fromNumber__c);
                console.log('obj toiseen kertaan', JSON.stringify(obj));
            
                const runningUserId = helper.defineRunningUser(component, event, helper).toString();
                const allowedUserId = component.get("v.userId");
                console.log('runningUserId', runningUserId);
                console.log('allowedUserId', allowedUserId);
                
                if (runningUserId === allowedUserId) {
                    //fire toast message
                    var toastEvent = $A.get("e.force:showToast");
                    toastEvent.setParams({
                        "mode" : 'dismissible',
                        "title" : "Success",
                        "message" : "Success",
                        "type" : "success",
                        "duration" : "3000"
                    });
                    toastEvent.fire();
                    if (component.get("v.contactId") != 'Unknown') {
                        helper.openTab(component, event, helper);
                    } else {
                        helper.openCreateContactTab(component, event, helper);
                    }
                } else {
                    console.log('ERROR...');
                }
            }            
        };

        // Subscribe to an event
        empApi.subscribe(channel, replayId, callback).then(function(newSubscription) {
            console.log("Subscribed to channel" + channel);
        }) 
    }
})