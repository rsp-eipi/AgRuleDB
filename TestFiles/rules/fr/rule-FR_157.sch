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
      <title>Rule FR_157</title>
       <doc:description>If one iteration of targetMarketCountryCode equals '250' (France) and isTradeItemAService equals 'false' then orderQuantityMinimum SHALL be used for at least one level of the hierarchy for which isTradeItemADespatchUnit equals 'true'.</doc:description>
       <doc:attribute1>targetMarketCountryCode,gpcCategoryCode,isTradeItemAService</doc:attribute1>
       <doc:attribute2>orderQuantityMinimum,isTradeItemADespatchUnit</doc:attribute2>
       <rule context="*:catalogueItemNotification">
          <assert test="if((catalogueItem/tradeItem/targetMarket/targetMarketCountryCode = '250')
          				    and (catalogueItem/tradeItem/isTradeItemAService = 'false') )       					
          					then (some $node in (//catalogueItem/tradeItem)          				    					 
          				    satisfies (($node/tradeItemInformation/extension/*:deliveryPurchasingInformationModule/deliveryPurchasingInformation/orderQuantityMinimum &gt;= 1)
          				    and ($node/isTradeItemADespatchUnit ='true')))
          
          					else true()">
          	 
          	 	
		          	 	       <errorMessage>Pour le marché cible France, la quantité minimale de commande doit être au moins égal à un sur au moins un niveau de la hiérarchie logistique.</errorMessage>
				           
					         		 <location>
														<!-- Fichier SDBH -->
														<messageId><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier"/></messageId>
														<messageOwner><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier"/></messageOwner>

														<transactionId><xsl:value-of select="ancestor::transaction/transactionIdentification/entityIdentification"/></transactionId>
														<transactionOwner><xsl:value-of select="ancestor::transaction/transactionIdentification/contentOwner/gln"/></transactionOwner>
														<commandId><xsl:value-of select="ancestor::documentCommand/documentCommandHeader/documentCommandIdentification/entityIdentification"/></commandId>
														<commandOwner><xsl:value-of select="ancestor::documentCommand/documentCommandHeader/documentCommandIdentification/contentOwner/gln"/></commandOwner>


									</location>
		          	 	
  	 	  </assert>
      </rule>
   </pattern>
</schema>
