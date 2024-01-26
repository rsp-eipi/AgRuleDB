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
      <title>Rule 1773</title>      
      <doc:description>If targetMarketCountryCode equals '528' (Netherlands) and the value of gpcCategoryCode equals one of the bricks in GPC families ('50250000', '50260000' or '50350000')
                       and packagingTypeCode is not equal to 'X11' or 'NE',
                       then isPackagingMarkedReturnable SHALL be used.
      </doc:description>    
      <doc:attribute1>targetMarketCountryCode,gpcCategoryCode</doc:attribute1> 
      <doc:attribute2>packagingTypeCode, isPackagingMarkedReturnable</doc:attribute2>       
   	  <rule context="tradeItem">
		    <assert test="if((targetMarket/targetMarketCountryCode =  '528') 
                            and (gdsnTradeItemClassification/gpcCategoryCode = ('10005876' , '10005877' , '10005878' , '10005879' , '10005880' , '10005881' , '10005882' , '10005883' ,
                                                                                '10005884' , '10005885' , '10005886' , '10005887' , '10005888' , '10005889' , '10005895' , '10005896' , '10005897' ,
                                                                                '10005898' , '10005899' , '10005900' , '10005901' , '10005902' , '10005903' , '10005905' , '10005907' , '10005908' , 
                                                                                '10005909' , '10005910' , '10005911' , '10005912' , '10005913' , '10005914' , '10005915' , '10005916' , '10005917' , 
                                                                                '10005918' , '10005921' , '10005922' , '10005923' , '10005924' , '10005925' , '10005926' , '10005927' , '10005928' , 
                                                                                '10005929' , '10005930' , '10005932' , '10005934' , '10005935' , '10005937' , '10005938' , '10005939' , '10058940' ,
                                                                                '10005941' , '10005942' , '10005946' , '10005948' , '10005949' , '10005950' , '10005951' , '10005952' , '10005953' , 
                                                                                '10005954' , '10005955' , '10005956' , '10005957' , '10005959' , '10005960' , '10005961' , '10005963' , '10005964' , 
                                                                                '10005965' , '10005966' , '10005967' , '10005968' , '10005969' , '10005970' , '10005971' , '10005972' , '10005973' , 
                                                                                '10005974' , '10006160' , '10006167' , '10006168' , '10006169' , '10006172' , '10006173' , '10006193' , '10006194' ,
                                                                                '10006338' , '10006343' , '10006345' , '10006346' , '10006347' , '10006354' , '10006414' , '10006415' , '10006429' , 
                                                                                '10006430' , '10006431' , '10006432' , '10006433' , '10006434' , '10006435' , '10006436' , '10006437' , '10006438' , 
                                                                                '10006439' , '10006440' , '10006441' , '10006442' , '10006443' , '10006759' , '10006831' , '10006832' , '10006866' , 
                                                                                '10008027' , '10005976' , '10005979' , '10005980' , '10005981' , '10005982' , '10005984' , '10005985' , '10058986' ,
                                                                                '10005987' , '10005988' , '10005996' , '10005997' , '10005999' , '10006000' , '10006003' , '10006004' , '10006005' , 
                                                                                '10006006' , '10006007' , '10006009' , '10006014' , '10006015' , '10006031' , '10006032' , '10006033' , '10006034' , 
                                                                                '10006035' , '10006036' , '10006037' , '10006038' , '10006040' , '10006041' , '10006044' , '10006045' , '10006046' , 
                                                                                '10006047' , '10006049' , '10006050' , '10006051' , '10006052' , '10006053' , '10006054' , '10006055' , '10006056' , 
                                                                                '10006057' , '10006058' , '10006059' , '10006060' , '10006061' , '10006063' , '10006065' , '10006066' , '10006068' , 
                                                                                '10006070' , '10006071' , '10006072' , '10006074' , '10006075' , '10006076' , '10006077' , '10006078' , '10006100' , 
                                                                                '10006102' , '10006104' , '10006107' , '10006108' , '10006109' , '10006110' , '10006111' , '10006112' , '10006113' , 
                                                                                '10006114' , '10006115' , '10006116' , '10006117' , '10006118' , '10006119' , '10006120' , '10006121' , '10006122' , 
                                                                                '10006123' , '10006124' , '10006125' , '10006126' , '10006127' , '10006128' , '10006129' , '10006130' , '10006131' , 
                                                                                '10006133' , '10006134' , '10006135' , '10006136' , '10006137' , '10006143' , '10006144' , '10006145' , '10006146' , 
                                                                                '10006147' , '10006148' , '10006157' , '10006158' , '10006159' , '10006161' , '10006162' , '10006163' , '10006164' , 
                                                                                '10006165' , '10006166' , '10006171' , '10006190' , '10006191' , '10006192' , '10006195' , '10006196' , '10006197' , 
                                                                                '10006198' , '10006199' , '10006200' , '10006259' , '10006260' , '10006261' , '10006262' , '10006263' , '10006264' , 
                                                                                '10006265' , '10006266' , '10006270' , '10006271' , '10006272' , '10006334' , '10006335' , '10006336' , '10006337' , 
                                                                                '10006339' , '10006340' , '10006341' , '10006342' , '10006344' , '10006348' , '10006349' , '10006350' , '10006351' ,
                                                                                '10006353' , '10006355' , '10006356' , '10006357' , '10006358' , '10006359' , '10006360' , '10006361' , '10006362' ,
                                                                                '10006363' , '10006364' , '10006365' , '10006366' , '10006367' , '10006368' , '10006369' , '10006370' , '10006371' ,
                                                                                '10006372' , '10006416' , '10006417' , '10006418' , '10006444' , '10006445' , '10006446' , '10006447' , '10006449' ,
                                                                                '10006450' , '10006451' , '10006452' , '10006453' , '10006454' , '10006455' , '10006456' , '10006457' , '10006458' ,
                                                                                '10006459' , '10006460' , '10006461' , '10006760' , '10006823' , '10006824' , '10006825' , '10006826' , '10006827' ,
                                                                                '10006828' , '10006829' , '10006830' , '10006833' , '10006834' , '10006835' , '10006836' , '10006966' , '10006967' ,
                                                                                '10006968' , '10008002' , '10008003' , '10008004' , '10008005' , '10006048' , '10006079' , '10006085' , '10006086' ,
                                                                                '10006088' , '10006089' , '10006090' , '10006091' , '10006092' , '10006093' , '10006094' , '10006095' , '10006097' ,
                                                                                '10006155' , '10006267' , '10006268' , '10006269' , '10006352' , '10006419' , '10006420' , '10006421' , '10006422' ,
                                                                                '10006423' , '10006424' , '10006425' , '10006426' , '10006427' , '10006428' , '10006761' ))
        					and (tradeItemInformation/extension/*:packagingInformationModule/packaging/packagingTypeCode != ('X11', 'NE')))					    					
        					then  (exists (tradeItemInformation/extension/*:packagingMarkingModule/packagingMarking/isPackagingMarkedReturnable)
		                    and (every $node in (tradeItemInformation/extension/*:packagingMarkingModule/packagingMarking) 
        					satisfies ($node//isPackagingMarkedReturnable != '' )))                    												
        							
				          				 else true()">					          		 
				          		 		
							      		 		<errorMessage>Is packaging marked returnable shall be populated for the target market in case of packed fresh fruits and vegetables.</errorMessage>
							                
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
