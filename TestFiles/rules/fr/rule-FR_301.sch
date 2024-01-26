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
      <title>Rule FR_301</title>
       <doc:description>If targetMarketCountryCode equals '250' (France), and if gpcCategoryCode belongs to the Class '50202200' (Alcoholic Beverages (Includes De-Alcoholised Variants)) and if gpcCategoryCode is not equal to to ['10008042' (Alcohol Flavouring Kit), '10000142' (Alcohol Making Kits), '10000143' (Alcohol Making Supplies) or '10000591' (Alcoholic Beverages Variety Packs) and if priceComparisonContentTypeCode is used then priceComparisonContentTypeCode SHALL equal 'PER_LITRE'</doc:description>
       <doc:attribute1>targetMarketCountryCode,gpcCategoryCode,isTradeItemAConsumerUnit,priceComparisonContentTypeCode</doc:attribute1>
       <doc:attribute2>priceComparisonContentTypeCode</doc:attribute2>
       <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode = '250')
         				 	and (isTradeItemAConsumerUnit = 'true')
         				 	and (exists(tradeItemInformation/extension/*:salesInformationModule/salesInformation/priceComparisonContentTypeCode))
        					and (tradeItemInformation/extension/*:salesInformationModule/salesInformation/priceComparisonContentTypeCode != '')
           					and (gdsnTradeItemClassification/gpcCategoryCode = ('10008033' , '10008029' , '10008035' , '10008034' , '10008030' , '10008031' ,
                                                                                '10000144' , '10000159' , '10000181' , '10000227' , '10000263' , '10000273' ,
                                                                                '10000275' , '10000276' , '10000588' , '10003689' , '10006327')))
                      		then (every $node in (tradeItemInformation/extension/*:salesInformationModule/salesInformation/priceComparisonContentTypeCode)
                      	  	satisfies  ( $node  = 'PER_LITRE' ) )   				    					 
          				  
          					else true()">
          	 
          	 	
		          	 	       <errorMessage>Pour le marché cible France, et pour toutes les briques GPC appartenant à la classe GPC 50202200 - Boissons Alcoolisées
hormis les Briques ['10000143' (Fournitures de Fabrication d’Alcool), '10008042' (Kits d’Aromatisation pour Alcools) '10000142' (Kits de Fabrication d’Alcool) ou '10000591' (Assortiments de Boissons Alcoolisées)], si 'Type de Mesure / affichage du prix' est renseigné alors sa valeur doit être 'PER_LITRE' (Par litre).</errorMessage>
				           
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
