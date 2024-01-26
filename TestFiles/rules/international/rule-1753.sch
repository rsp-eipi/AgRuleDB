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
      <title>Rule 1753</title>      
      <doc:description>If targetMarketCountryCode equals ('008' (Albania), '051' (Armenia), '031' (Azerbaijan), '040' (Austria), '112' (Belarus), '056' (Belgium), '070' (Bosnia-Herzegovina), '100' (Bulgaria), '191' (Croatia), '196' (Cyprus), 
                                                          '203' (Czech Republic), '233' (Estonia), '246' (Finland), '250' (France), '276' (Germany), '268' (Georgia), '300' (Greece), '348' (Hungary), '352' (Iceland), '372' (Ireland),
                                                          '376' (Israel), '380' (Italy), '398' (Kazakhstan), '417' (Kyrgyzstan), '428' (Latvia), '440' (Lithuania), '442' (Luxembourg), '807' (Macedonia), '498' (Moldova), 
                                                          '499' (Montenegro), '528' (Netherlands), '578' (Norway), '616' (Poland), '620' (Portugal), '642' (Romania), '643' (Russia), '688' (Serbia), '703' (Slovakia), 
                                                          '705' (Slovenia), '752' (Sweden), '756' (Switzerland), '792' (Turkey), '795' (Turkmenistan), '826' (United Kingdom), '804' (Ukraine), or '860' (Uzbekistan))
                                                           and preparationStateCode is used, then preparationStateCode SHALL equal at least one iteration equal to 'PREPARED' or 'UNPREPARED'.
      </doc:description>    
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode</doc:attribute1> 
      <doc:attribute2>nutrientHeader/preparationStateCode</doc:attribute2>       
   	  <rule context="tradeItem">
		   <assert test="if((targetMarket/targetMarketCountryCode =  ('008' , '051' , '031' , '040', '112' , '056' , '070' , '100' , '191' , '196' , '203' , '233' , '246' , '250' , '268' , '276', '300' , '348' ,
                                                                     '352' , '372' , '376' , '380' , '398' , '417' , '428' , '440' , '442' , '807' , '498' , '499' , '528' , '578' , '616' , '620' , '642', '643' ,
                                                                     '688' , '703' , '705' , '752' , '756', '792' , '795' , '826' , '804' , '860' )) 
                            and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code))                                                                          									 					
        			    	and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP008/gpcDP008Code)) 	       									 					
        					and (exists (tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader)))        					
        					then (exists(tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/preparationStateCode) 
        					and (some $node in (tradeItemInformation/extension/*:nutritionalInformationModule/nutrientHeader/preparationStateCode) 
        					satisfies ($node = ('PREPARED', 'UNPREPARED'))))                 												
        							
				          				 else true()">					          		 
				          		 		
							      		 		<errorMessage>Preparation state code must contain at least one value of 'PREPARED' or 'UNPREPARED' for the target market.</errorMessage>
							                
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
