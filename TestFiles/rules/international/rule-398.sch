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
    <let name="gpc" value="doc('../data/data.xml')//data:gpc"/>
  <!-- defines contexts -->
    
  <pattern>
    <title>Rule 398</title>
    <doc:description>If gpcCategoryCode is not empty then its value must be in the Code List GPC Brick.</doc:description>
    <doc:attribute1>GDSNTradeItemClassification/gpcCategoryCode</doc:attribute1>
    <rule context="gdsnTradeItemClassification">
      <assert test="(every $node in (gpcCategoryCode) satisfies($node = $gpc/gpcGlobalList/gpcCode) )">
      
      		
      							<errorMessage>If populated, the GPC Category Code must be a valid GPC value that has been implemented in GDSN.</errorMessage>   
          	
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