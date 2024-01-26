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
      <title>Rule 1601</title>
      <doc:description>If targetMarketCountryCode equals '528' (Netherlands) or '203' (Czech Republic) and isTradeItemAConsumerUnit equals 'true'  and gpcCategoryCode does not equal ('10000458','10000570','10000686','10000915','10000456','10000457','10000681','10000912','10000922','10000448','10000449','10000450','10000451','10000684','10000908','10000909','10000910','10000474','10000488','10000489','10000685','10000907','10000459','10000682','10000690','10000487','10000525','10000526','10000527','10000528','10000529','10000637','10000638','10000639','10000687','10000688','10000689','10000911','10000500','10000504','10000683','10000846','10000847','10000848','10000849','10000850','10000851','10000852','10000923','10000853','10000854','10000855','10000856','10000857','10000858','10000859','10000860','10000861','10000862','10000914','10000863','10000864','10000865','10000866','10000867','10000868','10000869','10000870','10000871','10000872','10000873','10000874','10000919','10000875','10000876','10000877','10000878','10000879','10000880','10000881','10000882','10000883','10000884','10000916','10000920','10000885','10000886','10000887','10000888','10000889','10000890','10000891','10000892','10000893','10000903','10000904','10000905','10000906','10000894','10000895','10000896','10000897','10000898','10000899','10000900','10000901','10000902','10000921','10002423','10000460','10000461','10000462','10000674','10000838','10000463','10000464','10000675','10000455','10000843','10000452','10000453','10000454','10000648','10000844','10000647','10000673','10005844','10006412','10005845','10000514) then netContent shall be used.
      </doc:description>
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode,isTradeItemAConsumerUnit</doc:attribute1>
      <doc:attribute2>totalNumberOfComponents,numberOfPiecesInSet</doc:attribute2>
      <rule context="tradeItem">
          <assert test="if(    (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code))                                                                          									 					
        					and (not (gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP008/gpcDP008Code)) 
        					and (gdsnTradeItemClassification/gpcCategoryCode != ('10000458', '10000570', '10000686', '10000915', '10000456', '10000457',
        					                                                     '10000681', '10000912', '10000922', '10000448', '10000449', '10000450',
        					                                                     '10000451', '10000684', '10000908', '10000909', '10000910', '10000474',
        					                                                     '10000488', '10000489', '10000685', '10000907', '10000459', '10000682',
        					                                                     '10000690', '10000487', '10000525', '10000526', '10000527', '10000528',
        					                                                     '10000529', '10000637', '10000638', '10000639', '10000687', '10000688',
        					                                                     '10000689', '10000911', '10000500', '10000504', '10000683', '10000846',
        					                                                     '10000847', '10000848', '10000849', '10000850', '10000851', '10000852', 
        					                                                     '10000923', '10000853', '10000854', '10000855', '10000856', '10000857',
        					                                                     '10000858', '10000859', '10000860', '10000861', '10000862', '10000914',
        					                                                     '10000863', '10000864', '10000865', '10000866', '10000867', '10000868',
        					                                                     '10000869', '10000870', '10000871', '10000872', '10000873', '10000874',
        					                                                     '10000919', '10000875', '10000876', '10000877', '10000878', '10000879', 
        					                                                     '10000880', '10000881', '10000882', '10000883', '10000884', '10000916',
        					                                                     '10000920', '10000885', '10000886', '10000887', '10000888', '10000889',
        					                                                     '10000890', '10000891', '10000892', '10000893', '10000903', '10000904',
        					                                                     '10000905', '10000906', '10000894', '10000895', '10000896', '10000897',
        					                                                     '10000898', '10000899', '10000900', '10000901', '10000902', '10000921',
        					                                                     '10002423', '10000460', '10000461', '10000462', '10000674', '10000838',
        					                                                     '10000463', '10000464', '10000675', '10000455', '10000843', '10000452',
        					                                                     '10000453', '10000454', '10000648', '10000844', '10000647', '10000673',
        					                                                     '10005844', '10006412', '10005845','10000514'))
        					and (targetMarket/targetMarketCountryCode = ('528' , '203'))
        					and (isTradeItemAConsumerUnit = 'true'))        					        				
        					then (exists(tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/netContent) 
    					    and (every $node in (tradeItemInformation/extension/*:tradeItemMeasurementsModule/tradeItemMeasurements/netContent) 
        					satisfies ($node &gt; 0 ) ))   
        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>netContent is mandatory for this target market and gpcCategoryCode, if isTradeItemAConsumerUnit equals 'true'.</errorMessage>
							                
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
