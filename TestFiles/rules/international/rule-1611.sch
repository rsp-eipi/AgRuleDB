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
      <title>Rule 1611</title>
      <doc:description>If targetMarketCountryCode equals ‘250’ (France)) and uniformResourceIdentifier is used, 
                       and referencedFileTypeCode equals (‘VIDEO’ or ‘360_DEGREE_IMAGE’ or ‘MOBILE_DEVICE_IMAGE’ or ‘OUT_OF_PACKAGE_IMAGE’ 
                       or ‘PRODUCT_IMAGE’ or ‘PRODUCT_LABEL_IMAGE’ or ‘TRADE_ITEM_IMAGE_WITH_DIMENSIONS’)  then fileEffectiveStartDateTime shall  be used.
      </doc:description>
      <doc:attribute1>targetMarketCountryCode,uniformResourceIdentifier,referencedFileTypeCode</doc:attribute1>
      <doc:attribute2>fileEffectiveStartDateTime</doc:attribute2>
      <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode =  ( '250'(: France :) ))         									 					
        					and (exists (tradeItemInformation/extension/*:referencedFileDetailInformationModule/referencedFileHeader/uniformResourceIdentifier)
        					and (tradeItemInformation/extension/*:referencedFileDetailInformationModule/referencedFileHeader/referencedFileTypeCode =
        					('VIDEO' , '360_DEGREE_IMAGE' , 'MOBILE_DEVICE_IMAGE' , 'OUT_OF_PACKAGE_IMAGE' , 'PRODUCT_IMAGE' , 'PRODUCT_LABEL_IMAGE' , 'TRADE_ITEM_IMAGE_WITH_DIMENSIONS'))))  
        					then (exists(tradeItemInformation/extension/*:referencedFileDetailInformationModule/referencedFileHeader) 
        					and (every $node in (tradeItemInformation/extension/*:referencedFileDetailInformationModule/referencedFileHeader) 
        					satisfies (exists($node/fileEffectiveStartDateTime)) ))          					         												
        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>fileEffectiveStartDateTime is missing.</errorMessage>
							                
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
