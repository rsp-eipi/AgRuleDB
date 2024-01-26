<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron"
		xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:doc="http://doc"
        queryBinding="xslt2">
    <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
        prefix="sh"/>
   <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3"
       prefix="catalogue_item_confirmation"/>
   <ns uri="http://data" prefix="data"/>
   <let name="units" value="doc('../data/data.xml')//data:units"/>
   <pattern>
      <title>Rule 507</title>
       <doc:description>If packagingMaterialCompositionQuantity and packagingWeight are not empty then the sum of all instances of packagingMaterialCompositionQuantity for the trade item must be less than or equal to packagingWeight.</doc:description>
       <doc:attribute1>PackagingMaterial/packagingMaterialCompositionQuantity</doc:attribute1>
       <doc:attribute2>Packaging/packagingWeight</doc:attribute2>
       <rule context="tradeItem/tradeItemInformation/extension/*:packagingInformationModule/packaging">
           <assert test="if((packagingMaterial/packagingMaterialCompositionQuantity) and (packagingWeight)) then(sum(for $node in (packagingMaterial/packagingMaterialCompositionQuantity) return $node *($units/unit[@code=current()/$node/@measurementUnitCode]/@coef)) &lt;= (packagingWeight * $units/unit[@code=current()/packagingWeight/@measurementUnitCode]/@coef))
           
           				 else true()">
           				 
           				 	
           				 	<errorMessage>The total of values in packagingMaterialCompositionQuantity may not exceed the value in packagingWeight for the same item .</errorMessage>
         	
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
											<gtin><xsl:value-of select="ancestor::tradeItem/gtin"/></gtin>
											<glnProvider><xsl:value-of select="ancestor::tradeItem/informationProviderOfTradeItem/gln"/></glnProvider>
											<targetMarket><xsl:value-of select="ancestor::tradeItem/targetMarket/targetMarketCountryCode"/></targetMarket>	
									
							</location> 
           				 	
	 	   </assert>
      </rule>
   </pattern>
</schema>
