<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:doc="http://doc"
        queryBinding="xslt2">
    <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3" prefix="catalogue_item_confirmation"/>
    <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" prefix="sh"/>
    <ns uri="http://data" prefix="data"/>
    <pattern>
        <title>Rule 1282</title>
        <doc:description>Transaction/documentCommand/documentCommandHeader/Type shall not be empty</doc:description>
        <doc:attribute1>documentCommandHeader</doc:attribute1>
        <rule context="transaction/documentCommand">
            <assert test="(exists(documentCommandHeader/@type)
                          and (every $node in (documentCommandHeader/@type) 
                          satisfies ($node != '')))">        
                          
                 					<errorMessage>Transaction/DocumentCommand/documentCommandHeader/Type shall not be empty</errorMessage> 
           	 	
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
