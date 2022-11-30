({
    openTab : function(component, event, helper) {
        var workspaceAPI = component.find("workspace");

        workspaceAPI.openTab({
            recordId: component.get("v.contactId"),
            focus: true
        }).then(function(response) {
            workspaceAPI.getTabInfo({
                  tabId: response
            }).then(function(tabInfo) {
            console.log("The url for this tab is: " + tabInfo.url);
            });
        })
        .catch(function(error) {
               console.log(error);
        });
    },

    defineRunningUser : function(component, event, helper) {
        var runningUserId = $A.get("$SObjectType.CurrentUser.Id");
        return runningUserId;
    },
    
    openCreateContactTab : function(cmp, event, helper) {
        var navService = cmp.find("navService");
        var pageRef = {
            type: "standard__objectPage",
            attributes: {
                objectApiName: "Contact",
                actionName: "new"
            },
            state: {
            }
        }

        // Replace with your own field values
        var defaultFieldValues = {
            Phone: cmp.get("v.phoneNumber"),
            Is_Contact_Creating_By_Hook__c: true,
        };
        pageRef.state.defaultFieldValues = cmp.find("pageRefUtils").encodeDefaultFieldValues(defaultFieldValues);
        cmp.set("v.pageReference", pageRef);
        var defaultUrl = "#";

        // Generate a Link for the Aura Link example
        navService.generateUrl(pageRef)
        .then($A.getCallback(function(url) {
            cmp.set("v.url", url ? url : defaultUrl);
            navService.navigate(pageRef);
        }), $A.getCallback(function(error) {
            cmp.set("v.url", defaultUrl);
        }));
    }
})
