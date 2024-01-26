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
      <title>Rule 569</title>
      <doc:description>If targetMarketCountryCode does not equal ('756' (Switzerland), '276' (Germany), '040' (Austria), '528' (Netherlands), '056' (Belgium), '442' (Luxembourg), 203 (Czech Republic), or '250' (France))
                       and uniformResourceIdentifier is used and referencedFileTypeCode equals 'PRODUCT_IMAGE' then fileFormatName SHALL be used.
      </doc:description>
      <doc:avenant>Modification 3.1.19 Le 21/02/2022</doc:avenant>
      <doc:attribute1>ReferencedFileInformation/fileFormatName</doc:attribute1>   
      <doc:attribute2> ReferencedFileInformation/uniformResourceIdentifier</doc:attribute2>
      <doc:attribute3>ReferencedFileInformation/ReferencedFileTypeCode</doc:attribute3>
      <rule context="referencedFileHeader">
         <assert test="if (ancestor::tradeItem/targetMarket/targetMarketCountryCode =  ('756'(: Switzerland :) , '276'(: Germany :), '040'(: Austria :) , '528'(: Netherlands :), '056'(: Belgium :) , '442'(: Belgium :), '203'(: Czech Republic :) , '250'(: France :) ) 
                       and (uniformResourceIdentifier != '')
                       and (referencedFileTypeCode = 'PRODUCT_IMAGE') )
                       then  (exists(fileFormatName) 
                       and (every $node in (fileFormatName) 
                       satisfies ( $node != '') ) )
         
         			   else true()">
         			   
         			   				  	   <targetMarketCountryCode><xsl:value-of select="ancestor::tradeItem/targetMarket/targetMarketCountryCode"/></targetMarketCountryCode>		
         			   					   <errorMessage>For this target market (#targetMarketCountryCode#), fileFormatName is mandatory, if uniformResourceIdentifier is used and referencedFileTypeCode equals the value 'PRODUCT_IMAGE'.</errorMessage>
				           
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
