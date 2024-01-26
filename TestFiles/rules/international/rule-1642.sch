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
      <title>Rule 1642</title>
      <doc:description>If targetMarketCountryCode equals ('056' (: Belgium :), '442' (: Luxembourg :), '528' (: Netherlands :), '276' (: Germany :), '208' (: Denmark :), 
                                                          '203' (: Czech Republic :), '246' (: Finland) :, '826' (: UK :), '380' (: Italy :), '250' (: France :), '040' (: Austria :))
                       for the same nutrientBasisQuantity or servingSize 
                       and one instance of nutrientTypeCode equals 'POLYL' and quantityContained is used 
                       and another instance of nutrientTypeCode equals 'CHOAVL' and quantityContained is used, 
                       then quantityContained for nutrientTypeCode 'POLYL' SHALL be less than or equal to quantityContained for nutrientTypeCode 'CHOAVL'.
      </doc:description>
      <doc:attribute1>targetMarketCountryCode</doc:attribute1>
      <doc:attribute2>nutrientTypeCode,quantityContained</doc:attribute2>
      <rule context="tradeItem">
		  <assert test="if (targetMarket/targetMarketCountryCode =  ('056', '442', '528', '276', '208', '203', '246', '826', '380', '250', '040'))
		                then (every $node in (tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader[exists(./nutrientDetail/nutrientTypeCode[.='POLYL'])
		                and exists(./nutrientDetail/nutrientTypeCode[.='CHOAVL'])]) 
		                satisfies(every $node1 in ($node/nutrientDetail[nutrientTypeCode[.='POLYL']]/quantityContained)
		                satisfies (every $node2 in ($node/nutrientDetail[nutrientTypeCode[.='CHOAVL']]/quantityContained) satisfies (number($node1) &lt;= number($node2))))) 
           							
        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>Quantity of polyols (Carbohydrates of which multiple alcohols) ('POLYL') is greater than the quantity of carbohydrates ('CHOAVL').</errorMessage>
							                
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
