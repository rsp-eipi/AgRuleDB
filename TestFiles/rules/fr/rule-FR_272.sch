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
      <title>Rule FR_272</title>
       <doc:description>If one iteration of targetMarketCountryCode equals '250' (France), if isTradeItemABaseUnit equals 'true' and if gpcCategoryCode equals '10000273' (- Wine – Fortified), '10000275' (- Wine – Sparkling) or '10000276' (- Wine – Still) then isTradeItemAQualityVintageAlcoholProduct SHALL be used.</doc:description>
       <doc:attribute1>targetMarketCountryCode,gpcCategoryCode</doc:attribute1>
       <doc:attribute2>isTradeItemAQualityVintageAlcoholProduct</doc:attribute2>
       <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode = '250')
                            and (isTradeItemAConsumerUnit = 'true')
        					and (gdsnTradeItemClassification/gpcCategoryCode = ('10000273' , '10000275' , '10000276') ))   				  				
          					then (exists(tradeItemInformation/extension/*:alcoholInformationModule/alcoholInformation/isTradeItemAQualityVintageAlcoholProduct)              			      			 
            			    and (every $node in (tradeItemInformation/extension/*:alcoholInformationModule/alcoholInformation/isTradeItemAQualityVintageAlcoholProduct)
            			    satisfies ($node != '')))          				    					 
          				  
          					else true()">
          	 
          	 	
		          	 	       <errorMessage>Pour le marché cible France, si l'unité commerciale est une unité de base alors pour les vin tranquilles, les vins mousseux ou les vins fortifiés il est nécessaire de renseigné si l'unité commerciale est a un millésime.</errorMessage>
				           
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
