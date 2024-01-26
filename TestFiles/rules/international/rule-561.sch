<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform" 
		xmlns:doc="http://doc" 
		queryBinding="xslt2">
    <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3" prefix="catalogue_item_confirmation"/>
    <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" prefix="sh"/>
    <ns uri="http://data" prefix="data"/>
    <let name="units" value="doc('../data/data.xml')//data:units"/>
    <let name="gpc" value="doc('../data/data.xml')//data:gpc"/>
    <pattern>
        <title>Rule 561</title>
        <doc:description>If tradeItemUnitDescriptorCode is equal to 'PACK_OR_INNERPACK' then child item tradeItemUnitDescriptorCode must not equal 'TRANSPORT_LOAD', 'PALLET' or 'CASE'.</doc:description>
        <doc:attribute1>TradeItem/TradeItemUnitDescriptorCode</doc:attribute1>
        <rule context="catalogueItem">
            <assert test=" if (tradeItem/tradeItemUnitDescriptorCode= 'PACK_OR_INNERPACK') then (every $node in (catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemUnitDescriptorCode) satisfies ($node!='TRANSPORT_LOAD' and $node!='PALLET' and $node!= 'CASE')) 
            
            			   else true()">
            			   
             					    
             					    <errorMessage>If tradeItemUnitDescriptor is 'PACK_OR_INNERPACK', and the item has (a) child(ren), then the tradeItemUnitDescriptorCode of the children can never be 'TRANSPORT_LOAD', 'PALLET' or 'CASE'.</errorMessage> 
           	 	
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
													<!--  Le 1er tradeItem . 1 seul car les autres sont imbriqués -->
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
