window.readSettings =
function(jsonString)
{
 var obj = JSON.parse(jsonString);
 obj["newProperty"] = "stringProperty";
 
 return JSON.stringify(obj);
}
