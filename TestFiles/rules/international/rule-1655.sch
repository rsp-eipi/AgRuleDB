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
      <title>Rule 1655</title>
      <doc:description>If targetMarketCountryCode equals (056 (Belgium), 442 (Luxembourg), 528 (Netherlands), 250 (France), 208 (Denmark), 203 (Czech Republic), 246 (Finland), 826 (UK), or 380 (Italy)) and isTradeItemNonphysical, does not equal 'true' or is not populated and isTradeItemAConsumerUnit equals 'false' and TradeItemMeasurements/depth is used and TradeItemMeasurements/width is used, then TradeItemMeasurements/depth SHALL be greater than or equal to TradeItemMeasurements/width.</doc:description> 
      <doc:attribute1>targetMarketCountryCode,isTradeItemNonphysical,isTradeItemAConsumerUnit,gpcCategoryCode</doc:attribute1>
      <doc:attribute2>depth,width</doc:attribute2>
      <rule context="tradeItem">
		  <assert test="if ((targetMarket/targetMarketCountryCode =  ('056', '442', '528', '250', '208', '203', '246', '826', '380'))
		                and (isTradeItemAConsumerUnit = 'false')
		                and  not(gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcHealthcareList/gpcHealthcareCode)
		                and exists (tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/width)
		                and ((isTradeItemNonphysical != 'true') or not (exists(isTradeItemNonphysical)))) 		                
		                then (every $node in (tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements[exists(./depth)
		                and exists(./width)]) 
		                satisfies(every $node1 in ($node/depth)
		                satisfies (every $node2 in ($node/width) satisfies (number($node1) &gt;= number($node2)))))           
           							        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>According to the GS1 measurement rules, depth shall be greater than or equal to width when trade item is not a consumer (POS) unit.</errorMessage>
							                
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
