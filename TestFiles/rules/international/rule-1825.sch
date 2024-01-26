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
      <title>Rule 1825</title>
	    <doc:description>If targetMarketCountryCode equals '250' (France) and bracketSequenceNumber is used then bracketSequenceNumber shall be unique for each bracketQualifier class within the same ItemPriceType class.</doc:description>
        <doc:attribute1>targetMarketCountryCode,bracketSequenceNumber</doc:attribute1>
        <doc:attribute2>bracketSequenceNumber</doc:attribute2>        
        <rule context="itemPriceType">
            <assert test="if (ancestor::*:itemDepictionQualifier/catalogueItemReference/targetMarketCountryCode =  ('250'(: France :) )
                          and (exists(bracketQualifier/bracketSequenceNumber) )) 
            			  then  ( count(bracketQualifier/bracketSequenceNumber) eq count(distinct-values(bracketQualifier/bracketSequenceNumber)) )
            			  
		            			  else true()">
		            	 
		            	 	
								           	    <errorMessage>For Country Of Sale Code (France), Bracket Sequence Number shall be unique within the same item price type class.</errorMessage>
									                
								                <location>
													<!-- Fichier SDBH -->
													
													<glnProvider><xsl:value-of select="ancestor::*:priceSynchronisationDocument/informationProvider"/></glnProvider>
													<gtinHigh><xsl:value-of select="parentCatalogueItem/gtin"/></gtinHigh>
													<gtin><xsl:value-of select="ancestor::*:itemDepictionQualifier/catalogueItemReference/gtin"/></gtin>
													<targetMarket><xsl:value-of select="ancestor::*:itemDepictionQualifier/catalogueItemReference/targetMarketCountryCode"/></targetMarket>
													<incoterm><xsl:value-of select="ancestor::*:itemDepictionQualifier/itemPriceType[1]/referenceDocumentInformation[referenceDocumentIdentifier = 'incotermType']/referenceDocumentDescription"/></incoterm>
													<commercialCode><xsl:value-of select="ancestor::*:itemDepictionQualifier/itemPriceType[1]/referenceDocumentInformation[referenceDocumentIdentifier = 'commercialEventCode']/referenceDocumentDescription"/></commercialCode>
													<identification><xsl:value-of select="itemPriceTypeSegmentation/entityIdentification"/></identification>
								                </location>
						          		 		
          		 		
 		  </assert>
      </rule>
   </pattern>
</schema>
