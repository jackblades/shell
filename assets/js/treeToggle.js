function toggle(e) {
    var node = e.srcElement == undefined ? e.target : e.srcElement;
    var id = node.getAttribute("id");
    var children = document.getElementById("children_" + id),
        cstyle = window.getComputedStyle(children),
        cdispay = cstyle.getPropertyValue("display");
    if (cdispay == "inline") {
        document.getElementById("children_" + id).className = "hidden";
        document.getElementById(id).className = "node interactive collapsed";
    } else {
        document.getElementById("children_" + id).className = "shown";
        document.getElementById(id).className = "node interactive expanded";
    }
}