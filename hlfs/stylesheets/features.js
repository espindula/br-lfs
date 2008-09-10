/* Retrieves array of all features stored in `features' cookie,
 * where they are delimited by coma.
 */
function getFeatures ()
{
	var cks = document.cookie.split(";");
	for (i = 0; i < cks.length; i++) {
		ck = cks[i].split("=");
		if ("features" == ck[0])
			return ck[1].split(",");
	}
	return null;
}

/* Sets features list cookie.
 */
function setFeatures (ftrs)
{
	if ("string" != typeof(ftrs))
		ftrs = ftrs.join(",");
	/* Always set cookie to something, or we will erase it, which is
	 * not what we want as that will display everything instead of nothing.
	 */
	if ("" == ftrs)
		ftrs = "!";
	document.cookie = "features=" + ftrs;
}

/* Works like document.getElementsByTagName() except it accepts more
 * tag names either as an array or coma-separated list and return type
 * is not a collection, but an array.
 */
document.getElementsByTagNames = function (names)
{
	var res = new Array();
	var q;

	if ("string" == typeof(names))
		names = names.split(",");

	for (i = 0; i < names.length; i++) {
		if (! (q = document.getElementsByTagName(names[i])))
			continue;
		for (j = 0; j < q.length; j++)
			res.push(q[j]);
	}

	return res;
}

/* Removes <p> and <pre> tags that does not have
 * feature-<one of ftrs> in their class list.
 */
function initFeatures ()
{
	var ps = document.getElementsByTagNames("p,pre");
	var ftrs = getFeatures();
	var ftred;

	/* no selection made => no hiding */
	if (null == ftrs)
		return;

	for (i = 0; i < ps.length; i++ ) {
		if (! ps[i].className)
			continue;

		if (! ps[i].className.match(/(^| )feature-/))
			continue;

		ftred = false;
		for (j = 0; j < ftrs.length; j++)
			if (ps[i].className.match(
			    "(^| )feature-" + ftrs[j] + "( |$)"))
				ftred = true;

		if (! ftred)
			ps[i].style.display = "none";
	}
}

/* Composes cookie to be set by setFeatures() using value collected
 * from given `form'. Once set, redirects to selected book.
 */
function featuresSetup (form)
{
	var enable = new Array();

	/* set configuration */
	var ins = form.getElementsByTagName("input");
	for (i = 0; i < ins.length; i++)
		if ("checkbox" == ins[i].type && ins[i].checked)
			enable.push(ins[i].value);

	setFeatures(enable);

	/* find out desired book variant */
	var libc = (document.getElementById("glibc").checked
			? "glibc"
			: "uclibc");
	var kernel = (document.getElementById("kernel_26").checked
			? "2.6"
			: "2.4");

	window.open(libc + "-" + kernel + "/index.html", "_self");

	return false;
}

/* Sets form's checkboxes according to features
 * cookie, if it is present.
 */
function featuresRestoreForm (form)
{
	if ("string" == typeof(form))
		form = document.getElementById(form);
	var ins = form.getElementsByTagName("input");
	var ftrs = getFeatures();
	if (null != ftrs)
		for (i = 0; i < ins.length; i++) {
			if ("checkbox" != ins[i].type)
				continue;
			ins[i].checked = false;
			for (j = 0; j < ftrs.length; j++)
				if (ins[i].value == ftrs[j])
					ins[i].checked = true;
		}
}

initFeatures();
