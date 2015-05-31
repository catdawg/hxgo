package main

import (

::foreach LIBRARY.HXGO.GO_SOURCES::
	_ "::__current__::"
::end::
)

const tardisgoLibList = "::foreach LIBRARY.HXGO.GO_SOURCES::::__current__::::if (__index__<(LIBRARY.HXGO.GO_SOURCES.length-1))::,::end::::end::";

func main() {}
