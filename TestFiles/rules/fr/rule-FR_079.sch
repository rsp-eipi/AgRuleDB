<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" xmlns:doc="http://doc" queryBinding="xslt2">
    <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3" prefix="catalogue_item_confirmation"/>
    <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" prefix="sh"/>
    <ns uri="http://data" prefix="data"/>
    <let name="units" value="doc('../data/data.xml')//data:units"/>
    <let name="standardCodes" value="doc('../data/data.xml')//data:standardCodes"/>
    <pattern>
        <title>Rule FR_079</title>
        <doc:description>If isTradeItemADespatchUnit = 'true' and platformTypeCode refers to a standardized pallet platform (10, 11, 12, 13, 14, 15, 16, 18, 19, 20, 21, 25, X9, 47) then its width and depth must be greater or equal the platform's width and depth.</doc:description>
        <doc:attribute1>/targetMarket[1]/targetMarketCountryCode[1]</doc:attribute1>
        <doc:attribute2>platformTypeCode, width, depth</doc:attribute2>
        <rule context="tradeItem">
            <assert test="
                if ((targetMarket/targetMarketCountryCode = ('249' (: France :), '250' (: France :)))
                and (gdsnTradeItemClassification/gpcCategoryCode!='10005844')
                and (gdsnTradeItemClassification/gpcCategoryCode!='10005845') 
                and(isTradeItemADespatchUnit = 'true'))
                then (every $node in (tradeItemInformation/extension) 
                satisfies(if(($node/*:packagingInformationModule/packaging/platformTypeCode = ('10', '11', '12', '13', '14', '15', '16', '18', '19', '20', '21', '25', 'X9', '47'))
                and ($node/*:tradeItemMeasurementsModule/tradeItemMeasurements/depth)
                and ($node/*:tradeItemMeasurementsModule/tradeItemMeasurements/width)) 
                then((($node/*:tradeItemMeasurementsModule/tradeItemMeasurements/width * $units/unit[@code = 
                current()/$node/*:tradeItemMeasurementsModule/tradeItemMeasurements/width/@measurementUnitCode]/@coef) &gt;=
                number($standardCodes/platformTypeCode[@code= current()/$node/*:packagingInformationModule/packaging/platformTypeCode]/@width)) 
                and (($node/*:tradeItemMeasurementsModule/tradeItemMeasurements/depth * $units/unit[@code = 
                current()/$node/*:tradeItemMeasurementsModule/tradeItemMeasurements/depth/@measurementUnitCode]/@coef) &gt;=
                number($standardCodes/platformTypeCode[@code= current()/$node/*:packagingInformationModule/packaging/platformTypeCode]/@depth)))
                
                 else true()))
                   
                    else true()">
                    
                 
                       <errorMessage>Les dimensions d'une palette doivent être au moins égales aux dimensions du support palette. Les dimensions des palettes sont fournies dans la liste 12 document GSGDS_022_DonneesFicheProduitV28"</errorMessage>
		           
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
