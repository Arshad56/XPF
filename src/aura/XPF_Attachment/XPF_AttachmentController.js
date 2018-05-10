({
    openSingleFile : function(component, event, helper) {
        helper.getFileList(component,helper);
    },
    previewFile: function(component, event, helper){
        //var id = event.getSource().get("v.name");
        var id = event.currentTarget.getAttribute("data-recId");
        var fireEvent = $A.get("e.lightning:openFiles");
        fireEvent.fire({
            recordIds: [id]
        }); 
        
    },
    handleUploadFinished : function(component, event, helper) {
        // Get the list of uploaded files
        var uploadedFiles = event.getParam("files");
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": "Success!",
            "message": "File "+uploadedFiles[0].name+" Uploaded successfully.",
            "type" :"Success"
        });
        toastEvent.fire();
        helper.getFileList(component,helper);
    }
})