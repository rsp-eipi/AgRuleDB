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
   		<title>Rule FR_X02</title>
       	<doc:description>Fake GTIN are not allowed</doc:description>
      	<rule context="tradeItem">
			 <assert test="not(gtin = ('44444444444442', '00000000000000','01111111111116','11111111111113','22222222222226','33333333333339','55555555555555','66666666666668','77777777777771','88888888888884','99999999999997')) and
			 not(nextLowerLevelTradeItemInformation/childTradeItem/gtin = ('44444444444442', '00000000000000','01111111111116','11111111111113','22222222222226','33333333333339','55555555555555','66666666666668','77777777777771','88888888888884','99999999999997'))">
          	 
	 	     <errorMessage>Les faux GTIN ne sont pas autorisés</errorMessage>
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
