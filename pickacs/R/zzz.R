.onAttach <- function(libname, pkgname) {
    known_constrs <- methods("register")
    known_constrs <- sapply(strsplit(known_constrs, "\\."), function(x) x[2])
    if (length(known_constrs) > 0) {
        for (cid in seq_along(known_constrs)) {
            name <- known_constrs[cid]
            tmp <- structure(list(), class = name)
            register(tmp)

        }

        packageStartupMessage("Behold, ACS Constructicons!")
        loaded_constrs <- get("lookups", envir = constr_env)
        for (cid in seq_along(loaded_constrs)) {
            full_name <- loaded_constrs[cid]
            packageStartupMessage(cid, ".\t", full_name)
        }
    }
}
