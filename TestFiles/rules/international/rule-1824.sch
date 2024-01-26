<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" 
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:doc="http://doc"
        queryBinding="xslt2">
   <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3"
       prefix="catalogue_item_confirmation"/>
   <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
       prefix="sh"/>
   <ns uri="http://data" prefix="data"/>
  
   <pattern>
      <title>Rule 1824</title>
	    <doc:description>If targetMarketCountryCode equals '250' (France) and bracketQualifier class is used, then bracketSequenceNumber shall be used.</doc:description>
        <doc:attribute1>targetMarketCountryCode,bracketQualifier</doc:attribute1>
        <doc:attribute2>bracketSequenceNumber</doc:attribute2>        
        <rule context="bracketQualifier">
            <assert test="if (ancestor::*:itemDepictionQualifier/catalogueItemReference/targetMarketCountryCode =  ('250'(: France :) )) 
            			  then  (exists(bracketSequenceNumber)
                          and (every $node in (bracketSequenceNumber)
                          satisfies ( $node != '') ))			 
            
		            			  else true()">
		            	 
		            	 	
								           	    <errorMessage>For Country Of Sale Code (France) and bracketQualifier is used, then Bracket Sequence Number shall be used.</errorMessage>
									                
								               <location>
												<!-- Fichier SDBH -->
												
												<glnProvider><xsl:value-of select="ancestor::*:priceSynchronisationDocument/informationProvider"/></glnProvider>
												<gtinHigh><xsl:value-of select="ancestor::*:itemDepictionQualifier/itemPriceType[1]/parentCatalogueItem/gtin"/></gtinHigh>
												<gtin><xsl:value-of select="ancestor::*:itemDepictionQualifier/catalogueItemReference/gtin"/></gtin>
												<targetMarket><xsl:value-of select="ancestor::*:itemDepictionQualifier/catalogueItemReference/targetMarketCountryCode"/></targetMarket>
												<incoterm><xsl:value-of select="ancestor::*:itemDepictionQualifier/itemPriceType[1]/referenceDocumentInformation[referenceDocumentIdentifier = 'incotermType']/referenceDocumentDescription"/></incoterm>
												<commercialCode><xsl:value-of select="ancestor::*:itemDepictionQualifier/itemPriceType[1]/referenceDocumentInformation[referenceDocumentIdentifier = 'commercialEventCode']/referenceDocumentDescription"/></commercialCode>
												<identification><xsl:value-of select="ancestor::*:itemPriceType[1]/itemPriceTypeSegmentation/entityIdentification"/></identification>
							                  </location>
						          		 		
          		 		
 		  </assert>
      </rule>
   </pattern>
</schema>
