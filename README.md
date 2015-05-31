# hxgo
A duell environment library for using Go libraries in Haxe. Uses the https://github.com/tardisgo/tardisgo transpiler to compile from Go to Haxe.

# Usage
Add the dependency:

	<duelllib name="hxgo" version="0.0.0+" />

Configure the go sources you want to compile to Haxe, example:

	<library-config>
		<hxgo>
			<go-src value="math" />
			<go-src value="strconv"/>
		</hxgo>
	</library-config>
	
Use it! example:
```

  import tardis.*;
  class Main
  {
    public static function main()
    {
        Go_math_NNextafter.hx(2.0,3.0);
    }
  }
  
```

