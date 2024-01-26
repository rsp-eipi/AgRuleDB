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
   <let name="gpc" value="doc('../data/data.xml')//data:gpc"/>
   <pattern>
      <title>Rule 1715</title>
       <doc:description>If one iteration of targetMarketCountryCode equals '250' (France), then the value UNSPECIFIED can not exists.</doc:description>
       <rule context="tradeItem">
           <assert test="if (targetMarket/targetMarketCountryCode = '250')
        				 then (
                            (if (exists(displayUnitInformation/hasDisplayReadyPackaging)) then every $node in (displayUnitInformation/hasDisplayReadyPackaging) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(displayUnitInformation/isTradeItemADisplayUnit)) then every $node in (displayUnitInformation/isTradeItemADisplayUnit) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:farmingAndProcessingInformationModule/rawMaterialIrradiatedCode)) then every $node in (tradeItemInformation/extension/*:farmingAndProcessingInformationModule/rawMaterialIrradiatedCode) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:farmingAndProcessingInformationModule/tradeItemFarmingAndProcessing/irradiatedCode)) then every $node in (tradeItemInformation/extension/*:farmingAndProcessingInformationModule/tradeItemFarmingAndProcessing/irradiatedCode) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:marketingInformationModule/marketingInformation/season/isTradeItemSeasonal)) then every $node in (tradeItemInformation/extension/*:marketingInformationModule/marketingInformation/season/isTradeItemSeasonal) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:referencedFileDetailInformationModule/referencedFileHeader/referencedFileDetail/isFileBackgroundTransparent)) then every $node in (tradeItemInformation/extension/*:referencedFileDetailInformationModule/referencedFileHeader/referencedFileDetail/isFileBackgroundTransparent) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:referencedFileDetailInformationModule/referencedFileHeader/referencedFileDetail/fileUsageInformation/canFilesBeEdited)) then every $node in (tradeItemInformation/extension/*:referencedFileDetailInformationModule/referencedFileHeader/referencedFileDetail/fileUsageInformation/canFilesBeEdited) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/isTradeItemPackedIrregularly)) then every $node in (tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/isTradeItemPackedIrregularly) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:foodAndBeverageIngredientModule/isIngredientRelevantDataProvided)) then every $node in (tradeItemInformation/extension/*:foodAndBeverageIngredientModule/isIngredientRelevantDataProvided) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:referencedFileDetailInformationModule/referencedFileHeader/isPrimaryFile)) then every $node in (tradeItemInformation/extension/*:referencedFileDetailInformationModule/referencedFileHeader/isPrimaryFile) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:regulatedTradeItemModule/regulatoryInformation/isTradeItemRegulationCompliant)) then every $node in (tradeItemInformation/extension/*:regulatedTradeItemModule/regulatoryInformation/isTradeItemRegulationCompliant) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:dairyFishMeatPoultryItemModule/dairyFishMeatPoultryInformation/cheeseInformation/isRindEdible)) then every $node in (tradeItemInformation/extension/*:dairyFishMeatPoultryItemModule/dairyFishMeatPoultryInformation/cheeseInformation/isRindEdible) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:dairyFishMeatPoultryItemModule/dairyFishMeatPoultryInformation/isHomogenised)) then every $node in (tradeItemInformation/extension/*:dairyFishMeatPoultryItemModule/dairyFishMeatPoultryInformation/isHomogenised) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:batteryInformationModule/batteryDetail/areBatteriesBuiltIn)) then every $node in (tradeItemInformation/extension/*:batteryInformationModule/batteryDetail/areBatteriesBuiltIn) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:salesInformationModule/salesInformation/isBasePriceDeclarationRelevant)) then every $node in (tradeItemInformation/extension/*:salesInformationModule/salesInformation/isBasePriceDeclarationRelevant) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:dangerousSubstanceInformationModule/dangerousSubstanceInformation/dangerousSubstanceProperties/isDangerousSubstance)) then every $node in (tradeItemInformation/extension/*:dangerousSubstanceInformationModule/dangerousSubstanceInformation/dangerousSubstanceProperties/isDangerousSubstance) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:certificationInformationModule/certificationInformation/isCertificateRequired)) then every $node in (tradeItemInformation/extension/*:certificationInformationModule/certificationInformation/isCertificateRequired) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:nutritionalInformationModule/nutritionalClaimDetail/claimMarkedOnPackage)) then every $node in (tradeItemInformation/extension/*:nutritionalInformationModule/nutritionalClaimDetail/claimMarkedOnPackage) satisfies ($node != 'UNSPECIFIED') else true())
                            and (if (exists(tradeItemInformation/extension/*:batteryInformationModule/batteryDetail/isBatteryRechargeable)) then every $node in (tradeItemInformation/extension/*:batteryInformationModule/batteryDetail/isBatteryRechargeable) satisfies ($node != 'UNSPECIFIED') else true())
                         )
                         else true()">

		          	 	       <errorMessage>If targetMarketCountryCode equals '250' (France) and an attribute with NonBinaryLogicEnumeration data type is used, then its value SHALL NOT equal 'UNSPECIFIED'.</errorMessage>

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
										<gtin><xsl:value-of select="catalogueItem/tradeItem/gtin"/></gtin>
										<glnProvider><xsl:value-of select="catalogueItem/tradeItem/informationProviderOfTradeItem/gln"/></glnProvider>
										<targetMarket><xsl:value-of select="catalogueItem/tradeItem/targetMarket/targetMarketCountryCode"/></targetMarket>

						   			</location>

  	 	  </assert>
      </rule>
   </pattern>
</schema>
