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
      <title>Rule 585</title>
	    <doc:description>If targetMarketCountryCode is equal to ('036' (Australia), '348' (Hungary), '554' (New Zealand), '528' (Netherlands), '056' (Belgium) or '442' (Luxembourg))
	                     and quantityOfLayersPerPallet is greater than zero
	                     then quantityOfTradeItemsPerPalletLayer shall be greater than zero.
	    </doc:description>
        <doc:attribute1>targetMarketCountryCode,quantityOfLayersPerPallet</doc:attribute1>
        <doc:attribute2>quantityOfTradeItemsPerPalletLayer</doc:attribute2>
        <rule context="tradeItem">
            <assert test="if ((targetMarket/targetMarketCountryCode = ('036' (:Australia:), '348' (:Hungary:), '554' (:New Zealand:), '528' (:Netherlands:), '056' (:Belgium:), '442' (:Luxembourg:)))                        
        			      and ((exists(tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfLayersPerPallet))
        			      and (tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfLayersPerPallet) &gt; 0))            			              			
            			  then (exists(tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfTradeItemsPerPalletLayer)             			 
            			  and (every $node in (tradeItemInformation/extension/*:tradeItemHierarchyModule/tradeItemHierarchy/quantityOfTradeItemsPerPalletLayer)
            			  satisfies ($node &gt; 0)))            			 
            
		            			  else true()">
		            	 
		            	 	
					            	   <errorMessage>If quantityOfLayersPerPallet is greater than zero, then quantityOfTradeItemsPerPalletLayer shall be greater than zero for this target market.</errorMessage>
									                
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
