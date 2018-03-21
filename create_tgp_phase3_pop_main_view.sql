USE cigma2;
DROP VIEW IF EXISTS tgp_phase3_pop_main;
CREATE VIEW tgp_phase3_pop_main AS 
SELECT t.gene AS gene,
       t.hgvs_cdna AS hgvs_cdna,
       
       p01.tgp_phase3_AF AS tgp_phase3_AF_ACB,
       p01.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_ACB,
       p01.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_ACB,
       p01.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_ACB,
       p01.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_ACB,
        
       p02.tgp_phase3_AF AS tgp_phase3_AF_ASW,
       p02.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_ASW,
       p02.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_ASW,
       p02.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_ASW,
       p02.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_ASW,
        
       p03.tgp_phase3_AF AS tgp_phase3_AF_BEB,
       p03.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_BEB,
       p03.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_BEB,
       p03.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_BEB,
       p03.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_BEB,
        
       p04.tgp_phase3_AF AS tgp_phase3_AF_CDX,
       p04.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_CDX,
       p04.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_CDX,
       p04.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_CDX,
       p04.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_CDX, 
        
       p05.tgp_phase3_AF AS tgp_phase3_AF_CEU,
       p05.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_CEU,
       p05.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_CEU,
       p05.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_CEU,
       p05.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_CEU,
        
       p06.tgp_phase3_AF AS tgp_phase3_AF_CHB,
       p06.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_CHB,
       p06.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_CHB,
       p06.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_CHB,
       p06.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_CHB,
        
       p07.tgp_phase3_AF AS tgp_phase3_AF_CHS,
       p07.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_CHS,
       p07.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_CHS,
       p07.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_CHS,
       p07.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_CHS,
        
       p08.tgp_phase3_AF AS tgp_phase3_AF_CLM,
       p08.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_CLM,
       p08.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_CLM,
       p08.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_CLM,
       p08.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_CLM, 
        
       p09.tgp_phase3_AF AS tgp_phase3_AF_ESN,
       p09.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_ESN,
       p09.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_ESN,
       p09.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_ESN,
       p09.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_ESN,
        
       p10.tgp_phase3_AF AS tgp_phase3_AF_FIN,
       p10.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_FIN,
       p10.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_FIN,
       p10.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_FIN,
       p10.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_FIN,
        
       p11.tgp_phase3_AF AS tgp_phase3_AF_GBR,
       p11.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_GBR,
       p11.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_GBR,
       p11.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_GBR,
       p11.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_GBR,
        
       p12.tgp_phase3_AF AS tgp_phase3_AF_GIH,
       p12.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_GIH,
       p12.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_GIH,
       p12.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_GIH,
       p12.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_GIH, 
        
       p13.tgp_phase3_AF AS tgp_phase3_AF_GWD,
       p13.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_GWD,
       p13.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_GWD,
       p13.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_GWD,
       p13.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_GWD,
        
       p14.tgp_phase3_AF AS tgp_phase3_AF_IBS,
       p14.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_IBS,
       p14.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_IBS,
       p14.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_IBS,
       p14.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_IBS,
        
       p15.tgp_phase3_AF AS tgp_phase3_AF_ITU,
       p15.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_ITU,
       p15.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_ITU,
       p15.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_ITU,
       p15.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_ITU,
        
       p16.tgp_phase3_AF AS tgp_phase3_AF_JPT,
       p16.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_JPT,
       p16.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_JPT,
       p16.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_JPT,
       p16.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_JPT, 
        
       p17.tgp_phase3_AF AS tgp_phase3_AF_KHV,
       p17.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_KHV,
       p17.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_KHV,
       p17.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_KHV,
       p17.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_KHV,
        
       p18.tgp_phase3_AF AS tgp_phase3_AF_LWK,
       p18.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_LWK,
       p18.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_LWK,
       p18.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_LWK,
       p18.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_LWK,
        
       p19.tgp_phase3_AF AS tgp_phase3_AF_MSL,
       p19.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_MSL,
       p19.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_MSL,
       p19.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_MSL,
       p19.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_MSL,
        
       p20.tgp_phase3_AF AS tgp_phase3_AF_MXL,
       p20.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_MXL,
       p20.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_MXL,
       p20.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_MXL,
       p20.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_MXL, 
        
       p21.tgp_phase3_AF AS tgp_phase3_AF_PEL,
       p21.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_PEL,
       p21.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_PEL,
       p21.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_PEL,
       p21.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_PEL,
        
       p22.tgp_phase3_AF AS tgp_phase3_AF_PJL,
       p22.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_PJL,
       p22.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_PJL,
       p22.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_PJL,
       p22.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_PJL,
        
       p23.tgp_phase3_AF AS tgp_phase3_AF_PUR,
       p23.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_PUR,
       p23.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_PUR,
       p23.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_PUR,
       p23.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_PUR,
         
       p24.tgp_phase3_AF AS tgp_phase3_AF_STU,
       p24.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_STU,
       p24.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_STU,
       p24.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_STU,
       p24.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_STU, 
        
       p25.tgp_phase3_AF AS tgp_phase3_AF_TSI,
       p25.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_TSI,
       p25.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_TSI,
       p25.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_TSI,
       p25.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_TSI,
        
       p26.tgp_phase3_AF AS tgp_phase3_AF_YRI,
       p26.tgp_phase3_alleleCount AS tgp_phase3_alleleCount_YRI,
       p26.tgp_phase3_alleleTotal AS tgp_phase3_alleleTotal_YRI,
       p26.tgp_phase3_genotypeCount AS tgp_phase3_genotypeCount_YRI,
       p26.tgp_phase3_genotypePopSize AS tgp_phase3_genotypePopSize_YRI
 FROM ((((((((((((((((((((((((((tgp_phase3 t 
                LEFT JOIN tgp_phase3_pop p01 ON(((t.tgp_phase3_id = p01.tgp_phase3_id) AND (p01.tgp_phase3_pop = 'ACB'))))
                LEFT JOIN tgp_phase3_pop p02 ON(((t.tgp_phase3_id = p02.tgp_phase3_id) AND (p02.tgp_phase3_pop = 'ASW'))))
                LEFT JOIN tgp_phase3_pop p03 ON(((t.tgp_phase3_id = p03.tgp_phase3_id) AND (p03.tgp_phase3_pop = 'BEB'))))
                LEFT JOIN tgp_phase3_pop p04 on(((t.tgp_phase3_id = p04.tgp_phase3_id) AND (p04.tgp_phase3_pop = 'CDX'))))
                LEFT JOIN tgp_phase3_pop p05 ON(((t.tgp_phase3_id = p05.tgp_phase3_id) AND (p05.tgp_phase3_pop = 'CEU'))))
                LEFT JOIN tgp_phase3_pop p06 ON(((t.tgp_phase3_id = p06.tgp_phase3_id) AND (p06.tgp_phase3_pop = 'CHB'))))
                LEFT JOIN tgp_phase3_pop p07 ON(((t.tgp_phase3_id = p07.tgp_phase3_id) AND (p07.tgp_phase3_pop = 'CHS'))))
                LEFT JOIN tgp_phase3_pop p08 on(((t.tgp_phase3_id = p08.tgp_phase3_id) AND (p08.tgp_phase3_pop = 'CLM'))))
                LEFT JOIN tgp_phase3_pop p09 ON(((t.tgp_phase3_id = p09.tgp_phase3_id) AND (p09.tgp_phase3_pop = 'ESN'))))
                LEFT JOIN tgp_phase3_pop p10 ON(((t.tgp_phase3_id = p10.tgp_phase3_id) AND (p10.tgp_phase3_pop = 'FIN'))))
                LEFT JOIN tgp_phase3_pop p11 ON(((t.tgp_phase3_id = p11.tgp_phase3_id) AND (p11.tgp_phase3_pop = 'GBR'))))
                LEFT JOIN tgp_phase3_pop p12 on(((t.tgp_phase3_id = p12.tgp_phase3_id) AND (p12.tgp_phase3_pop = 'GIH'))))
                LEFT JOIN tgp_phase3_pop p13 ON(((t.tgp_phase3_id = p13.tgp_phase3_id) AND (p13.tgp_phase3_pop = 'GWD'))))
                LEFT JOIN tgp_phase3_pop p14 ON(((t.tgp_phase3_id = p14.tgp_phase3_id) AND (p14.tgp_phase3_pop = 'IBS'))))
                LEFT JOIN tgp_phase3_pop p15 ON(((t.tgp_phase3_id = p15.tgp_phase3_id) AND (p15.tgp_phase3_pop = 'ITU'))))
                LEFT JOIN tgp_phase3_pop p16 on(((t.tgp_phase3_id = p16.tgp_phase3_id) AND (p16.tgp_phase3_pop = 'JPT'))))
                LEFT JOIN tgp_phase3_pop p17 ON(((t.tgp_phase3_id = p17.tgp_phase3_id) AND (p17.tgp_phase3_pop = 'KHV'))))
                LEFT JOIN tgp_phase3_pop p18 ON(((t.tgp_phase3_id = p18.tgp_phase3_id) AND (p18.tgp_phase3_pop = 'LWK'))))
                LEFT JOIN tgp_phase3_pop p19 ON(((t.tgp_phase3_id = p19.tgp_phase3_id) AND (p19.tgp_phase3_pop = 'MSL'))))
                LEFT JOIN tgp_phase3_pop p20 on(((t.tgp_phase3_id = p20.tgp_phase3_id) AND (p20.tgp_phase3_pop = 'MXL'))))
                LEFT JOIN tgp_phase3_pop p21 ON(((t.tgp_phase3_id = p21.tgp_phase3_id) AND (p21.tgp_phase3_pop = 'PEL'))))
                LEFT JOIN tgp_phase3_pop p22 ON(((t.tgp_phase3_id = p22.tgp_phase3_id) AND (p22.tgp_phase3_pop = 'PJL'))))
                LEFT JOIN tgp_phase3_pop p23 ON(((t.tgp_phase3_id = p23.tgp_phase3_id) AND (p23.tgp_phase3_pop = 'PUR'))))
                LEFT JOIN tgp_phase3_pop p24 on(((t.tgp_phase3_id = p24.tgp_phase3_id) AND (p24.tgp_phase3_pop = 'STU'))))
                LEFT JOIN tgp_phase3_pop p25 ON(((t.tgp_phase3_id = p25.tgp_phase3_id) AND (p25.tgp_phase3_pop = 'TSI'))))
                LEFT JOIN tgp_phase3_pop p26 ON(((t.tgp_phase3_id = p26.tgp_phase3_id) AND (p26.tgp_phase3_pop = 'YRI'))))
