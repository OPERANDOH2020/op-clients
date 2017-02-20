menuApp.service("menuLocatorService",function(){

    var location;
    var locationSet = false;

    return {
        setLocation : function(_location){

            if(locationSet === true){
                return new Error("locationAlreadySet");
            }
            else{
                location = _location;
                locationSet = true;
            }
        },
        getLocation:function(){
            return location;
        }
    }
});
