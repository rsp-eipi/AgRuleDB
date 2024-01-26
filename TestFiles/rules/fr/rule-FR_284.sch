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
      <title>Rule FR_284</title>
       <doc:description>If one iteration of targetMarketCountryCode equals '250' (France) and if productActivityTypeCode equals 'BIRTH', 'REARING', 'SLAUGHTER' or 'CATCH_ZONE' then countryOfActivity/countryCode SHALL be used and be made of three digits.</doc:description>
       <doc:attribute1>targetMarketCountryCode,productActivityTypeCode</doc:attribute1>
       <doc:attribute2>countryCode</doc:attribute2>
       <rule context="productActivityDetails">
          <assert test="if((ancestor::tradeItem/targetMarket/targetMarketCountryCode = '250')
        					and (productActivityTypeCode = ('BIRTH', 'REARING', 'SLAUGHTER' , 'CATCH_ZONE')))  				
          					then (exists(countryOfActivity/countryCode)
          					and (every $node in (countryOfActivity/countryCode) 
		                    satisfies (string-length($node) =  3)))        				    					 
          				  
          						else true()">
          	 
          	 	
		          	 	       <errorMessage>Pour le marché cible France, le code pays du pays d'activité avec une valeur comportant 3 chiffres doit être renseigné si le pays d'activité est renseigné et si le code de type d'activité du produit vaut 'BIRTH', 'REARING', 'SLAUGHTER' ou 'CATCH_ZONE'.</errorMessage>
				           
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
