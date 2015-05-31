package duell.build.plugin.library.hxgo;

import duell.objects.DuellLib;
import duell.helpers.TemplateHelper;
import duell.helpers.CommandHelper;
import duell.objects.DuellProcess;
import duell.helpers.LogHelper;
import duell.build.objects.Configuration;
import haxe.io.Path;
import sys.FileSystem;
import sys.io.File;

using duell.helpers.HashHelper;

class LibraryBuild
{
    private var haxeCompilePath: String;
    private var hashPath: String;
    public function new()
    {
    }


    public function postParse(): Void
    {
        hashPath = Path.join([Configuration.getData().OUTPUT, "hxgo", "cache.hash"]);

		/// if no parsing is made we need to add the default state.
		if (Configuration.getData().LIBRARY.HXGO == null)
		{
			Configuration.getData().LIBRARY.HXGO = LibraryConfiguration.getData();
		}

		haxeCompilePath = Path.join([Configuration.getData().OUTPUT,"hxgo"]);
		if (Configuration.getData().SOURCES.indexOf(haxeCompilePath) == -1)
		{
			Configuration.getData().SOURCES.push(haxeCompilePath);
		}

		var currentHash = generateCurrentHash();

		var previousHash = getCachedHash();

        if (currentHash != previousHash)
        {
            Sys.putEnv("GOPATH",
                    Path.join([Configuration.getData().OUTPUT,"hxgo", "lib"])
                    );

            Sys.putEnv("GOROOT", Path.join([DuellLib.getDuellLib("hxgo").getPath(), "bin", "go"]));

            downloadDependencies();

            copyCompileGOFile();

            tardisGO();
        }

        saveHash(currentHash);
    }

    public function preBuild(): Void
    {

    }

    public function postBuild(): Void
    {}

	private function copyCompileGOFile() : Void
	{
        var libPath : String = DuellLib.getDuellLib("hxgo").getPath();

        var exportPath : String = Path.join([Configuration.getData().OUTPUT, "hxgo"]);

        var classSourcePath : String = Path.join([libPath,"template"]);

        TemplateHelper.recursiveCopyTemplatedFiles(classSourcePath, exportPath, Configuration.getData(), Configuration.getData().TEMPLATE_FUNCTIONS);
	}

    private function downloadDependencies(): Void
    {
        installLib("golang.org/x/tools/go");

        installLib("github.com/tardisgo/tardisgo");

        for (value in LibraryConfiguration.getData().GO_URLS)
        {
            installLib(value);
        }
    }

    private function installLib(url: String): Void
    {
        LogHelper.info("[HXGO] installing " + url);
        var proc = new DuellProcess(Path.join([DuellLib.getDuellLib("hxgo").getPath(),
                                   "bin", "go", "bin"]), "go",
                                 ["get", "-u", url],
                                 {
                                     systemCommand: false,
                                     block: true,
                                     shutdownOnError: false
                                 });

        var validExitCodes = [0, 1];
        if (validExitCodes.indexOf(proc.exitCode()) == -1)
        {
            throw "Error installing go dependency " + "exitCode:" + proc.exitCode();
        }
    }

    private function generateCurrentHash(): Int
	{
		var arrayOfHashes = [];
		for(folder in LibraryConfiguration.getData().GO_SOURCES)
		{
			arrayOfHashes.push(folder.getFnv32IntFromString());
		}

		return arrayOfHashes.getFnv32IntFromIntArray();
	}

	private function getCachedHash(): Int
	{
		if (FileSystem.exists(hashPath))
		{
            var hash: String = File.getContent(hashPath);

            return Std.parseInt(hash);
		}
		return 0;
	}

	private function saveHash(hash: Int): Void
	{
        if (FileSystem.exists(hashPath))
        {
            FileSystem.deleteFile(hashPath);
        }

        File.saveContent(hashPath, Std.string(hash));
	}

    private function tardisGO()
    {
        LogHelper.info("Running tardis...");
        CommandHelper.runCommand(Path.join([Configuration.getData().OUTPUT, "hxgo"]),
                                 Path.join([Configuration.getData().OUTPUT,
                                                            "hxgo", "lib", "bin", "tardisgo"]),
                                 ["compile.go"]);
    }
}
