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
      <title>Rule 477</title>
       <doc:description>If targetMarketCountryCode is equal to ('752' (Sweden), '203' (Czech Republic), '250' (France), '208' (Denmark), '246' (Finland), '040' (Austria), or '703' (Slovakia)) and maximumTemperature , minimumTemperature or FlashPoint/flashPointTemperature are used then at least one instance of the associated measurementUnitCode shall equal 'CEL'.</doc:description>
       <doc:avenant>Modif. 3.1.25  Ajout 703' (Slovakia)</doc:avenant>
       <doc:attribute1>targetMarketCountryCode, maximumTemperature, minimumTemperature</doc:attribute1>
       <doc:attribute2>Flashpoint/flashPointTemperature, UnitOfMeasureCode</doc:attribute2>
      <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode = ('752'(: Sweden :) , '203'(: Czech Republic :) , '250'(: France :) , '208'(: Denmark :), '246'(: Finland :) , '040'(: Austria :), '703'(: Slovakia :)))
                        and ((tradeItemInformation/extension/*:safetyDataSheetModule/safetyDataSheetInformation/physicalChemicalPropertyInformation/flashPoint/flashPointTemperature)
                        or (tradeItemInformation/extension/*:tradeItemTemperatureInformationModule/tradeItemTemperatureInformation/maximumTemperature)
                        or (tradeItemInformation/extension/*:transportationHazardousClassificationModule/transportationClassification/regulatedTransportationMode/hazardousInformationHeader/flashPointTemperature)
                        or (tradeItemInformation/extension/*:tradeItemTemperatureInformationModule/tradeItemTemperatureInformation/minimumTemperature))) 
                        then (every $node in (tradeItemInformation/extension/*:safetyDataSheetModule/safetyDataSheetInformation/physicalChemicalPropertyInformation/flashPoint/flashPointTemperature/@temperatureMeasurementUnitCode,
                        					  tradeItemInformation/extension/*:transportationHazardousClassificationModule/transportationClassification/regulatedTransportationMode/hazardousInformationHeader/flashPointTemperature/@temperatureMeasurementUnitCode,	
                                              tradeItemInformation/extension/*:tradeItemTemperatureInformationModule/tradeItemTemperatureInformation/maximumTemperature/@temperatureMeasurementUnitCode,
                                              tradeItemInformation/extension/*:tradeItemTemperatureInformationModule/tradeItemTemperatureInformation/minimumTemperature/@temperatureMeasurementUnitCode)
                        satisfies($node = 'CEL'))
          
          				else true()">
          				 
          						
          					   <errorMessage>Unit of measures for maximum, minimum temperatures and flashPointTemperature shall be specified as degrees Celsius for this target market.</errorMessage>
				           
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
