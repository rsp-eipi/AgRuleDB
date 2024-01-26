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
      <title>Rule 1792</title>      
      <doc:description>If specialItemCode does not equal 'DYNAMIC_ASSORTMENT' and (quantityOfTradeItemsPerPallet and NonGTINLogisticsUnitInformation/grossWeight
                       and tradeItemMeasurements/tradeItemWeight/grossWeight are used), then NonGTINLogisticsUnitInformation/grossWeight SHALL be greater
                       than 96 % of quantityOfTradeItemsPerPallet multiplied by tradeItemMeasurements/tradeItemWeight/grossWeight.
      </doc:description>    
      <doc:attribute1>specialItemCode,quantityOfTradeItemsPerPallet,nonGTINLogisticsUnitInformation/grossWeight</doc:attribute1> 
      <doc:attribute2>tradeItemWeight/grossWeight</doc:attribute2>       
   	  <rule context="tradeItem">
		    <assert test="if (((tradeItemInformation/extension/*:marketingInformationModule/marketingInformation/specialItemCode != 'DYNAMIC_ASSORTMENT')
		    or not (exists(tradeItemInformation/extension/*:marketingInformationModule/marketingInformation/specialItemCode)))
		  				and (exists(tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfTradeItemsPerPallet))                                                                     									 					
        				and (exists(tradeItemInformation/extension/*:nonGTINLogisticsUnitInformationModule/nonGTINLogisticsUnitInformation/grossWeight) ) 	   
		  				and (exists(tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/grossWeight)))	               	               	               
		                then (number(tradeItemInformation/extension/*:nonGTINLogisticsUnitInformationModule/nonGTINLogisticsUnitInformation/grossWeight) &gt;
    						 (number(tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfTradeItemsPerPallet) *
    						  number(tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/tradeItemWeight/grossWeight) * 0.96))
    						  
				          				 else true()">					          		 
				          		 		
							      		 		<errorMessage>If all of following three attributes are provided, then gross weight of a Non-GTIN Logistic Unit (NonGTINLogisticsUnitInformation/grossWeight) must be greater than 96 % of Trade Item’s Gross Weight (tradeItemMeasurements/tradeItemWeight/grossWeight) multiplied by the Quantity Of Trade Items Per Pallet (quantityOfTradeItemsPerPallet).</errorMessage>
							                
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
