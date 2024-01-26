<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform" queryBinding="xslt2"
    xmlns:doc="http://doc"
    xmlns:data="http://data">
    <!-- define namespaces -->
    <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3" prefix="catalogue_item_confirmation"/>
    <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader" prefix="sh"/>
    <ns uri="http://data" prefix="data"/>
    <!-- defines contexts -->
    <let name="units" value="doc('../data/data.xml')//data:units"/>
    <pattern>
        <title>Rule 616</title>
        <doc:description>if drainedWeight and netWeight are not empty then drainedWeight must be less than or equal to netWeight.</doc:description>
        <doc:attribute1><tofix action="lowercase">T</tofix>radeItemWeight/drainedWeight</doc:attribute1>
        <doc:attribute2><tofix action="lowercase">T</tofix>radeItemWeight/netWeight</doc:attribute2>
        <rule context="tradeItemWeight">
            <doc:question number="4">Where are the insertions points of TradeItemMeasurementsModule</doc:question>      
            <assert test="if (drainedWeight and netWeight)
                then if (drainedWeight/@measurementUnitCode
                = netWeight/@measurementUnitCode)
                then (number(drainedWeight) le number(netWeight))
                else (: here we don't have the same @measurementUnitCode :)
                (: we need to see if they are measuring the same type of data :)
                if ($units/unit[@code=current()/drainedWeight/@measurementUnitCode]/@type
                = $units/unit[@code=current()/netWeight/@measurementUnitCode]/@type)
                then (drainedWeight * $units/unit[@code=current()/drainedWeight/@measurementUnitCode]/@coef
                le netWeight   * $units/unit[@code=current()/netWeight/@measurementUnitCode]/@coef)
                else false() (: incomparable weight :)
                
               			 else true() (: there is not grossWeight AND netweight :)">
               			 
               			 		
               			 				   <errorMessage>If the net drained weight is populated (drainedWeight) the net weight must be less than or equal to its net weight (netWeight).</errorMessage>
				           
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