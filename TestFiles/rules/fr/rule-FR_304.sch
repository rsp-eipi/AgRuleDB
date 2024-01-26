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
      <title>Rule FR_304</title>
       <doc:description>If targetMarketcountrycode equals '250' (France) and If percentageOfAlcoholByVolume is used and its value is greater than '18', then one iteration of dutyFeeTaxTypeCode SHALL equal '3001000002329' (Social security contribution).</doc:description>
       <doc:attribute1>targetMarketCountryCode,percentageOfAlcoholByVolume</doc:attribute1>
       <doc:attribute2>dutyFeeTaxTypeCode</doc:attribute2>
       <doc:avenant>21/06/23 Cette règle ne doit s'appliquer que pour les GPC présentes dans 50202200 (Boissons Alcoolisées et celles qui se trouvent en dessous) uniquement</doc:avenant> 
       <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode = '250')
                      	  and (tradeItemInformation/extension/*:alcoholInformationModule/alcoholInformation/percentageOfAlcoholByVolume &gt; 18 )
                      	  and (gdsnTradeItemClassification/gpcCategoryCode = ('10008042', '10008032', '10008033', '10008029', '10008035', '10008034',
                                                                              '10008030', '10008031', '10000142', '10000143', '10000144', '10000159', 
                                                                              '10000181', '10000227', '10000263', '10000273' ,'10000275', '10000276',
                                                                              '10000588', '10000589', '10000591', '10003689', '10006327'))) 
                      	  then ( exists(tradeItemInformation/extension/*:dutyFeeTaxInformationModule/dutyFeeTaxInformation/dutyFeeTaxTypeCode) 
                      	  and (some $node in (tradeItemInformation/extension/*:dutyFeeTaxInformationModule/dutyFeeTaxInformation/dutyFeeTaxTypeCode) 
                      	  satisfies  ( $node = '3001000002329'))) 				    					 
          				  
          					else true()">
          	 
          	 	
		          	 	       <errorMessage>Pour le marché cible France, si le pourcentage d'alcool est renseigné et sa valeur est supérieure à 18 degrés alors la taxe 3001000002329 (Cotisation sécurité sociale) doit être renseignée.</errorMessage>
				           
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
