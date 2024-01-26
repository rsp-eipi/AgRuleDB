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
      <title>Rule 437</title>
       <doc:description>If dangerousGoodsRegulationCode is equal to 'ADR' and classOfDangerousGoods is not empty then classOfDangerousGoods must equal ('1', '2', '3', '4.1', '4.2', '4.3', '5.1', '5.2', '6.1', '6.2', '7', '8'or '9').</doc:description>
       <doc:attribute1>dangerousGoodsRegulationCode, hazardousInformationDetail/classOfDangerousGoods</doc:attribute1>
       <rule context="hazardousInformationHeader">
           <assert test="if((dangerousGoodsRegulationCode = 'ADR') and (hazardousInformationDetail/classOfDangerousGoods)) then (every $node in (hazardousInformationDetail/classOfDangerousGoods) satisfies ($node = ('1', '2', '3', '4.1', '4.2', '4.3', '5.1', '5.2', '6.1', '6.2', '7', '8','9'))) 
           		
           			     else true()">
           			     
           			     		
           			     		<errorMessage>If classOfDangerousGoods is populated and dangerousGoodsRegulationCode equals 'ADR', then classOfDangerousGoods must be one of the following values: '1', '2', '3', '4.1', '4.2', '4.3', '5.1', '5.2', '6.1', '6.2', '7', '8', '9'.</errorMessage>   
          	
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
