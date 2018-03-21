USE cigma2;
DROP VIEW IF EXISTS tgp_pop_main;
CREATE VIEW tgp_pop_main AS 
SELECT t.gene AS gene,
       t.hgvs_cdna AS hgvs_cdna,
       p1.tgp_AF AS tgp_AF_EUR,
       p1.tgp_alleleCount AS tgp_alleleCount_EUR,
       p1.tgp_alleleTotal AS tgp_alleleTotal_EUR,
       p1.tgp_genotypeCount AS tgp_genotypeCount_EUR,
       p1.tgp_genotypePopSize AS tgp_genotypePopSize_EUR,
       p2.tgp_AF AS tgp_AF_AMR,
       p2.tgp_alleleCount AS tgp_alleleCount_AMR,
       p2.tgp_alleleTotal AS tgp_alleleTotal_AMR,
       p2.tgp_genotypeCount AS tgp_genotypeCount_AMR,
       p2.tgp_genotypePopSize AS tgp_genotypePopSize_AMR,
       p3.tgp_AF AS tgp_AF_AFR,
       p3.tgp_alleleCount AS tgp_alleleCount_AFR,
       p3.tgp_alleleTotal AS tgp_alleleTotal_AFR,
       p3.tgp_genotypeCount AS tgp_genotypeCount_AFR,
       p3.tgp_genotypePopSize AS tgp_genotypePopSize_AFR,
       p4.tgp_AF AS tgp_AF_ASN,
       p4.tgp_alleleCount AS tgp_alleleCount_ASN,
       p4.tgp_alleleTotal AS tgp_alleleTotal_ASN,
       p4.tgp_genotypeCount AS tgp_genotypeCount_ASN,
       p4.tgp_genotypePopSize AS tgp_genotypePopSize_ASN 
 FROM ((((tgp t LEFT JOIN tgp_pop p1 ON(((t.tgp_rsID = p1.tgp_rsID) AND (p1.tgp_pop = 'EUR'))))
                LEFT JOIN tgp_pop p2 ON(((t.tgp_rsID = p2.tgp_rsID) AND (p2.tgp_pop = 'AMR')))) 
                LEFT JOIN tgp_pop p3 ON(((t.tgp_rsID = p3.tgp_rsID) AND (p3.tgp_pop = 'AFR')))) 
                LEFT JOIN tgp_pop p4 on(((t.tgp_rsID = p4.tgp_rsID) AND (p4.tgp_pop = 'ASN'))));
