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
      <title>Rule 1656</title>
      <doc:description>If the class CountryOfOrigin or MaterialCountryOfOrigin is repeated,
                       then no two iterations of countryCode in  this class SHALL be equal.                 
      </doc:description>
      <doc:attribute1>CountryOfOrigin,MaterialCountryOrOrigin</doc:attribute1>
      <doc:attribute2>countryCode</doc:attribute2>
      <rule context="tradeItem">
		  <assert test="if (exists(tradeItemInformation/extension/*:placeOfItemActivityModule/placeOfProductActivity/countryOfOrigin)
		                or exists(tradeItemInformation/extension/*:batteryInformationModule/batteryDetail/batteryMaterials/tradeItemMaterialComposition/materialCountryOfOrigin)
		                or exists(tradeItemInformation/extension/*:textileMaterialModule/textileMaterial/textileMaterialComposition/materialCountryOfOrigin)
		                or exists(tradeItemInformation/extension/*:foodAndBeverageIngredientModule/foodAndBeverageIngredient/ingredientPlaceOfActivity/countryOfOrigin))
		                then ((count(tradeItemInformation/extension/*:placeOfItemActivityModule/placeOfProductActivity/countryOfOrigin/countryCode) 
                        eq count(distinct-values(tradeItemInformation/extension/*:placeOfItemActivityModule/placeOfProductActivity/countryOfOrigin/countryCode)  )) 
                        or (count(tradeItemInformation/extension/*:batteryInformationModule/batteryDetail/batteryMaterials/tradeItemMaterialComposition/materialCountryOfOrigin/countryCode) 
                        eq count(distinct-values(tradeItemInformation/extension/*:batteryInformationModule/batteryDetail/batteryMaterials/tradeItemMaterialComposition/materialCountryOfOrigin/countryCode)  ))  
                        or (count(tradeItemInformation/extension/*:textileMaterialModule/textileMaterial/textileMaterialComposition/materialCountryOfOrigin/countryCode) 
                        eq count(distinct-values(tradeItemInformation/extension/*:textileMaterialModule/textileMaterial/textileMaterialComposition/materialCountryOfOrigin/countryCode)  ))  
           				or (count(tradeItemInformation/extension/*:foodAndBeverageIngredientModule/foodAndBeverageIngredient/ingredientPlaceOfActivity/countryOfOrigin/countryCode) 
                        eq count(distinct-values(tradeItemInformation/extension/*:foodAndBeverageIngredientModule/foodAndBeverageIngredient/ingredientPlaceOfActivity/countryOfOrigin/countryCode)  ))  )  
                         			        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>If multiple countries of origin are provided, they SHALL be different.</errorMessage>
							                
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
