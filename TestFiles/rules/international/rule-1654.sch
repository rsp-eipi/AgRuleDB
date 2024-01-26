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
   <pattern>
      <title>Rule 1653</title>
      <doc:description>If targetMarketCountryCode equals (528 (Netherlands), 752 (Sweden), 276 (Germany), 056 (Belgium), 442 (Luxembourg), 203 (Czech Republic), 826 (UK), 380 (Italy) or 040 (Austria)) and dailyValueIntakePercent is used and nutrientTypeCode equals ('FAT', 'FASAT', 'ENER-', 'CHOAVL', 'PRO-', 'SUGAR-' or 'SALTEQ'), then dailyValueIntakeReference in the corresponding iteration of class NutrientHeader SHALL be used.
      </doc:description>
      <doc:attribute1>targetMarketCountryCode,dailyValueIntakePercent,nutrientTypeCode</doc:attribute1>
      <doc:attribute2>dailyValueIntakeReference</doc:attribute2>
      <rule context="tradeItem">
		  <assert test="if ((targetMarket/targetMarketCountryCode =  ('528', '752', '276', '056', '442', '203', '826', '380', '040'))
		                and exists(tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/nutrientDetail/dailyValueIntakePercent)                                                                          									 					
        				and (tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/nutrientDetail/nutrientTypeCode = ('FAT', 'FASAT', 'ENER-', 'CHOAVL', 'PRO-', 'SUGAR-', 'SALTEQ')))		                
		                then exists(tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/dailyValueIntakeReference)
         				and (every $node in (tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/dailyValueIntakeReference)
         			    satisfies  $node!='')                   
           							        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>If dailyValueIntakePercent is used for any of the 7 main nutrients listed in Article 30 (1) of EU Regulation 1169/2011, then dailyValueIntakeReference SHALL be used.
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
