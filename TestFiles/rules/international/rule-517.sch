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
      <title>Rule 517</title>
       <doc:description>If targetMarketCountryCode not equal to '752' (Sweden) and (Audio Visual Media Product Description Module or Publication Title Rating Module or Audio Visual Media Content Information Module) are used and gpcCategoryCode is equal to '10001137' then audioVisualMediaProductTitle, genreTypeCodeReference, titleRatingCodeReference/Code, titleRatingCodeReference/codeListAgencyCode and gameFormatCode shall be used.</doc:description>
       <doc:attribute1>gpcCategoryCode,targetMarketCountryCode</doc:attribute1>
       <doc:attribute2>audioVisualMediaProductTitle, titleRatingCodeReference, genreTypeCodeReference, gameFormatCode, titleRatingCodeReference/codeListAgencyCode</doc:attribute2>
      <rule context="tradeItem">
          <assert test="if((gdsnTradeItemClassification/gpcCategoryCode = '10001137')          				
                        and ((exists(tradeItemInformation/extension/*:audioVisualMediaProductDescriptionInformationModule))
                        or   (exists(tradeItemInformation/extension/*:publicationTitleRatingModule))
                        or   (exists(tradeItemInformation/extension/*:audioVisualMediaContentInformationModule)))
        				and (targetMarket/targetMarketCountryCode !=  '752'))
                        then (exists(tradeItemInformation/extension/*:audioVisualMediaProductDescriptionInformationModule/audioVisualMediaProductDescription/audioVisualMediaProductTitle)
                        and exists(tradeItemInformation/extension/*:publicationTitleRatingModule/publicationTitleRating/titleRatingCodeReference)
                        and exists(tradeItemInformation/extension/*:audioVisualMediaProductDescriptionInformationModule/audioVisualMediaProductDescription/genreTypeCodeReference) 
                        and exists(tradeItemInformation/extension/*:audioVisualMediaContentInformationModule/audioVisualMediaContentInformation/gameFormatCode)                        
                        and exists(tradeItemInformation/extension/*:publicationTitleRatingModule/publicationTitleRating/titleRatingCodeReference/@codeListAgencyCode) )
          
          			 	  	 else true()">
          			    
          			    		
          			    	   <errorMessage>If (Audio Visual Media Product Description Module or Publication Title Rating Module or Audio Visual Media Content Information Module) are used and gpcCategoryCode is equal to '10001137' then audioVisualMediaProductTitle , genreTypeCodeReference, titleRatingCodeReference/Code, titleRatingCodeReference/codeListAgencyCode  and gameFormatCode shall be used.</errorMessage>
				           
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
