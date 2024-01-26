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
      <title>Rule 1697</title>
      <doc:description>Code value '097' (European Union) and 'NON_EU' (Non European Union) shall not be used with /catalogue_item_notification:catalogueItemNotificationMessage/transaction/documentCommand/catalogue_item_notification:catalogueItemNotification/catalogueItem/tradeItem/targetMarket/targetMarketCountryCode, /catalogue_item_publication:catalogueItemPublicationMessage/transaction/documentCommand/catalogue_item_publication:catalogueItemPublication/publishToTargetMarket/targetMarketcountryCode, /catalogue_item_publication:catalogueItemPublicationMessage/transaction/documentCommand/catalogue_item_publication:catalogueItemPublication/catalogueItemReference/targetMarketCountryCode, /request_for_catalogue_item_notification:requestForCatalogueItemNotificationMessage/transaction/documentCommand/request_for_catalogue_item_notification:requestForCatalogueItemNotification/targetMarket/targetMarketCountryCode, /catalogue_item_subscription:catalogueItemSubscriptionMessage/transaction/documentCommand/catalogue_item_subscription:catalogueItemSubscription/targetMarket/targetMarketCountryCode 
      </doc:description>
      <doc:attribute1>targetMarketCountryCode</doc:attribute1>
       
      <rule context="*">
          <assert test="if ( (exists(/*:catalogueItemNotificationMessage/transaction/documentCommand/*:catalogueItemNotification/catalogueItem/tradeItem/targetMarket/targetMarketCountryCode))
                        or (exists(/*:catalogueItemPublicationMessage/transaction/documentCommand/*:catalogueItemPublication/publishToTargetMarket/targetMarketcountryCode)) 
                        or (exists(/*:catalogueItemPublicationMessage/transaction/documentCommand/*:catalogueItemPublication/catalogueItemReference/targetMarketCountryCode)) 
                        or (exists(/*:requestForCatalogueItemNotificationMessage/transaction/documentCommand/*:requestForCatalogueItemNotification/targetMarket/targetMarketCountryCode)) 
                        or (exists(/*:catalogueItemSubscriptionMessage/transaction/documentCommand/*:catalogueItemSubscription/targetMarket/targetMarketCountryCode))) 
                        then (every $node in (//targetMarketCountryCode) 
        				satisfies ($node != 'NON_EU'))         
                         
          						else true()">				          		 
				          		 		
							      		 		<errorMessage>Code value 'NON_EU' was invalidly used.</errorMessage>
							                
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
