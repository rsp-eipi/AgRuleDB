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
   <let name="gpc" value="doc('../data/data.xml')//data:gpc"/>
   <pattern>
      <title>Rule 1236</title>
      <doc:description>If claimElementCode is used then claimTypeCode SHALL be used.</doc:description>
      <doc:avenant>Modif. 3.1.21 Changed structured rule and error message.</doc:avenant>
      <doc:avenant1>Modif. 3.1.23 Updated Structured Rule and Xpaths based on changes from GDSN 3.1.23 Large release </doc:avenant1>
      <doc:avenant2>Modif.14/04/2023 non applicable sur le marché FR</doc:avenant2>
      <doc:attribute1>claimElementCode</doc:attribute1>
      <doc:attribute2>claimTypeCode</doc:attribute2>
      <rule context="claimDetail">
          <assert test="if(((ancestor::tradeItem/gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP006/gpcDP006Code)
                        or (ancestor::tradeItem/gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP015/gpcDP015Code))
                        and(ancestor::tradeItem/targetMarket/targetMarketCountryCode != '250')                         
                        and exists(claimElementCode)
                        and (claimElementCode != ''))
                        then  exists(claimTypeCode)
                        and (every $node in (claimTypeCode)
                        satisfies  ( $node != '' ) )

			          		 else true()">


			          		 	<errorMessage>You shall populate Claim Type Code (claimTypeCode) because you populated Element Claim Code (claimElementCode).</errorMessage>

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
														<gtin><xsl:value-of select="ancestor::tradeItem/gtin"/></gtin>
														<glnProvider><xsl:value-of select="ancestor::tradeItem/informationProviderOfTradeItem/gln"/></glnProvider>
														<targetMarket><xsl:value-of select="ancestor::tradeItem/targetMarket/targetMarketCountryCode"/></targetMarket>	
														
								</location>	 
	 	  </assert>
      </rule>
   </pattern>
</schema>
