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
        <title>Rule 1720</title>
        <doc:description>If TargetMarket/targetMarketCountryCode is equal to ('036' (Australia), '554' (New Zealand), '250' (France), or '752' (Sweden)) then isTradeItemAnInvoiceUnit SHALL be 'true' for at least one trade item in a Catalogue Item Notification Message.</doc:description>
        <doc:attribute1>tradeItem/targetMarket/targetMarketCountryCode</doc:attribute1>
        <doc:attribute2>tradeItem/isTradeItemAnInvoiceUnit</doc:attribute2>
        <rule context="*:catalogueItemNotification">
            <assert test="if ( (catalogueItem/tradeItem/targetMarket/targetMarketCountryCode =  ('036' (:Australia:), '554' (: Austria :), '250' (: France :), '752' (: Sweden :) ) ) )
                          then  (some $node in (//isTradeItemAnInvoiceUnit)
                          satisfies ( $node = 'true'  ) )

            				  else true()">


            			  			<errorMessage>One or more of the GTINs in each hierarchy must be marked as an INVOICE UNIT.</errorMessage>

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
