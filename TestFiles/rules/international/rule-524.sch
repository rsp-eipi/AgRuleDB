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
      <title>Rule 524</title>
      <doc:description>If targetMarketCountryCode equals ('036' (Australia), '554' (New Zealand), '752' (Sweden), '348' (Hungary), '124' (Canada), '840' (United States), '208' (Denmark), '246' (Finland), '250' (France), or '380' (Italy)) and isTradeItemAConsumerUnit equals 'true' then netContent SHALL be used.</doc:description>
      <doc:attribute1>TradeItem/isTradeItemAConsumerUnit</doc:attribute1>
      <doc:attribute2>TradeItemMeasurements/netContent</doc:attribute2>
      <rule context="tradeItem">
         <assert test="if ( (targetMarket/targetMarketCountryCode =  ('036'(: Australia :) , '554'(: New Zealand :) , '752'(: Sweden :) , '348'(: Hungary :) , '528'(: Netherlands :) , '124'(: Canada :) , '840'(: US :) 
                                                                    , '208'(: Denmark :) , '246'(: Finland :) , '250'(: France :) , '380'(: Italy :)    ) )
                       and  (isTradeItemAConsumerUnit = 'true') )
                       then  exists(tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/netContent) 
                       and (every $node in (tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/netContent) satisfies not ( (empty($node)) ) ) 
         
         			   else true()">
         			   
         			   			
         			   		   <errorMessage>netContent is not used. This attribute shall be used if isTradeItemAConsumerUnit equals ‘true’ for targetMarketCountryCode name.</errorMessage>
				           
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
