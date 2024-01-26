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
      <title>Rule 1771</title>
      <doc:description>If targetMarketCountryCode equals '528' (the Netherlands)
                       and if isTradeItemAConsumerUnit equals 'true’ and (nutrientTypeCode is used with 'NA' and quantityContained is greater than or equal to 0.1 GRM 
                       and if measurementPrecisionCode is NOT equal to 'LESS_THAN') and if (nutrientTypeCode is used with 'SALTEQ' and if measurementPrecisionCode is NOT equal to 'LESS_THAN'
                       and quantityContained is greater than or equal to 0.1 GRM), 
                       then quantityContained of nutrientTypeCode 'NA' multiplied by 2.5, SHALL be less than 1.1 times and greater than 0.9 times quantityContained of nutrientTypeCode 'SALTEQ’.
      </doc:description>
      <doc:attribute1>targetMarketCountryCode,isTradeItemAConsumerUnit,gpcCategoryCode,</doc:attribute1>
      <doc:attribute2>nutrientTypeCode,quantityContained,measurementPrecisionCode</doc:attribute2>
      <rule context="tradeItem">
		  <assert test="if ((targetMarket/targetMarketCountryCode = '528')
		                and (isTradeItemAConsumerUnit = 'true')
		                and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code))                                                                          									 					
        				and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP008/gpcDP008Code)) 
        				and ((exists(tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/nutrientDetail/nutrientTypeCode = 'NA'))
        				and (exists(tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/nutrientDetail/quantityContained[. &gt;='0.1']/@measurementUnitCode[.='GRM']))
        				and (exists(tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/nutrientDetail/measurementPrecisionCode[. != 'LESS_THAN'])))
        				and ((exists(tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/nutrientDetail/nutrientTypeCode = 'SALTEQ'))
        				and (exists(tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/nutrientDetail/quantityContained[. &gt;='0.1']/@measurementUnitCode[.='GRM']))
        				and (exists(tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/nutrientDetail/measurementPrecisionCode[. != 'LESS_THAN'])))
        				) 
        				 then (every $node in (tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader[exists(./nutrientDetail/nutrientTypeCode[.='NA'])
		                and exists(./nutrientDetail/nutrientTypeCode[.='CHOAVL'])]) 
		                satisfies(every $node1 in ($node/nutrientDetail[nutrientTypeCode[.='NA']]/quantityContained)
		                satisfies (every $node2 in ($node/nutrientDetail[nutrientTypeCode[.='CHOAVL']]/quantityContained) 
		                satisfies (number($node1) * 2.5  &lt; number($node2) * 1.1)     
		                and (number($node1) * 2.5  &gt; number($node2) * 0.9) ))) 
		                 	
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>The amount of nutrient type code 'NA' multiplied by 2.5 may not deviate more than 10% from the amount of nutrient type code SALTEQ with identical unit of measure in case of consumer units and a measurementPrecisionCode not equal to 'LESS_THAN' for target market Netherlands.</errorMessage>
							                
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
