//displays a document in an extra window (for agbs, legal-notices etc.)
function showDoc(htmlfile, width, height) {

	dummy = open(htmlfile, "","dependent=yes,scrollbars=yes,toolbar=0,location=0,status=0,menubar=0,height=" + height + ",width=" + width + "");
}

