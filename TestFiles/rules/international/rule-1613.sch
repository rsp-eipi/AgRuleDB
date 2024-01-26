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
      <title>Rule 1613</title>
      <doc:description>If additionalTradeItemClassificationSystemCode equals '76' then additionalTradeItemClassificationCodeValue shall equal ('EU_CLASS_I', 
                       'EU_CLASS_IIA', 'EU_CLASS_IIB', 'EU_CLASS_III', 'EU_CLASS_A', 'EU_CLASS_B', 'EU_CLASS_C', or 'EU_CLASS_D').
      </doc:description>
      <doc:avenant>Modification 3.1.19 Le 24/02/2022</doc:avenant>
      <doc:avenant1>Modif. le 11/04/2022 redmine15425</doc:avenant1>
      <doc:attribute1>targetMarketCountryCode,additionalTradeItemClassificationSystemCode</doc:attribute1>
      <doc:attribute2>additionalTradeItemClassificationCodeValue</doc:attribute2>
      <rule context="additionalTradeItemClassification">
          <assert test="if((ancestor::tradeItem/targetMarket/targetMarketCountryCode =  ('008' , '051' , '031' , '112' , '056' , '070' , '100' , '191' , '196' , '203' , '208' , '233' , '246' , '250' , '268' , '300' , '348' ,
                                                                     '352' , '372' , '376' , '380' , '398' , '417' , '428' , '440' , '442' , '807' , '498' , '499' , '528' , '578' , '616' , '620' , '643' ,
                                                                     '688' , '703' , '705' , '724' , '752' , '792' , '795' , '826' , '804' , '860' )) 
                        and (ancestor::tradeItem/gdsnTradeItemClassification/gpcCategoryCode = $gpc/gpcDP007/gpcDP007Code)                                                                          									 					
        				and (exists (additionalTradeItemClassificationSystemCode)
        				and (additionalTradeItemClassificationSystemCode = '76'))) 
        					then (every $node in (additionalTradeItemClassificationValue/additionalTradeItemClassificationCodeValue) 
        					satisfies ($node = ('EU_CLASS_I', 'EU_CLASS_IIA', 'EU_CLASS_IIB', 'EU_CLASS_III', 'EU_CLASS_A', 'EU_CLASS_B', 'EU_CLASS_C', 'EU_CLASS_D')  )  )           												
        							
				          				 else true()">				          		 
				          		 		
							      		 		<errorMessage>additionalTradeItemClassificationCodeValue is incorrect for additionalTradeItemClassificationSystemCode '76' MDR/IVDR. Please use one of the codes 'EU_CLASS_I', 'EU_CLASS_IIA', 'EU_CLASS_IIB', 'EU_CLASS_III', 'EU_CLASS_A', 'EU_CLASS_B', 'EU_CLASS_C', or 'EU_CLASS_D’.
	                                            </errorMessage>
							                
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
