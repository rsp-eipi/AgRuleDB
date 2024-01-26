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
      <title>Rule FR_052</title>
       <doc:description>IF one iteration of targetMarketCountryCode equals ['249' (France) OR '250' (France)] AND IF isTradeItemAVariableUnit [ is not populated OR populated with value 'false'] 
						THEN additionalTradeItemIdentification SHALL NOT be populated with additionalTradeItemIdentificationTypeCode equals 'PLU'.</doc:description>
      <doc:attribute1>isTradeItemAVariableUnit, additionalTradeItemIdentification</doc:attribute1>
      <rule context="tradeItem">
          <assert test="if ((targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :)) ) 
                          and (isTradeItemAConsumerUnit = 'true')
                          and (not(exists(tradeItemInformation/extension/*:variableTradeItemInformationModule/variableTradeItemInformation/isTradeItemAVariableUnit)) 
                          or (tradeItemInformation/extension/*:variableTradeItemInformationModule/variableTradeItemInformation/isTradeItemAVariableUnit = 'false')))                           
                          then (every $node in (additionalTradeItemIdentification) satisfies  not($node/@additionalTradeItemIdentificationTypeCode = 'PLU'))  
          
					          	else true()">
					          	
					          		
					          			   <errorMessage>L'identifiant article poids variable (Prix ou Poids) ne peut pas être renseigné pour un produit qui n'est pas à poids variable</errorMessage>
							           
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
