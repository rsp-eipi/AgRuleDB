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
      <title>Rule 1275</title>
       <doc:description>If any attribute in the FoodAndBeverageIngredient Class except for grapeVarietyCode is not empty, then  must not be empty.</doc:description>
       <doc:attribute1>FoodAndBeverageIngredient /ingredientName</doc:attribute1>
       <rule context="tradeItem">
           <assert test="if ((gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP006/gpcDP006Code)
                         or (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP015/gpcDP015Code)) 
                         then (every $node in (tradeItemInformation/extension/*:foodAndBeverageIngredientModule/foodAndBeverageIngredient)
                         satisfies(if(($node/avpList) or ($node/ingredientContentPercentage)
                         or($node/ingredientPlaceOfActivity) or($node/ingredientPurpose)
                         or($node/ingredientSequence) or($node/ingredientParty)
                         or($node/ingredientOrganicInformation)
                         or ($node/ingredientFarmingProcessing))
                         then (exists($node/ingredientName)
                         and (every $node1 in ($node/ingredientName)
                         satisfies  (not(empty($node1)) ) )) 
                         
                         	else true())) 
           
			           				 else true()">
			           					
			           					
					   					<errorMessage>If any attribute in the FoodAndBeverageIngredient Class except for grapeVarietyCode is not empty, then ingredientName must not be empty.</errorMessage>
					                
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
