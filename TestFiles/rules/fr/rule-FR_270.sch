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
      <title>Rule FR_270</title>
       <doc:description>If one iteration of targetMarketCountryCode equals '250' (France) and if sparePartsAvailabilityPeriod is used then sparePartsAvailabilityPeriod/@timeMeasurementUnitCode SHALL be used.</doc:description>
       <doc:attribute1>targetMarketCountryCode,regulationTypeCode,isTradeItemRegulationCompliant</doc:attribute1>
       <doc:attribute2>sparePartsAvailabilityPeriod/@timeMeasurementUnitCode</doc:attribute2>
       <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode = '250')
                            and (exists(tradeItemInformation/extension/*:tradeItemDisposalInformationModule/tradeItemDisposalInformation/sparePartsAvailabilityInformation/sparePartsAvailabilityPeriod))    
                            and (tradeItemInformation/extension/*:tradeItemDisposalInformationModule/tradeItemDisposalInformation/sparePartsAvailabilityInformation/sparePartsAvailabilityPeriod != '')) 
          					then (exists(tradeItemInformation/extension/*:tradeItemDisposalInformationModule/tradeItemDisposalInformation/sparePartsAvailabilityInformation/sparePartsAvailabilityPeriod/@timeMeasurementUnitCode)
        					and (every $node in (tradeItemInformation/extension/*:tradeItemDisposalInformationModule/tradeItemDisposalInformation/sparePartsAvailabilityInformation/sparePartsAvailabilityPeriod/@timeMeasurementUnitCode) 
        					satisfies ($node != '')))          				    					 
          				  
          					else true()">
          	 
          	 	
		          	 	       <errorMessage>Pour le marché cible France, l'unité de mesure du temps de la période de disponibilité des pièces détachées doit être renseigné si la période de disponibilité des pièces détachées est renseigné.</errorMessage>
				           
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
