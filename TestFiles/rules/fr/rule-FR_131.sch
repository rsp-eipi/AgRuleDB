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
      <title>Rule FR_131</title>
        <doc:description>If one iteration of targetMarketCountryCode equals '250' (France) and if a case is homogeneous "quantityOfChildren = 1", then it SHALL be declared with "tradeItemUnitDescriptorCode = CASE" and "isTradeItemADisplayUnit = true".</doc:description>
       <doc:attribute1>targetMarketCountryCode, isTradeItemADisplayUnit, quantityOfChildren</doc:attribute1>
       <doc:attribute2>tradeItemUnitDescriptorCode</doc:attribute2>
       <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode = '250')
         					and (nextLowerLevelTradeItemInformation/quantityOfChildren =  1)
         					and (displayUnitInformation/isTradeItemADisplayUnit  = 'TRUE')
         					and (tradeItemUnitDescriptorCode = 'DISPLAY_SHIPPER'))          				         					  					
          					then (false)
          
          						else true()">
          	 
          	 	
		          	 	       <errorMessage>Pour le marché cible France, si le carton présentoir est homogène "quantityOfChildren = 1" alors il doit être déclaré comme CASE "tradeItemUnitDescriptorCode = CASE" et comme présentoir "isTradeItemADisplayUnit = true"</errorMessage>
				           
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
