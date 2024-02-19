using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace AgRuleDB_Generated;
internal class Test
{

    public static string SampleXml = """
        <bib>
          <book>
            <title>TCP/IP Illustrated</title>
            <author>Stevens</author>
            <publisher>Addison-Wesley</publisher>
          </book>
          <book>
            <title>Advanced Programming in the Unix Environment</title>
            <author>Stevens</author>
            <publisher>Addison-Wesley</publisher>
          </book>
          <book>
            <title>Data on the Web</title>
            <author>Abiteboul</author>
            <author>Buneman</author>
            <author>Suciu</author>
          </book>
        </bib>
        """;

    public static string SampleQuery = """
        for $a in fn:distinct-values(book/author) return (book/author[. = $a][1], book[author = $a]/title)
        """;

    public static string SampleResult = """
        <author>Stevens</author> 
        <title>TCP/IP Illustrated</title>
        <title>Advanced Programming in the Unix environment</title>
        <author>Abiteboul</author>
        <title>Data on the Web</title>
        <author>Buneman</author>
        <title>Data on the Web</title>
        <author>Suciu</author>
        <title>Data on the Web</title>
        """;

}
