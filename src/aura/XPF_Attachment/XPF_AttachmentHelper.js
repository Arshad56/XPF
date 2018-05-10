({
  
    getFileList: function(component,helper){
        var action = component.get("c.getContentDocs");
        action.setParams({
            "xpfFileId": component.get("v.recordId")
        });
        action.setCallback(this,function(response){
            var state = response.getState();
            if(state == "SUCCESS") {
                helper.currentUser(component, event);
                helper.applyFileTypeIconNames( component, response.getReturnValue());
                component.set("v.ContentVersions", response.getReturnValue());
            }
        });
         $A.enqueueAction(action);
    },
    currentUser: function(component, event){
        var action = component.get("c.getUser");
        action.setParams({
            recordId: component.get("v.recordId"),
        });
        action.setCallback(this,function(response){
            if(response.getState()==='SUCCESS'){
            	var canUpload = response.getReturnValue();
            	console.log('canUpload-->'+canUpload);
        		component.set("v.canUpload",response.getReturnValue());
            }
        });
        $A.enqueueAction(action);                
        
    },
 
    applyFileTypeIconNames : function( component, files ) {
         console.log(files);
        for ( var i = 0; i < files.length; i++ ) {

            var iconName = 'doctype:attachment';
            var file = files[i];

            if ( /^POWER_POINT/i.test( file.FileType ) ) {
                iconName = 'doctype:ppt';
            }
            else if ( /^EXCEL/i.test( file.FileType ) ) {
                iconName = 'doctype:excel';
            }
            else if ( /^WORD/i.test( file.FileType ) ) {
                iconName = 'doctype:word';
            }
            else if ( /^(MP3|WAV|M4A)/i.test( file.FileType ) ) {
                iconName = 'doctype:audio';
            }
            else if ( /^MP4/i.test( file.FileType ) ) {
                iconName = 'doctype:mp4';
            }
            else if ( /^CSV/i.test( file.FileType ) ) {
                iconName = 'doctype:csv';
            }
            else if ( /^TEXT/i.test( file.FileType ) ) {
                iconName = 'doctype:txt';
            }
            else if ( /^PDF/i.test( file.FileType ) ) {
                iconName = 'doctype:pdf';
            }
            else if ( /^XML/i.test( file.FileType ) ) {
                iconName = 'doctype:xml';
            }
            else if ( /^ZIP/i.test( file.FileType ) ) {
                iconName = 'doctype:zip';
            }
            else if ( /^(PNG|GIF|JPG|JPEG|TIFF|BMP)/i.test( file.FileType ) ) {
                iconName = 'doctype:image';
            }
            else if ( /^PACK/i.test( file.FileType ) ) {
                iconName = 'doctype:pack';
            }
            else if ( /^(MOV|WMV|M4V)/i.test( file.FileType ) ) {
                iconName = 'doctype:movie';
            }
            else if ( /^LINK/i.test( file.FileType ) ) {
                iconName = 'doctype:link';
            }
            else if ( /^HTML/i.test( file.FileType ) ) {
                iconName = 'doctype:html';
            }
            else if ( /^SNOTE/i.test( file.FileType ) ) {
                iconName = 'doctype:stypi';
            }

            file.FileTypeIconName = iconName;
            console.log(iconName);

        }

    }
   
})