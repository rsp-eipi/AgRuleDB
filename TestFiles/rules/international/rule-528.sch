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
   <let name="gpc" value="doc('../data/data.xml')//data:gpc"/>
   
   <pattern>
      <title>Rule 528</title>
      <doc:description>If targetMarketCountryCode is equal to '036' (Australia) and dutyFeeTaxTypeCode is equal to 'WET' then percentageOfAlcoholByVolume must not be empty</doc:description>
      <doc:attribute1>DutyFeeTaxInformation/dutyFeeTaxTypeCode</doc:attribute1>
      <doc:attribute2>AlcoholInformation/percentageOfAlcoholByVolume</doc:attribute2>
      <rule context="tradeItem">
          <assert test="if ( (targetMarket/targetMarketCountryCode = '036'(: Australia :) )
                        and ((gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP006/gpcDP006Code)
                        or (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP015/gpcDP015Code))
                        and  (tradeItemInformation/extension/*:dutyFeeTaxInformationModule/dutyFeeTaxInformation/dutyFeeTaxTypeCode = 'WET') ) 
                        then  exists(tradeItemInformation/extension/*:alcoholInformationModule/alcoholInformation/percentageOfAlcoholByVolume)
                        and (every $node in (tradeItemInformation/extension/*:alcoholInformationModule/alcoholInformation/percentageOfAlcoholByVolume)
                        satisfies not ( (empty($node)) ) )
          
          				else true()">
          				
          						
          					   <errorMessage>If Target Market is '036' (Australia) and taxTypeCode is equal to 'WET' (Wine Equalisation Tax), then percentageOfAlcoholByVolume must be populated</errorMessage>
				           
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
