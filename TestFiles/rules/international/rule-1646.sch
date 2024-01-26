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
      <title>Rule 1646</title>
      <doc:description>If targetMarketCountryCode equals (056 (Belgium), 442 (Luxembourg), 528 (Netherlands), 276 (Germany), 208 (Denmark), 203 (Czech Republic), 380 (Italy) or 040 (Austria))
                       and tradeItemUnitDescriptorCode is not equal to 'PALLET' or 'MIXED_MODULE',
                       then quantityOfCompleteLayersContainedInATradeItem SHALL NOT be used.
      </doc:description>
      <doc:attribute1>targetMarketCountryCode,tradeItemUnitDescriptorCode</doc:attribute1>
      <doc:attribute2>quantityOfCompleteLayersContainedInATradeItem</doc:attribute2>
      <rule context="tradeItem">
		  <assert test="if (targetMarket/targetMarketCountryCode =  ('056', '442', '528', '276', '208', '203', '380', '040')
		                and (tradeItemUnitDescriptorCode != 'PALLET')
		                and (tradeItemUnitDescriptorCode != 'MIXED_MODULE'))
		                then (every $node in (tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfCompleteLayersContainedInATradeItem)
		                satisfies not (exists($node)))
           							
        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>Attribute quantityOfCompleteLayersContainedInATradeItem shall only be used for GTIN identified pallets.</errorMessage>
							                
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
