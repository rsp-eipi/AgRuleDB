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
      <title>Rule 1770</title>      
      <doc:description>If targetMarketCountryCode equals ('008' (Albania), '051' (Armenia), '031' (Azerbaijan), '040' (Austria), '112' (Belarus), '056' (Belgium), '070' (Bosnia-Herzegovina), '100' (Bulgaria), 
                                                          '191' (Croatia), '196' (Cyprus), '203' (Czech Republic), '208' (Denmark), '233' (Estonia), '246' (Finland), '250' (France), '276' (Germany), '268' (Georgia),
                                                          '300' (Greece), '348' (Hungary), '352' (Iceland), '372' (Ireland), '376' (Israel), '380' (Italy), '398' (Kazakhstan), '417' (Kyrgyzstan), '428' (Latvia),
                                                          '440' (Lithuania), '442' (Luxembourg), '807' (Macedonia), '498' (Moldova), '499' (Montenegro), '528' (Netherlands), '578' (Norway), '616' (Poland),
                                                          '620' (Portugal), '642' (Romania), '643' (Russia), '688' (Serbia), '703' (Slovakia), '705' (Slovenia), '752' (Sweden), '756' (Switzerland), '792' (Turkey),
                                                          '795' (Turkmenistan), '826' (United Kingdom), '804' (Ukraine), or '860' (Uzbekistan))
                                                          and (nutrientBasisQuantity equals 100 GRM, 100 MLT, 1000 MLT or 1 LTR)
                                                          and one instance of nutrientTypeCode equals 'SUGAR-',
                                                          then there SHALL be also one instance of nutrientTypeCode with the value 'CHOAVL' within the same nutrientHeader.
      </doc:description>    
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode,nutrientTypeCode,nutrientBasisQuantity,dailyValueIntakePercent</doc:attribute1> 
      <doc:attribute2>dailyValueIntakeReference</doc:attribute2>       
   	  <rule context="nutrientHeader">
		    <assert test="if((ancestor::tradeItem/targetMarket/targetMarketCountryCode =  ('008' , '051' , '031' , '040', '112' , '056' , '070' , '100' , '191' , '196' , '203' , '233' , '246' , '250' , '268' , '300' , '348' ,
                                                                     '352' , '372' , '376' , '380' , '398' , '417' , '428' , '440' , '442' , '807' , '498' , '499' , '528' , '578' , '616' , '620' , '642', '643' ,
                                                                     '688' , '703' , '705' , '752' , '756', '792' , '795' , '826' , '804' , '860', '208' , '276' )) 
                            and (not (ancestor::tradeItem/gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code))                                                                          									 					
        				    and (not (ancestor::tradeItem/gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP008/gpcDP008Code))         				    
        				    and ((exists(nutrientBasisQuantity[.='100']/@measurementUnitCode[.='GRM']))	
        				    or (exists(nutrientBasisQuantity[.='100']/@measurementUnitCode[.='MLT']))
        				    or (exists(nutrientBasisQuantity[.='1000']/@measurementUnitCode[.='MLT']))	
        				    or (exists(nutrientBasisQuantity[.='1']/@measurementUnitCode[.='LTR'])))								 					
        					and (nutrientDetail/nutrientTypeCode = 'SUGAR-'))         					    					
        					then (some $node in (nutrientDetail) 
        					satisfies ($node/nutrientTypeCode = 'CHOAVL'))                       												
        							
				          				 else true()">					          		 
				          		 		
							      		 		<errorMessage>If nutrient type code is filled out with 'SUGAR-’, then there shall be another nutrient type code with value 'CHOAVL' for the legally required nutritional table within the same group, for the target market.</errorMessage>
							                
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
