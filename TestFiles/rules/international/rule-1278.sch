<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" 
        xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:doc="http://doc"
        queryBinding="xslt2">
    <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3" prefix="catalogue_item_confirmation"/>
    <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" prefix="sh"/>
    <ns uri="http://data" prefix="data"/>
    <pattern>
        <title>Rule 1278</title>
        <doc:description>If tradeItemUnitDescriptorCode is equal to 'MIXED_MODULE' then child item tradeItemUnitDescriptorCode must not equal 'TRANSPORT_LOAD'.</doc:description>
        <doc:attribute1>TradeItem/TradeItemUnitDescriptorCode</doc:attribute1>
        <rule context="catalogueItem">
            <assert test="if (tradeItem/tradeItemUnitDescriptorCode= 'MIXED_MODULE')
                          then (every $node in (catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemUnitDescriptorCode) 
                          satisfies($node != 'TRANSPORT_LOAD')) 
                          
                          	else true()">
                          	
                          				
               						 
               						<errorMessage> If tradeItemUnitDescriptorCode is equal to 'MIXED_MODULE'
               						               then child item tradeItemUnitDescriptorCode must not equal 'TRANSPORT_LOAD' .
				             	    </errorMessage> 
           	 	
					           	 	<location>
													<!-- Fichier SDBH -->
													<messageId><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier"/></messageId>
													<messageOwner><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier"/></messageOwner>
																		
													<transactionId><xsl:value-of select="ancestor::transaction/transactionIdentification/entityIdentification"/></transactionId>
													<transactionOwner><xsl:value-of select="ancestor::transaction/transactionIdentification/contentOwner/gln"/></transactionOwner>
													<commandId><xsl:value-of select="ancestor::documentCommand/documentCommandHeader/documentCommandIdentification/entityIdentification"/></commandId>
													<commandOwner><xsl:value-of select="ancestor::documentCommand/documentCommandHeader/documentCommandIdentification/contentOwner/gln"/></commandOwner>
													<!-- Fichier CIN -->
													<documentId><xsl:value-of select="ancestor::*:catalogueItemNotification/catalogueItemNotificationIdentification/entityIdentification"/></documentId>
													<documentOwner><xsl:value-of select="ancestor::*:catalogueItemNotification/catalogueItemNotificationIdentification/contentOwner/gln"/></documentOwner>
													<gtinHigh><xsl:value-of select="ancestor::*:catalogueItemNotification/catalogueItem/tradeItem/gtin"/></gtinHigh>
													<!-- Context = TradeItem -->
													<gtin><xsl:value-of select="tradeItem/gtin"/></gtin>
													<glnProvider><xsl:value-of select="tradeItem/informationProviderOfTradeItem/gln"/></glnProvider>
													<targetMarket><xsl:value-of select="tradeItem/targetMarket/targetMarketCountryCode"/></targetMarket>	
													
								  	 </location>    
		    </assert>
        </rule>
    </pattern>
</schema>
