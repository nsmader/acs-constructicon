# Executes all registration functions package is attached
.onAttach <- function(libname, pkgname) {
    known_constrs <- methods("register")
    known_constrs <- sapply(strsplit(known_constrs, "\\."), function(x) x[2])
    if (length(known_constrs) > 0) {
        packageStartupMessage("Behold, ACS Constructicons!")
        for (cid in seq_along(known_constrs)) {
            name <- known_constrs[cid]
            packageStartupMessage(cid, ".\t", name)

            tmp <- structure(list(), class = name)
            register(tmp)
        }
    }
}

register <- function(obj) {
    UseMethod("register")
}
