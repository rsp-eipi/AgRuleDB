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
      <title>Rule FR_130</title>
       <doc:description>If one iteration of targetMarketCountryCode equals '250' (France) then at least one level of the hierarchy SHALL have isTradeItemAnOrderableUnit equals 'true'.</doc:description>
       <doc:attribute1>targetMarketCountryCode</doc:attribute1>
       <doc:attribute2>isTradeItemAnOrderableUnit</doc:attribute2>
       <rule context="*:catalogueItemNotification">
            <assert test="if (catalogueItem/tradeItem/targetMarket/targetMarketCountryCode ='250'  )
                          then  (some $node in (//isTradeItemAnOrderableUnit)
                          satisfies ( $node = 'true'  ) )

            				  else true()">


            			  			<errorMessage>Pour le marché cible France, pour une hiérarchie logistique publiée, au moins une des fiches-produits doit être déclarée en tant qu'unité commandable "isTradeItemAnorderableUnit = true".</errorMessage>

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
