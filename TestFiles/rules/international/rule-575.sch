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
   <let name="gpc" value="doc('../data/data.xml')//data:gpc"/>
   <pattern>
      <title>Rule 575</title>
       <doc:description>If  targetMarketCountryCode equals ('528' (Netherlands) or '246' (Finland)) and isTradeItemAConsumerUnit equals 'true' and gpcCategoryCode is not in GPC Segment ' 51000000' then tradeItem/gtin SHALL not begin with values "1" through "9".</doc:description>
       <doc:avenant>Modif. 3.1.23 Changed Structured Rule, Error Message, Target Market Scope and Example of Data that will FAIL/PASS</doc:avenant>
       <doc:attribute1>TradeItemInformation/isTradeItemAConsumerUnit</doc:attribute1>
       <doc:attribute2>TradeItem/generalization/TradeItemIdentification/gtin</doc:attribute2>
      <doc:attribute3>TradeItemClassification/gpcCategoryCode</doc:attribute3>
      <rule context="tradeItem">
          <assert test="if ((targetMarket/targetMarketCountryCode = ('528'(: Netherlands :) , '246'(: Finland :) ))
                        and (isTradeItemAConsumerUnit = 'true')  
                        and not(gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcHealthcareList/gpcHealthcareCode)) 
                        then  exists(gtin) and (starts-with(gtin,'0'))
          
          			    else true()">
          			    
          			    					<targetMarketCountryCode><xsl:value-of select="targetMarket/targetMarketCountryCode"/></targetMarketCountryCode>	
				          		 			<gtin><xsl:value-of select="gtin"/></gtin>	 	
          			    				   <errorMessage>For Country Of Sale Code (#targetMarketCountryCode#), if the Global Product Category Code of the product is not one of the brick codes in segment '51000000' (Healthcare) and Consumer Unit Indicator
 (isTradeItemAConsumerUnit) equals 'true', then the GTIN (#gtin#) SHALL not begin with values "1" through "9".</errorMessage>
				           
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
