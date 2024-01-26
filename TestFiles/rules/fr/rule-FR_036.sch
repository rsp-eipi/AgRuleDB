<?xml version="1.0" encoding="UTF-8"?>
<schema xmlns="http://purl.oclc.org/dsdl/schematron" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
        xmlns:doc="http://doc"
        queryBinding="xslt2">
   <ns uri="urn:gs1:gdsn:catalogue_item_confirmation:xsd:3"
       prefix="catalogue_item_confirmation"/>
   <ns uri="http://www.unece.org/cefact/namespaces/StandardBusinessDocumentHeader"
       prefix="sh"/>
   <ns uri="http://data" prefix="data"/>
   <let name="units" value="doc('../data/data.xml')//data:units"/>
   <pattern>
      <title>Rule FR_036</title>
       <doc:description>If isTradeItemAConsumerUnit equal true and tradeItemUnitDescriptorCode equal BASE_UNIT_OR_EACH|PACK_OR_INNER_PACK then isTradeItemADisplayUnit must equal FALSE</doc:description>
      <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode =  ('249'(: France :) , '250'(: France :) ))and (gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (gdsnTradeItemClassification/gpcCategoryCode!='10005845') and (gdsnTradeItemClassification/gpcCategoryCode!='10005844') and (gdsnTradeItemClassification/gpcCategoryCode!='10005845') and (isTradeItemAConsumerUnit = 'true') and (tradeItemUnitDescriptorCode = ('BASE_UNIT_OR_EACH','PACK_OR_INNER_PACK'))) then  exists(displayUnitInformation/isTradeItemADisplayUnit) and (every $node in (displayUnitInformation/isTradeItemADisplayUnit) satisfies $node = 'FALSE')
          
          	 else true()">
          	 	
          	 	
          	 	   <errorMessage>Les unités consommateurs 'BASE_UNIT_OR_EACH' ou 'PACK_OR_INNER_PACK' ne peuvent pas être déclarées en tant que présentoir garni. Par conséquent, pour ces niveaux logistiques, l'indicateur isTradeItemADisplayUnit « présentoir garni » doit être renseigné et doit avoir la valeur « FALSE ».</errorMessage>
	           
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
