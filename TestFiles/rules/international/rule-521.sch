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
      <title>Rule 521</title>
       <doc:description>If targetMarketCountryCode is equal to '752' (Sweden) and isTradeItemAnOrderableUnit is equal to 'true' and additionalTradeItemIdentificationTypeCode is equal to ('SUPPLIER_ASSIGNED' or 'DISTRIBUTOR_ASSIGNED') then associated additionalTradeItemIdentification must be unique within hierarchy.</doc:description>
       <doc:attribute1>targetMarketCountryCode, isTradeItemAnOrderableUnit, additionalTradeItemIdentificationTypeCode</doc:attribute1>
       <doc:attribute2>additionalTradeItemIdentification</doc:attribute2>
      <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode =  '752' (:Sweden:) ) and (isTradeItemAnOrderableUnit = 'true') and (additionalTradeItemIdentification/@additionalTradeItemIdentificationTypeCode = ('SUPPLIER_ASSIGNED', 'DISTRIBUTOR_ASSIGNED'))) then (count(additionalTradeItemIdentification) = 1)
          
          			    else true()">
          			    
          			    		
          			    	   <errorMessage>If targetMarketCountryCode is equal to '752' (Sweden), additionalTradeItemIdentificationValue ('SUPPLIER_ASSIGNED', 'DISTRIBUTOR_ASSIGNED') may not have the same value on more than one Trade Item in the same item hierarchy. This rule applies when isTradeItemAnOrderableUnit is equal to 'true'.</errorMessage>
				           
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
