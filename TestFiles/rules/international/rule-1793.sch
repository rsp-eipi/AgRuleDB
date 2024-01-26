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
      <title>Rule 1793</title>      
      <doc:description>If one instance of additionalTradeItemClassificationSystemCode equals '76' then all other instances of additionalTradeItemClassificationSystemCode SHALL NOT equal '76’.
      </doc:description>    
      <doc:attribute1>additionalTradeItemClassificationSystemCode</doc:attribute1>           
   	  <rule context="tradeItem">
		    <assert test="if(count(gdsnTradeItemClassification/additionalTradeItemClassification) &gt; 1)
		            then ((count(distinct-values(gdsnTradeItemClassification/additionalTradeItemClassification/additionalTradeItemClassificationSystemCode[. = '76']))
		            = count((gdsnTradeItemClassification/additionalTradeItemClassification[exists(./additionalTradeItemClassificationSystemCode[. = '76'])])) ))

						else true()">
				            				          		 
				          		 		
							      		 		<errorMessage>The attribute additionalTradeItemClassificationSystemCode with value ‘76’ EU Regulation (MDR/IVDR) Risk class is not repeatable.</errorMessage>
							                
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
