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
      <title>Rule 1062</title>
       <doc:description>If class NonPackagedSizeDimension is used then either descriptiveSizeDimension or sizeDimension shall be used.</doc:description>
       <doc:avenant>Modif. 3.1.23  Updated Xpaths based on changes from GDSN 3.1.23 Large release</doc:avenant>
       <doc:avenant1>Modif. 3.1.24  Validation 1062 need to be updated to  allow providing size LCL without providing value for sizeDimension or descriptiveSizeDimension. </doc:avenant1>
       <doc:attribute1>NonPackagedSizeDimension/descriptiveSizeDimension</doc:attribute1>
       <doc:attribute2>NonPackagedSizeDimension/sizeDimension</doc:attribute2>
       <rule context="tradeItem/tradeItemInformation/extension/*:tradeItemSizeModule">
           <assert test="if (nonPackagedSizeDimension) 
           				 	then not((empty(nonPackagedSizeDimension/descriptiveSizeDimension)))
           				      or not((empty(nonPackagedSizeDimension/sizeDimension)))
           				      or not((empty(nonPackagedSizeDimension/sizeCode)))
           
           	 else true()">
           	 
           	 	
           	 	<errorMessage>If class NonPackagedSizeDimension is used then descriptiveSizeDimension, sizeDimension or sizeCode shall be used.</errorMessage>
           	 	
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
