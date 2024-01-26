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
   <let name="units" value="doc('../data/data.xml')//data:units"/>
   <pattern>
      <title>Rule 1565</title>
      <doc:description>If targetMarketCountryCode equals '249' (France), '250' (France) then, for each iteration of ItemDepictionQualifier, each iteration of ItemPriceType with priceTypeCode equal to 'ALLOWANCE' or 'CHARGE' shall have a unique priceTypeApplicationSequence.</doc:description>
      <doc:attribute1>targetMarketCountryCode,priceTypeCode</doc:attribute1>
      <doc:attribute2>priceTypeApplicationSequence</doc:attribute2>
      <rule context="itemDepictionQualifier">
          <assert test="if((targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) ))         									 					
        					and (exists (itemPriceType/priceTypeCode)
        					and (itemPriceType/priceTypeCode = ('ALLOWANCE' , 'CHARGE') ))) 
        					then ((count(itemPriceType/priceTypeApplicationSequence) 
                            eq count(distinct-values(count(itemPriceType/priceTypeApplicationSequence))) ))                 												
        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>If targetMarketCountryCode equals '249' (France), '250' (France) then for an ItemPricetype segment, in the same  ItemDepictionQualifier,
							      		 		              a different value (greater than '1') shall be used for priceTypeApplicationSequence to identify each allowance or charge.
	                                            </errorMessage>
							                
								                <location>
														<!-- Fichier SDBH -->
														<messageId><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier"/></messageId>
														<messageOwner><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier"/></messageOwner>
																			
														<transactionId><xsl:value-of select="ancestor::transaction/transactionIdentification/entityIdentification"/></transactionId>
														<transactionOwner><xsl:value-of select="ancestor::transaction/transactionIdentification/contentOwner/gln"/></transactionOwner>
														<commandId><xsl:value-of select="ancestor::documentCommand/documentCommandHeader/documentCommandIdentification/entityIdentification"/></commandId>
														<commandOwner><xsl:value-of select="ancestor::documentCommand/documentCommandHeader/documentCommandIdentification/contentOwner/gln"/></commandOwner>
														
														
												</location>
						          		 		
          		 		
 		  </assert>
      </rule>
   </pattern>
</schema>
