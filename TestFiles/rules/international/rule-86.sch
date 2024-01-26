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
    <title>Rule 86</title>
    <doc:description>There must be at least one iteration of gtin, targetMarket gpcCategoryCode or dataSource/gln.</doc:description>
    <doc:attribute1>CatalogueItemSubscription/gtin</doc:attribute1>
    <doc:attribute2>CatalogueItemSubscription/gpcCategoryCode</doc:attribute2>
    <doc:attribute3>CatalogueItemSubscription/targetMarketCountryCode</doc:attribute3>
    <doc:attribute4>dataSource</doc:attribute4>
    <rule context="*:catalogueItemSubscription">
	      <assert test="(exists(gtin) or exists(gpcCategoryCode) or exists(targetMarket/targetMarketCountryCode) or exists(dataSource))">
	      
	      					
	      								<errorMessage>Data Recipient needs to provide at least one key attribute (GTIN, Category, Target Market or Data Source GLN)</errorMessage>
         		
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