package duell.build.plugin.library.hxgo;

import duell.build.objects.DuellProjectXML;
import duell.build.objects.Configuration;

import duell.build.plugin.library.hxgo.LibraryConfiguration;

import duell.helpers.XMLHelper;

import haxe.xml.Fast;

class LibraryXMLParser
{
    public static function parse(xml: Fast): Void
    {
        Configuration.getData().LIBRARY.HXGO = LibraryConfiguration.getData();

        for (element in xml.elements)
        {
            if (!XMLHelper.isValidElement(element, DuellProjectXML.getConfig().parsingConditions))
                continue;

            switch(element.name)
            {
                case 'go-src':
                    parseGoSrc(element);
            }
        }
    }

    private static function parseGoSrc(element: Fast): Void
    {
        if (element.has.value)
        {
            LibraryConfiguration.getData().GO_SOURCES.push(element.att.value);

            if (element.has.url)
            {
                LibraryConfiguration.getData().GO_URLS.push(element.att.url);
            }
        }
    }

	private static function resolvePath(string : String) : String /// convenience method
	{
		return DuellProjectXML.getConfig().resolvePath(string);
	}
}
