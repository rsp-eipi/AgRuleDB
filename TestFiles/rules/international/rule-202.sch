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
      <title>Rule 202</title>
       <doc:description>If specialItemCode is not equal to 'DYNAMIC_ASSORTMENT' then the sum of all quantityofNextLowerLevelTradeItem must be equal to totalQuantityOfNextLowerLevelTradeItem.</doc:description>
       <doc:attribute1>specialItemCode, quantityofNextLowerLevelTradeItem, totalQuantityOfNextLowerLevelTradeItem </doc:attribute1>
      <rule context="tradeItem">
          <assert test="if(not(tradeItemInformation/extension/*:marketingInformationModule/marketingInformation/specialItemCode = 'DYNAMIC_ASSORTMENT') and (nextLowerLevelTradeItemInformation))then (sum(nextLowerLevelTradeItemInformation//childTradeItem/quantityOfNextLowerLevelTradeItem) = nextLowerLevelTradeItemInformation/totalQuantityOfNextLowerLevelTradeItem)
          
          				else true()">
          
          					
							<errorMessage>Sum of quantityofNextLowerLevelTradeItem must equal totalQuantityOfNextLowerLevelTradeItem except when special item code = 'dynamic_assortment'. See the approved validations rule document for certification If grossWeight and netWeight are provided on the same record, grossWeight must be greater than or equal to netWeight</errorMessage>   
				          	
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
