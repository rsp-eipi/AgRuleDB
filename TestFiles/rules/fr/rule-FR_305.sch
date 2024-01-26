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
      <title>Rule FR_305</title>
       <doc:description>IF targetMarketCountryCode equals '250' (France) and if tradeItemTemperatureConditionTypeCode equals ['FROZEN', 'DEEP_FROZEN' or 'FRESH'], then temperatureQualifierCode SHALL be used and equal 'STORAGE_HANDLING' and maximumTemperature and minimumTemperature SHALL be used per temperatureQualifierCode.</doc:description>
       <doc:attribute1>targetMarketCountryCode,tradeItemTemperatureConditionTypeCode</doc:attribute1>
       <doc:attribute2>temperatureQualifierCode,maximumTemperature,minimumTemperature</doc:attribute2>
       <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode = '250')
                      	  and (tradeItemInformation/extension/*:tradeItemTemperatureInformationModule/tradeItemTemperatureConditionTypeCode = ('FROZEN', 'DEEP_FROZEN' , 'FRESH'))) 
                      	  then ( exists(tradeItemInformation/extension/*:tradeItemTemperatureInformationModule/tradeItemTemperatureInformation) 
                      	  and (some $node in (tradeItemInformation/extension/*:tradeItemTemperatureInformationModule/tradeItemTemperatureInformation) 
                      	  satisfies  ( (($node/temperatureQualifierCode = 'STORAGE_HANDLING') and ($node/maximumTemperature != '') and ($node/minimumTemperature != ''))))) 				    					 
          				  
          					else true()">
          	 
          	 	
		          	 	       <errorMessage>Pour le marché cible France, si l'Etat du produit est Frais, congelé ou surgelé, alors les températures minimale et maximale de stockage doivent être renseignées.</errorMessage>
				           
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
