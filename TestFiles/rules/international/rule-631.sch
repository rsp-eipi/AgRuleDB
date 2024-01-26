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
      <title>Rule 631</title>
       <doc:description>If targetMarketCountryCode is equal to '372' (Ireland) and if isTradeItemABaseUnit is equal to 'true' and ((gpcCategoryCode is in Class ('50202200' or '50211500') and does not equal ('10000142', '10000143', '10000303' or '10000584')) then at least one iteration of AdditionalTradeItemClassification must have a value with additionalTradeItemClassificationCodeListCode equal to '57'(REV).</doc:description>
       <doc:attribute1>TradeItemInformation/isTradeItemABaseUnit</doc:attribute1>
       <doc:attribute2>AdditionalTradeItemClassification/additionalTradeItemClassificationCodeListCode</doc:attribute2>
       <doc:attribute3>GDSNTradeItemClassification/gpcCategoryCode</doc:attribute3>
      <rule context="tradeItem">
          <assert test="if (((gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP006/gpcDP006Code)
                        or (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP015/gpcDP015Code))
                        and (targetMarket/targetMarketCountryCode = '372'(: Ireland :) )
                        and  (isTradeItemABaseUnit = 'true'))                       
                        then  exists(additionalTradeItemIdentification/@additionalTradeItemIdentificationTypeCode)
                        and (some $node in (additionalTradeItemIdentification/@additionalTradeItemIdentificationTypeCode) 
                        satisfies  $node = '57' ) 
          
          				else true()">
          				
          						
          								   <errorMessage>If targetMarketCountryCode is equal to '372' (Ireland) and if isTradeItemABaseUnit is equal to 'true' and ((gpcCategoryCode is in Class ('50202200' or '50211500') and does not equal ('10000142', '10000143', '10000303' or '10000584')) then at least one iteration of AdditionalTradeItemClassification must have a value with additionalTradeItemClassificationCodeListCode equal to '57'(REV).</errorMessage>
				           
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
