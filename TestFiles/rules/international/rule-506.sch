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
      <title>Rule 506</title>
      <doc:description>If targetMarketCountryCode equals ('752' (Sweden), '528' (Netherlands), '203' (Czech Republic) or '246' (Finland)) and packagingMaterialCompositionQuantity is used then in at least one iteration of packagingMaterialCompositionQuantity the related packagingMaterialCompositionQuantity/@measurementUnitCode SHALL equal 'KGM' or 'GRM'.</doc:description>
      <doc:avenant>Modif. 3.1.25  Ajout 703 (Slovakia)</doc:avenant>
      <doc:attribute1>PackagingMaterial/packagingMaterialCompositionQuantity</doc:attribute1>
      <rule context="tradeItem">
         <assert test="if ( (targetMarket/targetMarketCountryCode =  ('752'(: Sweden :) , '528'(: Netherlands :) , '203'(: Czech Republic :) , '246'(: Finland :) ) ) 
                       and  exists(tradeItemInformation/extension/*:packagingInformationModule/packaging/packagingMaterial/packagingMaterialCompositionQuantity ) )
                       then  exists(tradeItemInformation/extension/*:packagingInformationModule/packaging/packagingMaterial/packagingMaterialCompositionQuantity/@measurementUnitCode)
                       and (every $node in (tradeItemInformation/extension/*:packagingInformationModule/packaging/packagingMaterial/packagingMaterialCompositionQuantity/@measurementUnitCode)
                       satisfies ($node = ('KGM', 'GRM')) ) 
         
         			   	else true()">
         			   
         			   	       <targetMarketCountryCode><xsl:value-of select="targetMarket/targetMarketCountryCode"/></targetMarketCountryCode>
         			   		   <packagingMaterialCompositionQuantity><xsl:value-of select="tradeItemInformation/extension/*:packagingInformationModule/packaging/packagingMaterial/packagingMaterialCompositionQuantity/@measurementUnitCode"/></packagingMaterialCompositionQuantity>				
         			   		   <errorMessage>For Country of Sale Code (#targetMarketCountryCode#), the Packaging Material Quantity (packagingMaterialCompositionQuantity) unit of measure #packagingMaterialCompositionQuantity# is incorrect. The unit of measure SHALL be gram (GRM) or kilogram (KGM).</errorMessage>
				           
					           <location>
											<!-- Fichier SDBH -->
											<messageId><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier"/></messageId>
						 										
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
