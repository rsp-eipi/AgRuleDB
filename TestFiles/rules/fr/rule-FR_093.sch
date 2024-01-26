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
   <pattern>
      <title>Rule FR_093</title>
       <doc:description>If isTradeItemADespatchUnit = 'true' and tradeItemUnitDescriptorCode equal PALLET or MIXED_MODULE or DISPLAY_SHIPPER or CASE and if quantityOfChildren greater than 1 then isTradeItemAnOrderableUnit and isTradeItemAnInvoiceUnit must equal TRUE</doc:description>
       <doc:attribute1>tradeItemUnitDescriptorCode, quantityOfChildren, isTradeItemAnOrderableUnit, isTradeItemAnInvoiceUnit</doc:attribute1>
      <rule context="tradeItem">
          <assert test="if ((targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) )) and (gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (gdsnTradeItemClassification/gpcCategoryCode!='10005845') and (isTradeItemADespatchUnit = 'true') and (tradeItemUnitDescriptorCode = ('PALLET','MIXED_MODULE', 'DISPLAY_SHIPPER','CASE')) and (nextLowerLevelTradeItemInformation/quantityOfChildren &gt; 1))then (every $node in (isTradeItemAnOrderableUnit, isTradeItemAnInvoiceUnit) satisfies $node = 'true')
          
          	 else true()">
          	 
          	 	
          	 	       <errorMessage>Les GTIN des displays hétérogènes et colis mixtes sont commandables et facturables, (isTradeItemAnOrderableUnit equal true et isTradeItemAnInvoiceUnit equal true)</errorMessage>
		           
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
