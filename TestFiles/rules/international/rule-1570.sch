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
   <let name="gpc" value="doc('../data/data.xml')//data:gpc"/>
   <pattern>
      <title>Rule 1570</title>
      <doc:description>If targetMarketCountryCode equals ('008' (Albania), '051' (Armenia), '031' (Azerbaijan), '112' (Belarus), '056' (Belgium), '070' (Bosnia-Herzegovina), '100' (Bulgaria), 
                       '191' (Croatia), '196' (Cyprus), '203' (Czech Republic), '208' (Denmark), '233' (Estonia), '246' (Finland), '250' (France), '268' (Georgia), '300' (Greece), '348' (Hungary),
                       '352' (Iceland), '372' (Ireland), '376' (Israel), '380' (Italy), '398' (Kazakhstan), '417' (Kyrgyzstan), '428' (Latvia), '440' (Lithuania), '442' (Luxembourg), '807' (Macedonia), 
                       '498' (Moldova), '499' (Montenegro), '528' (Netherlands), '578' (Norway), '616' (Poland), '620' (Portugal), '642' (Romania), '643' (Russia), '688' (Serbia), '703' (Slovakia),
                       '705' (Slovenia), '724' (Spain), '752' (Sweden), '792' (Turkey), '795' (Turkmenistan), '826' (United Kingdom), '804' (Ukraine), or '860' (Uzbekistan))
                       and GDSNTradeItemClassification/gpcCategoryCode belongs to any of the GPC families ('50100000', '50250000', '50260000', '50270000', '50290000', '50310000', '50320000', '50350000', 
                       '50360000', '50370000' or '50380000') and tradeItemFarmingAndProcessing/growingMethodCode is used, 
                       then tradeItemFarmingAndProcessing/growingMethodCode SHALL equal ('CONVENTIONAL', 'FIELD_GROWN', 'GREENHOUSE', 'HYDROPONIC', 'INTEGRATED_PEST_MANAGEMENT', 'ORGANIC', 'SHADE_GROWN', or 'WILD').
      </doc:description>
      <doc:avenant>Modification 3.1.19 Le 24/02/2022</doc:avenant>
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode,growingMethodCode</doc:attribute1>
      <doc:attribute2>growingMethodCode</doc:attribute2>
      <rule context="tradeItem">
          <assert test="if((targetMarket/targetMarketCountryCode =  ('008' , '051' , '031' , '112' , '056' , '070' , '100' , '191' , '196' , '203' , '208' , '233' , '246' , '250' , '268' , '300' , '348' ,
                                                                     '352' , '372' , '376' , '380' , '398' , '417' , '428' , '440' , '442' , '807' , '498' , '499' , '528' , '578' , '616' , '620' , '642', '643' ,
                                                                     '688' , '703' , '705' , '724' , '752' , '792' , '795' , '826' , '804' , '860' )) 
                            and (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcRule1570/gpcRule1570Code)) 	       					  					
        					then (every $node in (tradeItemInformation/extension/*:farmingAndProcessingInformationModule/tradeItemFarmingAndProcessing/growingMethodCode) 
        					satisfies ($node = ('CONVENTIONAL', 'FIELD_GROWN', 'GREENHOUSE', 'HYDROPONIC', 'INTEGRATED_PEST_MANAGEMENT', 'ORGANIC', 'SHADE_GROWN' , 'WILD')))              												
        							
				          				 else true()">				          		 
				          		 		        <targetMarketCountryCode><xsl:value-of select="targetMarket/targetMarketCountryCode"/></targetMarketCountryCode>	
				          		 				<gpc><xsl:value-of select="gdsnTradeItemClassification/gpcCategoryCode"/></gpc>	
				          		 				<growingMethodCode><xsl:value-of select="tradeItemInformation/extension/*:farmingAndProcessingInformationModule/tradeItemFarmingAndProcessing/growingMethodCode"/></growingMethodCode>	
				          		 				 
							      		 		<errorMessage>For Country of Sale Code , the Growing Method Code is not applicable to fresh fruits and vegetables for Global Product Category Code.</errorMessage>
							                
								                <location>
														<!-- Fichier SDBH -->
														<messageId><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:DocumentIdentification/sh:InstanceIdentifier"/></messageId>
														<messageOwner><xsl:value-of select="/*/sh:StandardBusinessDocumentHeader/sh:Sender/sh:Identifier"/></messageOwner>
																			#
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
