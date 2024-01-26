<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" 
	xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
    xmlns:doc="http://doc"
    queryBinding="xslt2">
    <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3"
        prefix="catalogue_item_confirmation"/>
    <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
        prefix="sh"/>
    <ns uri="http://data" prefix="data"/>
    <let name="units" value="doc('../data/data.xml')//data:units"/>
    <pattern>
        <title>Rule FR_026</title>
        <doc:description>IF one iteration of targetMarketCountryCode equals ['249' (France) OR '250' (France)] AND dutyFeeTaxAgencyCode is populated, THEN dutyFeeTaxAgencyCode value SHALL BE '65'</doc:description>
        <doc:attribute>tradeItemInformation/extension/*:dutyFeeTaxInformationModule/dutyFeeTaxInformation/dutyFeeTaxAgencyCode</doc:attribute>
        <rule context="tradeItem">
            <assert test="if((targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) ))
        			      and (exists(tradeItemInformation/extension/*:dutyFeeTaxInformationModule/dutyFeeTaxInformation/dutyFeeTaxAgencyCode)))
            			
            			  then (every $node in (tradeItemInformation/extension/*:dutyFeeTaxInformationModule/dutyFeeTaxInformation/dutyFeeTaxAgencyCode) satisfies $node = '65')
            
            			  else true()">
            	 
            	 	
			            	   <errorMessage>IF one iteration of targetMarketCountryCode equals ['249' (France) OR '250' (France)] AND dutyFeeTaxAgencyCode is populated, THEN dutyFeeTaxAgencyCode value SHALL BE '65'</errorMessage>
				           
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
