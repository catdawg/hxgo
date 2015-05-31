package duell.build.plugin.library.hxgo;

typedef LibraryConfigurationData = {
    GO_SOURCES: Array<String>,
    GO_URLS: Array<String>,
}

class LibraryConfiguration
{
    private static var configuration: LibraryConfigurationData = null;
    private static var parsingDefines: Array<String> = ["hxgo"];

    public static function getData(): LibraryConfigurationData
    {
        if (configuration == null)
        {
            initConfig();
        }

        return configuration;
    }

    public static function getConfigParsingDefines(): Array<String>
    {
        return parsingDefines;
    }

    public static function addParsingDefine(str: String): Void
    {
        parsingDefines.push(str);
    }

    private static function initConfig(): Void
    {
        configuration =
        {
            GO_SOURCES : [],
            GO_URLS : [],

        };
    }
}
