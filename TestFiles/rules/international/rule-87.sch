<?xml version="1.0" encoding="UTF-8"?>
  <schema xmlns="http://purl.oclc.org/dsdl/schematron"
  		  xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
          xmlns:doc="http://doc"
          queryBinding="xslt2">
    <ns uri="urn:gs1:gdsn:catalogue_item_subscription:xsd:3"
      prefix="catalogue_item_subscription"/>
    <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
      prefix="sh"/>
    <ns uri="http://data" prefix="data"/>
    <let name="units" value="doc('../data/data.xml')//data:units"/> 
  <!-- defines contexts -->
    
  <pattern>
    <title>Rule 87</title>
    <doc:description>If gtin is not empty then gpcCategoryCode must be empty.</doc:description>
    <doc:attribute1>CatalogueItemSubscription/gtin</doc:attribute1>
    <doc:attribute2>CatalogueItemSubscription/gpcCategoryCode</doc:attribute2>
    <rule context="*:catalogueItemSubscription">
	      <assert test="if(gtin) then (every $node in (gpcCategoryCode) satisfies ((empty($node))))
	      
	      				else true()">
	      				
	      					
	      								<errorMessage>Category code and gtin cannot be an input together</errorMessage>
         		
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