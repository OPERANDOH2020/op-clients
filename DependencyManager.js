var DependencyManager = {
    dependencyRepository : [
        {
            name:"FeedbackProgress",
            path:"/operando/util/FeedbackProgress.js"
        },
        {
            name:"jQuery",
            path:"/operando/utils/jquery-2.1.4.min.js"
        }
    ],

    resolveDependency : function(dependency, resolve){
        var dependencyFound = false;
        for (var i = 0; i < this.dependencyRepository.length; i++) {
            if (this.dependencyRepository[i].name == dependency) {
                dependencyFound = true;
                break;
            }
        }

        if (dependencyFound == true) {
            resolve(this.dependencyRepository[i].path);
        }
        else {
            console.error("Could not load dependency ", dependency);
        }

}
}
