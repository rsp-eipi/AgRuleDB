<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
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
      <title>Rule 1091</title>
      <doc:description>If ProductYieldInformation/productYield is not empty then ProductYieldInformation/productYieldTypeCode must not be empty</doc:description>
      <doc:attribute1>ProductYieldInformation/productYield</doc:attribute1>
      <doc:attribute2>ProductYieldInformation/productYieldTypeCode</doc:attribute2>
      <rule context="tradeItem">
          <assert test="if(((gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP006/gpcDP006Code)
                        or (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP015/gpcDP015Code))
                        and (tradeItemInformation/extension/*:foodAndBeveragePreparationServingModule/preparationServing/productYieldInformation/productYield))
                        then  exists(tradeItemInformation/extension/*:foodAndBeveragePreparationServingModule/preparationServing/productYieldInformation/productYieldTypeCode)
                        and (every $node in (tradeItemInformation/extension/*:foodAndBeveragePreparationServingModule/preparationServing/productYieldInformation/productYieldTypeCode)
                        satisfies not ( (empty($node)) ) )
          
          		 else true()">
          		 
          		 		
      		 		<errorMessage>If ProductYieldInformation/productYield is not empty then ProductYieldInformation/productYieldTypeCode must not be empty.</errorMessage>
                
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
