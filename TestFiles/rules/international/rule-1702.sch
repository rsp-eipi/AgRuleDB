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
      <title>Rule 1702</title>
      <doc:description>If (targetMarketcountrycode = '008' (Albania), '051' (Armenia), '031' (Azerbaijan), '040' (Austria), '112' (Belarus), '056' (Belgium), '070' (Bosnia-Herzegovina), '100' (Bulgaria), '191' (Croatia), '196' (Cyprus), '203' (Czech Republic), '208' (Denmark), '233' (Estonia), '246' (Finland), '250' (France), '276' (Germany), '268' (Georgia), '300' (Greece), '348' (Hungary), '352' (Iceland), '372' (Ireland), '376' (Israel), '380' (Italy), '398' (Kazakstan), '417' (Kyrgyzstan), '428' (Latvia), '440' (Lithuania), '442' (Luxembourg), '807' (Macedonia), '498' (Moldova), '499' (Montenegro), '528' (Netherlands), '578' (Norway), '616' (Poland), '620' (Portugal), '642' (Romania), '643' (Russia), '688' (Serbia), '703' (Slovakia), '705' (Slovenia),  '756' (Switzerland), '792' (Turkey), '795' (Turkmenistan), '826' (United Kingdom), '804' (Ukraine) or '860' (Uzbekistan)) and If catchAreaCode is used and PlaceOfItemActivityModule/../productActivityTypeCode equals 'CATCH_ZONE', then catchAreaCode shall equal PlaceOfItemActivityModule/../productActivityRegionZoneCodeReference/enumerationValueInformation/enumerationValue
      </doc:description>
      <doc:attribute1>targetMarketcountrycode,catchAreaCode,productActivityTypeCode</doc:attribute1>      
      <rule context="tradeItem">
		  <assert test="if ((targetMarket/targetMarketCountryCode =  ('008' (: Albania :), '051' (: Armenia :), '031' (: Azerbaijan :), '040' (: Austria :), '112' (: Belarus :), '056' (: Belgium :),
		                                                           '070' (: Bosnia-Herzegovina :), '100' (: Bulgaria :), '191' (: Croatia :), '196' (: Cyprus :), '203' (: Czech Republic :),
		                                                           '208' (: Denmark :), '233' (: Estonia :), '246' (: Finland :), '250' (: France :), '276' (: Germany :), '268' (: Georgia :), 
		                                                           '300' (: Greece :), '348' (: Hungary :), '352' (: Iceland :), '372' (: Ireland :), '376' (: Israel :), '380' (: Italy :),
		                                                           '398' (: Kazakstan :), '417' (: Kyrgyzstan :), '428' (: Latvia :), '440' (: Lithuania :), '442' (: Luxembourg :),
		                                                           '807' (: Macedonia :), '498' (: Moldova :), '499' (: Montenegro :), '528' (: Netherlands :), '578' (: Norway :),
		                                                           '616' (: Poland :), '620' (: Portugal :), '642' (: Romania :), '643' (: Russia :), '688' (: Serbia :), '703' (: Slovakia :),
		                                                           '705' (: Slovenia :),  '756' (: Switzerland :), '792' (: Turkey :), '795' (: Turkmenistan :), '826' (: United Kingdom :),
		                                                           '804' (: Ukraine :) , '860' (: Uzbekistan :))) 
		                and ( exists(tradeItemInformation/extension/*:dairyFishMeatPoultryItemModule/dairyFishMeatPoultryInformation/fishReportingInformation/fishCatchInformation/catchAreaCode))
		                and (tradeItemInformation/extension/*:placeOfItemActivityModule/placeOfProductActivity/productActivityDetails/productActivityTypeCode = 'CATCH_ZONE'))
		                then (every $node in (tradeItemInformation/extension/*:dairyFishMeatPoultryItemModule/dairyFishMeatPoultryInformation/fishReportingInformation/fishCatchInformation/catchAreaCode)
		                satisfies ($node = (tradeItemInformation/extension/*:placeOfItemActivityModule/placeOfProductActivity/productActivityDetails/productActivityRegionZoneCodeReference/enumerationValueInformation/enumerationValue) ) )          							
        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>If catchAreaCode is used and PlaceOfItemActivityModule/../productActivityTypeCode equals 'CATCH_ZONE', then catchAreaCode shall equal PlaceOfItemActivityModule/../productActivityRegionZoneCodeReference/enumerationValueInformation/enumerationValue for the following countries: '008' (Albania), '051' (Armenia), '031' (Azerbaijan), '040' (Austria), '112' (Belarus), '056' (Belgium), '070' (Bosnia-Herzegovina), '100' (Bulgaria), '191' (Croatia), '196' (Cyprus), '203' (Czech Republic), '208' (Denmark), '233' (Estonia), '246' (Finland), '250' (France), '276' (Germany), '268' (Georgia), '300' (Greece), '348' (Hungary), '352' (Iceland), '372' (Ireland), '376' (Israel), '380' (Italy), '398' (Kazakstan), '417' (Kyrgyzstan), '428' (Latvia), '440' (Lithuania), '442' (Luxembourg), '807' (Macedonia), '498' (Moldova), '499' (Montenegro), '528' (Netherlands), '578' (Norway), '616' (Poland), '620' (Portugal), '642' (Romania), '643' (Russia), '688' (Serbia), '703' (Slovakia), '705' (Slovenia),  '756' (Switzerland), '792' (Turkey), '795' (Turkmenistan), '826' (United Kingdom), '804' (Ukraine),  '860' (Uzbekistan)</errorMessage>
							                
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
