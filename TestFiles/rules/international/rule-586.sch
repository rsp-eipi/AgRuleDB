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
      <title>Rule 586</title>
      <doc:description>If targetMarketCountryCode is equal to '840' (US) and growingMethodCode is equal to 'ORGANIC' then organicClaimAgencyCode and organicTradeItemCode must not be empty</doc:description>
      <doc:attribute1>FarmingAndProcessingInformation/growingMethodCode</doc:attribute1>
      <doc:attribute2>OrganicClaim/organicClaimAgencyCode</doc:attribute2>
      <doc:attribute3>OrganicClaim/organicTradeItemCode</doc:attribute3>
      <rule context="tradeItem">
          <assert test="if ( (targetMarket/targetMarketCountryCode = '840'(: US :) )
                        and not(gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcHealthcareList/gpcHealthcareCode)
                        and  (tradeItemInformation/extension/*:farmingAndProcessingInformationModule/tradeItemFarmingAndProcessing/growingMethodCode = 'ORGANIC') )
                        then  exists(tradeItemInformation/extension/*:farmingAndProcessingInformationModule/tradeItemOrganicInformation/organicClaim/organicClaimAgencyCode)
                        and exists(tradeItemInformation/extension/*:farmingAndProcessingInformationModule/tradeItemOrganicInformation/organicClaim/organicTradeItemCode)
                        and (every $node in (tradeItemInformation/extension/*:farmingAndProcessingInformationModule/tradeItemOrganicInformation/organicClaim/organicClaimAgencyCode, tradeItemInformation/extension/*:farmingAndProcessingInformationModule/tradeItemOrganicInformation/organicClaim/organicTradeItemCode) 
                        satisfies not ( (empty($node)) ) )
          
          			    else true()">
          			    
          			    			
          			    			       <errorMessage>If targetMarket equals '840' (US) and growingMethodCode equals 'ORGANIC' then organicClaimAgency and organicTradeItemCode MUST not be empty.</errorMessage>
				           
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
