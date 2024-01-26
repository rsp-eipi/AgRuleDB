<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:doc="http://doc"
        queryBinding="xslt2">
    <ns uri="http://urn:gs1:gdsn:registry_catalogue_item:xsd:3"
        prefix="registry_catalogue_item"/>
    <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
       prefix="sh"/>
   <ns uri="http://data" prefix="data"/>
   <let name="units" value="doc('../data/data.xml')//data:units"/>
   <pattern>
      <title>Rule 74</title>
      <doc:description>If cancelDateTime is not empty then value must be greater than registrationDateTime</doc:description>
      <doc:attribute1>CatalogueItemDates/cancelDateTime</doc:attribute1>
      <doc:attribute2>CatalogueItemDates/registrationDateTime</doc:attribute2>
       <rule context="catalogueItemDates">
           <assert test="if((cancelDateTime) and (registrationDateTime)) then (cancelDateTime &gt; registrationDateTime)
           
           				 else true()">
           				 
           				 	
           				 				<errorMessage>Cancel DateTime must be after Registration DateTime</errorMessage>
         		
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
