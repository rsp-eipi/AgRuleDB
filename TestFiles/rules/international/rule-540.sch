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
        <title>Rule 540</title>
        <doc:description>If parent item platformTypeCode is equal to ('37',' 11'), and the child
            platformTypeCode is equal to ('30', '36' or '10') then quantityOfNextLowerLevelTradeItem
            of the parent item must not be greater than 2.</doc:description>
        <doc:attribute1>ChildTradeItem/quantityofNextLowerLevelTradeItem</doc:attribute1>
        <doc:attribute2>PlatformInformation/platformTypeCode</doc:attribute2>
        <rule context="catalogueItem">
            <assert
                test="
               		 if ((tradeItem/tradeItemInformation/extension/*:packagingInformationModule/packaging/platformTypeCode = ('37', '11')) and (catalogueItemChildItemLink/catalogueItem/tradeItem/tradeItemInformation/extension/*:packagingInformationModule/packaging/platformTypeCode = ('30', '36', '10')))then
              		 (tradeItem/nextLowerLevelTradeItemInformation/childTradeItem/quantityOfNextLowerLevelTradeItem &lt;= 2)
                
                   	 else true()">
                		
                				
                			   <errorMessage>Value in quantityofNextLowerLevelTradeItem may not exceed 2 when the pallet type is any type of full size pallet and the child item's pallet type is any type of half size pallet. Full size pallets are: EUR Pallet (code 37), ISO 1 Pallet (code 11)</errorMessage>
				           
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
											<gtin><xsl:value-of select="gtin"/></gtin>
											<glnProvider><xsl:value-of select="informationProviderOfTradeItem/gln"/></glnProvider>
											<targetMarket><xsl:value-of select="targetMarket/targetMarketCountryCode"/></targetMarket>	
											
							   </location>
                				
			</assert>
        </rule>
    </pattern>
</schema>
