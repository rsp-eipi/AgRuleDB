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
      <title>Rule 1409</title>
      <doc:description>If returnableAssetsContainedQuantity is used, 
                       it shall only have a measurementUnitCode of Unit Of Measure Classification 'Count'.
      </doc:description>
      <doc:attribute1>returnableAssetsContainedQuantity</doc:attribute1>
      <rule context="tradeItem">
          <assert test="if (tradeItemInformation/extension/*:packagingInformationModule/packaging/returnableAsset/returnableAssetsContainedQuantity)                         
                        then (every $node in (tradeItemInformation/extension/*:packagingInformationModule/packaging/returnableAsset/returnableAssetsContainedQuantity/@measurementUnitCode)                       
                        satisfies  ( $units/unit[@code=$node]/@type =  'Count' ) )       
          
          					 else true()">
          	 
          	 	
			          	 	       <errorMessage>returnableAssetsContainedQuantity shall only have a measurementUnitCode of Unit Of Measure Classification 'Count'.
			                                     E.g. 'H87' ('Piece') passes as this is of Unit Of Measure Classification 'Count',
			                                     '58' ('Net Kilogram') fails as this is of Unit Of Measure Classification 'Mass'.
			                       </errorMessage>
					           
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
