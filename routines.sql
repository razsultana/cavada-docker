-- MySQL dump 10.13  Distrib 5.5.37, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: cigma2
-- ------------------------------------------------------
-- Server version	5.5.37-0ubuntu0.14.04.1
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Dumping routines for database 'cigma2'
--
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`batch`@`localhost` FUNCTION `complement`(nt CHAR(1)) RETURNS char(1) CHARSET utf8
BEGIN
 RETURN CASE CONVERT(nt USING latin1) COLLATE latin1_general_cs
        WHEN 'a' THEN 't'
        WHEN 'A' THEN 'T'
        WHEN 'c' THEN 'g'
        WHEN 'C' THEN 'G'
        WHEN 'g' THEN 'c'
        WHEN 'G' THEN 'C'
        WHEN 't' THEN 'a'
        WHEN 'T' THEN 'A'
        ELSE nt
       END;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`batch`@`localhost` FUNCTION `reverse_complement`(seq VARCHAR(250)) RETURNS varchar(250) CHARSET utf8
BEGIN
  SET @seq = seq;
  SET @revseq = '';
  SET @x = 0;
  REPEAT
    SET @x = @x + 1; 
    SET @revseq = CONCAT(@revseq,complement(SUBSTR(@seq,-@x,1)));
    UNTIL @x > LENGTH(@seq)
  END REPEAT;
  RETURN @revseq;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`batch`@`localhost` PROCEDURE `check_consistency`(mytable VARCHAR(50))
BEGIN

SET @mytable = mytable;
IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="flags" and table_name=mytable and table_schema=database())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET flags=NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD flags VARCHAR(100)');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;


SELECT CONCAT('Checking cdna/protein coords in table ',@mytable) Message;
SET @sql_text = CONCAT('SELECT gene,transcript,hgvs_cdna,FLOOR((SUBSTR(hgvs_cdna,3,LENGTH(hgvs_cdna)-5)+2)/3) calculated_codon,',
 'hgvs_prot,SUBSTR(hgvs_prot,6,LENGTH(hgvs_prot)-IF(SUBSTR(TRIM(hgvs_prot),-1,1) IN ("=","X"),6,8)) existing_codon FROM ',@mytable,
 ' WHERE hgvs_cdna NOT LIKE "%ins%" AND hgvs_cdna NOT LIKE "%del%" AND hgvs_cdna NOT LIKE "%+%" AND hgvs_cdna NOT LIKE "%-%" AND hgvs_cdna NOT LIKE "%\_%" ',
 ' AND hgvs_prot NOT LIKE "%?" AND hgvs_prot NOT LIKE "%*" AND hgvs_prot NOT LIKE "%ext%"',
 ' AND NOT FLOOR((SUBSTR(hgvs_cdna,3,LENGTH(hgvs_cdna)-5)+2)/3) = SUBSTR(hgvs_prot,6,LENGTH(hgvs_prot)-IF(SUBSTR(TRIM(hgvs_prot),-1,1) IN ("=","X"),6,8))');
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' SET flags="cdna_prot_coords"',
 ' WHERE hgvs_cdna NOT LIKE "%ins%" AND hgvs_cdna NOT LIKE "%del%" AND hgvs_cdna NOT LIKE "%+%" AND hgvs_cdna NOT LIKE "%-%" AND hgvs_cdna NOT LIKE "%\_%" ',
 ' AND hgvs_prot NOT LIKE "%?" AND hgvs_prot NOT LIKE "%*" AND hgvs_prot NOT LIKE "%ext%"',
 ' AND NOT FLOOR((SUBSTR(hgvs_cdna,3,LENGTH(hgvs_cdna)-5)+2)/3) = SUBSTR(hgvs_prot,6,LENGTH(hgvs_prot)-IF(SUBSTR(TRIM(hgvs_prot),-1,1) IN ("=","X"),6,8))');
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


SELECT CONCAT("Checking cdna/genomic nucleotide wildtype in table ",@mytable) Message;
SET @sql_text = CONCAT('SELECT b.gene,b.transcript,b.hgvs_cdna,SUBSTR(b.hgvs_cdna,LENGTH(b.hgvs_cdna)-2,1) cdna_nt_wt,c.cdna_base genomic_nt_wt FROM ',
 @mytable,' b JOIN cdna2genomic c ON b.gene=c.gene AND b.transcript=c.transcript AND b.cdna_pos=c.cdna_pos',
 ' WHERE hgvs_cdna NOT LIKE "%ins%" AND hgvs_cdna NOT LIKE "%del%" AND hgvs_cdna NOT LIKE "%+%" AND hgvs_cdna NOT LIKE "%-%" AND hgvs_cdna NOT LIKE "%\_%" ',
 ' AND hgvs_prot NOT LIKE "%?" AND hgvs_prot NOT LIKE "%*" AND hgvs_prot NOT LIKE "%ext%"',
 ' AND NOT SUBSTR(b.hgvs_cdna,LENGTH(b.hgvs_cdna)-2,1)=c.cdna_base');
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' b JOIN cdna2genomic c ON b.gene=c.gene AND b.transcript=c.transcript AND b.cdna_pos=c.cdna_pos',
 ' SET b.flags=CONCAT(IF(b.flags IS NULL,"",CONCAT(b.flags,",")),"cdna_genomic_nt_wt")',
 ' WHERE hgvs_cdna NOT LIKE "%ins%" AND hgvs_cdna NOT LIKE "%del%" AND hgvs_cdna NOT LIKE "%+%" AND hgvs_cdna NOT LIKE "%-%" AND hgvs_cdna NOT LIKE "%\_%" ',
 ' AND hgvs_prot NOT LIKE "%?" AND hgvs_prot NOT LIKE "%*" AND hgvs_prot NOT LIKE "%ext%"',
 ' AND NOT SUBSTR(b.hgvs_cdna,LENGTH(b.hgvs_cdna)-2,1)=c.cdna_base');
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


SELECT CONCAT('Checking protein/genomic aminoacid wildtype in table ',@mytable) Message;
SET @sql_text = CONCAT('SELECT b.gene, b.transcript, b.hgvs_cdna, b.hgvs_prot, SUBSTR(b.hgvs_prot,3,3) prot_aa_wt, t.code3 genomic_aa_wt FROM ',
 @mytable,' b JOIN cdna2genomic c ON b.gene=c.gene AND b.transcript=c.transcript AND b.cdna_pos=c.cdna_pos JOIN tt1 t ON UPPER(c.codonseq)=t.codon',
 ' WHERE hgvs_cdna NOT LIKE "%ins%" AND hgvs_cdna NOT LIKE "%del%" AND hgvs_cdna NOT LIKE "%+%" AND hgvs_cdna NOT LIKE "%-%" AND hgvs_cdna NOT LIKE "%\_%" ',
 ' AND hgvs_prot NOT LIKE "%?" AND hgvs_prot NOT LIKE "%*" AND hgvs_prot NOT LIKE "%ext%"',
 ' AND NOT SUBSTR(b.hgvs_prot,3,3)=t.code3');
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' b JOIN cdna2genomic c ON b.gene=c.gene AND b.transcript=c.transcript AND b.cdna_pos=c.cdna_pos JOIN tt1 t ON UPPER(c.codonseq)=t.codon',
 ' SET b.flags=CONCAT(IF(b.flags IS NULL,"",CONCAT(b.flags,",")),"prot_genomic_aa_wt") ',
 ' WHERE hgvs_cdna NOT LIKE "%ins%" AND hgvs_cdna NOT LIKE "%del%" AND hgvs_cdna NOT LIKE "%+%" AND hgvs_cdna NOT LIKE "%-%" AND hgvs_cdna NOT LIKE "%\_%" ',
 ' AND hgvs_prot NOT LIKE "%?" AND hgvs_prot NOT LIKE "%*" AND hgvs_prot NOT LIKE "%ext%"',
 ' AND NOT SUBSTR(b.hgvs_prot,3,3)=t.code3');
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


SELECT CONCAT('Checking protein/genomic aminoacid variation in table ',@mytable) Message;
SET @sql_text = CONCAT('SELECT b.gene, b.transcript, b.hgvs_cdna, b.hgvs_prot,',
 'IF(SUBSTR(TRIM(hgvs_prot),-1,1)="=",SUBSTR(hgvs_prot,3,3),IF(SUBSTR(TRIM(hgvs_prot),-1,1)="X","Ter",SUBSTR(hgvs_prot,-3))) prot_aa_var, t.code3 genomic_aa_var FROM ',
 @mytable,' b JOIN cdna2genomic c ON b.gene=c.gene AND b.transcript=c.transcript AND b.cdna_pos=c.cdna_pos JOIN tt1 t ON UPPER(INSERT(c.codonseq,c.codonpos,1,SUBSTR(b.hgvs_cdna,-1)))=t.codon',
 ' WHERE hgvs_cdna NOT LIKE "%ins%" AND hgvs_cdna NOT LIKE "%del%" AND hgvs_cdna NOT LIKE "%+%" AND hgvs_cdna NOT LIKE "%-%" AND hgvs_cdna NOT LIKE "%\_%" ',
 ' AND hgvs_prot NOT LIKE "%?" AND hgvs_prot NOT LIKE "%*" AND hgvs_prot NOT LIKE "%ext%"',
 ' AND NOT IF(SUBSTR(TRIM(hgvs_prot),-1,1)="=",SUBSTR(hgvs_prot,3,3), IF(SUBSTR(TRIM(hgvs_prot),-1,1)="X","Ter", SUBSTR(hgvs_prot,-3)))=t.code3');
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' b JOIN cdna2genomic c ON b.gene=c.gene AND b.transcript=c.transcript AND b.cdna_pos=c.cdna_pos',
 ' JOIN tt1 t ON UPPER(INSERT(c.codonseq,c.codonpos,1,SUBSTR(b.hgvs_cdna,-1)))=t.codon',
 ' SET b.flags=CONCAT(IF(b.flags IS NULL,"",CONCAT(b.flags,",")),"prot_genomic_aa_var")',
 ' WHERE hgvs_cdna NOT LIKE "%ins%" AND hgvs_cdna NOT LIKE "%del%" AND hgvs_cdna NOT LIKE "%+%" AND hgvs_cdna NOT LIKE "%-%" AND hgvs_cdna NOT LIKE "%\_%" ',
 ' AND hgvs_prot NOT LIKE "%?" AND hgvs_prot NOT LIKE "%*" AND hgvs_prot NOT LIKE "%ext%"',
 ' AND NOT IF(SUBSTR(TRIM(hgvs_prot),-1,1)="=",SUBSTR(hgvs_prot,3,3),IF(SUBSTR(TRIM(hgvs_prot),-1,1)="X","Ter",SUBSTR(hgvs_prot,-3)))=t.code3');
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`batch`@`localhost` PROCEDURE `classify_by_varType`(mytable VARCHAR(50))
main: BEGIN

SET @mytable = mytable;
IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="gene" AND table_name=mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="transcript" AND table_name=mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="ntwt" AND table_name=mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="ntmut" AND table_name=mytable AND table_schema=DATABASE())
THEN
 SET @sql_text = CONCAT('SELECT "Error in classify_by_type: Table ',@mytable,' is missing one of the required fields: gene,transcript,ntwt or ntmut!" ERROR');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
 LEAVE main;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="varType" AND table_name=mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET varType=NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD varType VARCHAR(12) NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

SET @sql_text = CONCAT('UPDATE ',@mytable,' SET varType = 
CASE WHEN (LENGTH(ntmut)-LENGTH(REPLACE(ntmut,"/","")))>0 THEN "complex"
     WHEN LENGTH(REPLACE(ntwt,"-",""))=1 AND LENGTH(REPLACE(ntmut,"-",""))=1 THEN "substitution" 
     WHEN LENGTH(REPLACE(ntwt,"-",""))<LENGTH(REPLACE(ntmut,"-","")) THEN "insertion" 
     WHEN LENGTH(REPLACE(ntwt,"-",""))>LENGTH(REPLACE(ntmut,"-","")) THEN "deletion" 
ELSE NULL END');
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`batch`@`localhost` PROCEDURE `determine_codingEffect`(mytable VARCHAR(50))
main: BEGIN

SET @mytable = mytable;
IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="gene" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="transcript" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="hg19_chr" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="hg19_pos" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="ntmut" AND table_name=@mytable AND table_schema=DATABASE())
THEN
 SET @sql_text = CONCAT('SELECT "Error in determine_codingEffect: Table ',@mytable,' is missing one of the required fields: gene,transcript,hg19_chr,hg19_pos or ntmut!" ERROR');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
 LEAVE main;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="codingEffect" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET codingEffect = NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD codingEffect VARCHAR(10) DEFAULT ""');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="aawt" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET aawt = NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD aawt VARCHAR(3) DEFAULT ""');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="aamut" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET aamut = NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD aamut VARCHAR(3) DEFAULT ""');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
" JOIN cdna2genomic c 
    ON m.gene=c.gene AND m.transcript=c.transcript 
   AND REPLACE(m.hg19_chr,'chr','')=c.chr and m.hg19_pos=c.genomic_pos 
   AND m.varType='substitution' AND m.varLocation='exon'
  JOIN tt1 t1 ON UPPER(c.codonseq)=t1.codon
  JOIN tt1 t2 ON UPPER(INSERT(c.codonseq,c.codonpos,1,m.ntmut))=t2.codon
   SET m.aawt=t1.code3,
       m.aamut=t2.code3
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET codingEffect = IF(aawt!='Ter' AND aamut='Ter','nonsense',
                         IF(aawt='Ter' AND aamut!='Ter' ,'stop loss',
                            IF(aawt=aamut,'synonymous','missense')))
 WHERE varType='substitution' AND varLocation='exon';
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`batch`@`localhost` PROCEDURE `determine_varLocation`(mytable VARCHAR(50))
main: BEGIN

SET @mytable = mytable;
IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="gene" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="transcript" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="hg19_chr" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="hg19_pos" AND table_name=@mytable AND table_schema=DATABASE())
THEN
 SET @sql_text = CONCAT('SELECT "Error in determine_varLocation: Table ',@mytable,' is missing one of the required fields: gene,transcript,hg19_chr or hg19_pos!" ERROR');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
 LEAVE main;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="varLocation" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET varLocation = NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD varLocation VARCHAR(10) NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
    ON m.gene=r.gene AND m.transcript=r.transcript AND r.name LIKE '%exon%'
   AND m.hg19_chr=r.chr and m.hg19_pos BETWEEN r.cdsstart AND r.cdsend
   SET varLocation='exon'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
    ON m.gene=r.gene AND m.transcript=r.transcript AND r.name LIKE '%exon%'
   AND m.hg19_chr=r.chr and m.hg19_pos BETWEEN r.cdsstart AND r.cdsend
   SET varLocation='exon'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
    ON m.gene=r.gene AND m.transcript=r.transcript AND r.name LIKE '%intron%'
   AND m.hg19_chr and m.hg19_pos BETWEEN r.exonstart AND r.exonend
   SET varLocation='intron'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
    ON m.gene=r.gene AND m.transcript=r.transcript AND r.name LIKE '%exon%' AND r.cdnato<0
   AND m.hg19_chr=r.chr and m.hg19_pos BETWEEN r.exonstart AND r.exonend
   SET varLocation=""5'UTR""
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
    ON m.gene=r.gene AND m.transcript=r.transcript AND r.name LIKE '%exon%' AND r.strand='+' AND r.flags LIKE 'F%'
   AND m.hg19_chr=r.chr and m.hg19_pos BETWEEN r.exonstart AND r.cdsstart-1
   SET varLocation=""5'UTR""
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
    ON m.gene=r.gene AND m.transcript=r.transcript AND r.name LIKE '%exon%' AND r.strand='-' AND r.flags LIKE 'F%'
   AND m.hg19_chr=r.chr and m.hg19_pos BETWEEN r.cdsend+1 AND r.exonend 
   SET varLocation=""5'UTR""
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
    ON m.gene=r.gene AND m.transcript=r.transcript AND r.name LIKE '%exon%' AND cdnato=0
   AND m.hg19_chr=r.chr and m.hg19_pos BETWEEN r.exonstart AND r.exonend
   SET varLocation=""3'UTR""
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
    ON m.gene=r.gene AND m.transcript=r.transcript AND r.name LIKE '%exon%' AND r.strand='+' AND r.flags LIKE '%L%'
   AND m.hg19_chr=r.chr and m.hg19_pos BETWEEN r.cdsend+1 AND r.exonend 
   SET varLocation=""3'UTR""
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
    ON m.gene=r.gene AND m.transcript=r.transcript AND r.name LIKE '%exon%' AND r.strand='-' AND r.flags LIKE '%L%'
   AND m.hg19_chr=r.chr and m.hg19_pos BETWEEN r.exonstart AND r.cdsstart-1
   SET varLocation=""3'UTR""
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"   SET varLocation='intergenic' WHERE m.varLocation IS NULL
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`batch`@`localhost` PROCEDURE `get_alleles_from_hgvs_cdna`(mytable VARCHAR(50), myhgvs VARCHAR(50))
main: BEGIN

SET @mytable = mytable;
SET @myhgvs = myhgvs;
IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name=@myhgvs AND table_name=@mytable AND table_schema=DATABASE())
THEN
 SET @sql_text = CONCAT('SELECT "Error in get_alleles_from_hgvs_cdna: Table ',@mytable,' is missing the field ',@myhgvs,'!" ERROR');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
 LEAVE main;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="ntwt" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET ntwt = NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD ntwt VARCHAR(50)');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="ntmut" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET ntmut = NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD ntmut VARCHAR(50)');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET ntwt=SUBSTR(",@myhgvs,",-3,1), 
       ntmut=SUBSTR(",@myhgvs,",-1) 
 WHERE ",@myhgvs," RLIKE '>'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET ntwt='-', 
       ntmut=SUBSTR(",@myhgvs,",INSTR(",@myhgvs,",'ins')+3) 
 WHERE ",@myhgvs," RLIKE 'ins' AND ",@myhgvs," NOT RLIKE 'del' 
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET ntwt='-', 
       ntmut=SUBSTR(",@myhgvs,",INSTR(",@myhgvs,",'dup')+3) 
 WHERE ",@myhgvs," RLIKE 'dup'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET ntwt=SUBSTR(",@myhgvs,",INSTR(",@myhgvs,",'del')+3),
       ntmut='-'
 WHERE ",@myhgvs," RLIKE 'del' AND ",@myhgvs," NOT RLIKE 'ins'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;



END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`batch`@`localhost` PROCEDURE `get_cdnacoord_from_genomecoord`(mytable VARCHAR(50))
main: BEGIN

SET @mytable = mytable;
IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="gene" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="transcript" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="hg19_chr" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="hg19_pos" AND table_name=@mytable AND table_schema=DATABASE())
THEN
 SET @sql_text = CONCAT('SELECT "Error in get_cdnacoord_from_genomecoord: Table ',@mytable,' is missing one of the required fields: gene,transcript,hg19_chr or hg19_pos!" ERROR');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
 LEAVE main;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="cdna_pos" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET cdna_pos = 0');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD cdna_pos INT DEFAULT 0');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="codon" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET codon = NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD codon INT DEFAULT NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="offset" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET offset = 0');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD offset INT DEFAULT 0');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="utr3offset" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET utr3offset = 0');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD utr3offset INT DEFAULT 0');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;


SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN cdna2genomic c 
    ON m.gene=c.gene AND m.transcript=c.transcript 
   AND m.hg19_chr=c.chr and m.hg19_pos=c.genomic_pos 
   AND m.varType='substitution' AND m.varLocation='exon'
   SET m.cdna_pos=c.cdna_pos,
       m.codon=FLOOR((c.cdna_pos+2)/3)
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
    ON m.gene=r.gene and m.transcript=r.transcript
   AND m.hg19_chr=r.chr AND m.hg19_pos BETWEEN r.exonstart AND r.exonend
   SET cdna_pos=IF((m.hg19_pos-r.exonstart)>(r.exonend-m.hg19_pos),r.cdnato,r.cdnafrom),
       offset=IF((m.hg19_pos-r.exonstart)>(r.exonend-m.hg19_pos),-(r.exonend-m.hg19_pos+1),m.hg19_pos-r.exonstart+1)
 WHERE m.varType='substitution' AND m.varLocation='intron' AND r.strand='+'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
    ON m.gene=r.gene and m.transcript=r.transcript
   AND m.hg19_chr=r.chr AND m.hg19_pos BETWEEN r.exonstart AND r.exonend
   SET cdna_pos=IF((m.hg19_pos-r.exonstart)>(r.exonend-m.hg19_pos),r.cdnafrom,r.cdnato),
       offset=IF((m.hg19_pos-r.exonstart)>(r.exonend-m.hg19_pos),r.exonend-m.hg19_pos+1,-(m.hg19_pos-r.exonstart+1))
 WHERE m.varType='substitution' AND m.varLocation='intron' AND r.strand='-'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
     ON m.gene=r.gene and m.transcript=r.transcript
    AND m.hg19_chr=r.chr and m.hg19_pos BETWEEN r.exonstart AND r.exonend
    AND r.name LIKE '%exon%'
    AND m.varType='substitution' AND m.varLocation='5''UTR'
SET m.cdna_pos=IF(r.strand='+',r.cdnafrom+m.hg19_pos-r.exonstart,r.cdnafrom-m.hg19_pos+r.exonend)
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;


SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
     ON m.gene=r.gene and m.transcript=r.transcript
    AND r.name LIKE '%exon%'
    AND m.hg19_chr=r.chr and m.hg19_pos BETWEEN r.exonstart AND r.exonend
    AND m.varType='substitution' AND m.varLocation='3''UTR'
    SET m.utr3offset=IF(r.strand='+',r.utr3to+m.hg19_pos-r.exonend,r.utr3to+r.exonstart-m.hg19_pos)
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`batch`@`localhost` PROCEDURE `get_cdnacoord_from_hgvs_cdna`(mytable VARCHAR(50), myhgvs VARCHAR(50))
main: BEGIN

SET @mytable = mytable;
SET @myhgvs = myhgvs;
IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name=@myhgvs AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="varLocation" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="varType" AND table_name=@mytable AND table_schema=DATABASE())
THEN
 SET @sql_text = CONCAT('SELECT "Error in get_cdnacoord_from_hgvs_cdna: Table ',@mytable,' is missing one of the required fields: ',@myhgvs,',varLocation or varType!" ERROR');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
 LEAVE main;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="cdna_pos" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET cdna_pos = 0');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD cdna_pos INT DEFAULT 0');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="codon" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET codon = NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD codon INT DEFAULT NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="offset" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET offset = 0');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD offset INT DEFAULT 0');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="utr3offset" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET utr3offset = 0');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD utr3offset INT DEFAULT 0');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET cdna_pos=SUBSTR(",@myhgvs,",3,LENGTH(",@myhgvs,")-5),
       offset=0
 WHERE varType='substitution' AND varLocation='exon'
" ); 
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET cdna_pos=SUBSTR(",@myhgvs,",3,LOCATE('_',",@myhgvs,")-3),
       offset=0
 WHERE ",@myhgvs," RLIKE '_' AND varLocation='exon'
" ); 
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET cdna_pos=SUBSTR(",@myhgvs,",3,LOCATE('d',",@myhgvs,")-3),
       offset=0
 WHERE ",@myhgvs," RLIKE 'dup|del' AND ",@myhgvs," NOT RLIKE '_' AND varLocation='exon'
" ); 
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET codon=FLOOR((cdna_pos+2)/3)
 WHERE varType='substitution' AND varLocation='exon'
" ); 
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET cdna_pos=SUBSTRING_INDEX(
                CASE WHEN varType='substitution' THEN SUBSTR(",@myhgvs,",3,LENGTH(",@myhgvs,")-5) 
                     WHEN ",@myhgvs," rlike '_' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'_',1),'.',-1) 
                     WHEN ",@myhgvs," rlike 'dup|del' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'d',1),'.',-1) 
                     END,
                '+',1), 
       offset=SUBSTRING_INDEX(
              CASE WHEN varType='substitution' THEN SUBSTR(",@myhgvs,",3,LENGTH(",@myhgvs,")-5) 
                   WHEN ",@myhgvs," RLIKE '_' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'_',1),'.',-1) 
                   WHEN ",@myhgvs," RLIKE 'dup|del' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'d',1),'.',-1)
                   END,
              '+',-1)
 WHERE varLocation='intron'
   AND ",@myhgvs," LIKE 'c.%+%'
   AND ",@myhgvs," NOT LIKE 'c.*%'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET cdna_pos=SUBSTRING_INDEX(
                CASE WHEN varType='substitution' THEN SUBSTR(",@myhgvs,",3,LENGTH(",@myhgvs,")-5) 
                     WHEN ",@myhgvs," rlike '_' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'_',1),'.',-1) 
                     WHEN ",@myhgvs," rlike 'dup|del' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'d',1),'.',-1) 
                     END,
                '-',1), 
       offset=CONCAT('-',SUBSTRING_INDEX(
                         CASE WHEN varType='substitution' THEN SUBSTR(",@myhgvs,",3,LENGTH(",@myhgvs,")-5) 
                              WHEN ",@myhgvs," RLIKE '_' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'_',1),'.',-1) 
                              WHEN ",@myhgvs," RLIKE 'dup|del' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'d',1),'.',-1)
                              END,
                         '-',-1))
 WHERE varLocation='intron'
   AND ",@myhgvs," LIKE 'c.%-%'
   AND ",@myhgvs," NOT LIKE 'c.-%'
   AND ",@myhgvs," NOT LIKE 'c.*%'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET cdna_pos=SUBSTRING_INDEX(
                CASE WHEN varType='substitution' THEN SUBSTR(",@myhgvs,",3,LENGTH(",@myhgvs,")-5) 
                     WHEN ",@myhgvs," rlike '_' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'_',1),'.',-1) 
                     WHEN ",@myhgvs," rlike 'dup|del' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'d',1),'.',-1) 
                     END,
                '-',2), 
       offset=CONCAT('-',SUBSTRING_INDEX(
                         CASE WHEN varType='substitution' THEN SUBSTR(",@myhgvs,",3,LENGTH(",@myhgvs,")-5) 
                              WHEN ",@myhgvs," RLIKE '_' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'_',1),'.',-1) 
                              WHEN ",@myhgvs," RLIKE 'dup|del' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'d',1),'.',-1)
                              END,
                         '-',-1))
 WHERE varLocation='intron'
   AND ",@myhgvs," LIKE 'c.-%-%'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET utr3offset=SUBSTRING_INDEX(
                  CASE WHEN varType='substitution' THEN SUBSTR(",@myhgvs,",4,LENGTH(",@myhgvs,")-5) 
                       WHEN ",@myhgvs," rlike '_' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'_',1),'*',-1) 
                       WHEN ",@myhgvs," rlike 'dup|del' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'d',1),'*',-1) 
                       END,
                  '+',1), 
       offset=SUBSTRING_INDEX(
              CASE WHEN varType='substitution' THEN SUBSTR(",@myhgvs,",4,LENGTH(",@myhgvs,")-5) 
                   WHEN ",@myhgvs," RLIKE '_' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'_',1),'*',-1) 
                   WHEN ",@myhgvs," RLIKE 'dup|del' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'d',1),'*',-1)
                   END,
              '+',-1)
 WHERE varLocation='intron'
   AND ",@myhgvs," LIKE 'c.*%+%'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET utr3offset=SUBSTRING_INDEX(
                  CASE WHEN varType='substitution' THEN SUBSTR(",@myhgvs,",4,LENGTH(",@myhgvs,")-5) 
                       WHEN ",@myhgvs," rlike '_' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'_',1),'*',-1) 
                       WHEN ",@myhgvs," rlike 'dup|del' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'d',1),'*',-1) 
                       END,
                  '-',1), 
       offset=SUBSTRING_INDEX(
              CASE WHEN varType='substitution' THEN SUBSTR(",@myhgvs,",4,LENGTH(",@myhgvs,")-5) 
                   WHEN ",@myhgvs," RLIKE '_' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'_',1),'*',-1) 
                   WHEN ",@myhgvs," RLIKE 'dup|del' THEN SUBSTRING_INDEX(SUBSTRING_INDEX(",@myhgvs,",'d',1),'*',-1)
                   END,
              '-',-1)
 WHERE varLocation='intron'
   AND ",@myhgvs," LIKE 'c.*%-%'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET cdna_pos=SUBSTR(",@myhgvs,",3,LENGTH(",@myhgvs,")-5)
 WHERE varType='substitution' AND varLocation='5''UTR'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET utr3offset=SUBSTR(",@myhgvs,",4,LENGTH(",@myhgvs,")-6)
 WHERE varType='substitution' AND varLocation='3''UTR'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`batch`@`localhost` PROCEDURE `get_genomecoord_from_cdnacoord`(mytable VARCHAR(50))
main: BEGIN

SET @mytable = mytable;
IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="gene" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="transcript" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="cdna_pos" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="offset" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="utr3offset" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="varLocation" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="varType" AND table_name=@mytable AND table_schema=DATABASE())
THEN
 SET @sql_text = CONCAT('SELECT "Error in get_genomecoord_from_cdnacoord: Table ',@mytable,' is missing one of the required fields: gene,transcript,cdna_pos,offset,utr3offset,varType,varLocation!" ERROR');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
 LEAVE main;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="hg19_chr" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET hg19_chr = NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD hg19_chr VARCHAR(15) NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="hg19_pos" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET hg19_pos = NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD hg19_pos INT NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN cdna2genomic c 
    ON m.gene=c.gene AND m.transcript=c.transcript 
   AND m.cdna_pos=c.cdna_pos
   SET m.hg19_chr=c.chr, 
       m.hg19_pos=c.genomic_pos
 WHERE m.varType='substitution' and m.varLocation='exon'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
    ON m.gene=r.gene AND m.transcript=r.transcript
   AND m.cdna_pos=r.cdnafrom AND r.name LIKE '%intron%'
   SET m.hg19_chr=r.chr,
       m.hg19_pos=IF(r.strand='+',r.exonstart+m.offset-1,r.exonend-m.offset+1)
 WHERE m.varType='substitution' AND m.varLocation='intron'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
    ON m.gene=r.gene AND m.transcript=r.transcript
   AND m.cdna_pos=r.cdnato AND r.name LIKE '%intron%'
   SET m.hg19_chr=r.chr,
       m.hg19_pos=IF(r.strand='+',r.exonend+m.offset+1,r.exonstart-m.offset-1)
 WHERE m.varType='substitution' AND m.varLocation='intron'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
    ON m.gene=r.gene AND m.transcript=r.transcript
   AND m.cdna_pos BETWEEN r.cdnafrom AND r.cdnato 
   AND r.name LIKE '%exon%'
   SET m.hg19_chr=r.chr,
       m.hg19_pos=IF(r.strand='+',r.exonstart+m.cdna_pos-r.cdnafrom,r.exonend-m.cdna_pos+r.cdnafrom)
 WHERE m.varType='substitution' AND m.varLocation='5''UTR'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  JOIN capparegions r 
    ON m.gene=r.gene AND m.transcript=r.transcript
   AND m.utr3offset BETWEEN r.utr3from AND r.utr3to 
   AND r.name LIKE '%exon%'
   SET m.hg19_chr=r.chr,
       m.hg19_pos=IF(r.strand='+',r.exonend-r.utr3to+m.utr3offset,r.exonstart+r.utr3to-m.utr3offset)
 WHERE m.varType='substitution' AND m.varLocation='3''UTR'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`batch`@`localhost` PROCEDURE `get_varLocation_from_hgvs_cdna`(mytable VARCHAR(50), myhgvs VARCHAR(50))
main: BEGIN

SET @mytable = mytable;
SET @myhgvs = myhgvs;
IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name=@myhgvs AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="varType" AND table_name=@mytable AND table_schema=DATABASE())
THEN
 SET @sql_text = CONCAT('SELECT "Error in get_varLocation_from_hgvs_cdna: Table ',@mytable,' is missing one of the fields: ',@myhgvs,',varLocation or varType!" ERROR');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
 LEAVE main;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="varLocation" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET varLocation=NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD varLocation VARCHAR(10) NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET varLocation=
CASE WHEN ",@myhgvs," RLIKE '^c[.][0-9]+[ACTG]>[ACTG]' THEN 'exon'
     WHEN ",@myhgvs," RLIKE '^c[.][-*0-9]+[+-][0-9]+[ACTG]>[ACTG]' THEN 'intron'
     WHEN ",@myhgvs," RLIKE '^c[.][-][0-9]+[ACTG]>[ACTG]' THEN '5''UTR'
     WHEN ",@myhgvs," RLIKE '^c[.][*][0-9]+[ACTG]>[ACTG]' THEN '3''UTR'
ELSE NULL END
WHERE varType='substitution'
"); 
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET varLocation=
CASE WHEN ",@myhgvs," RLIKE '^c[.][0-9]+(_|dup)' THEN 'exon'
     WHEN ",@myhgvs," RLIKE '^c[.][-*0-9]+[+-][0-9]+(_|dup)' THEN 'intron'
     WHEN ",@myhgvs," RLIKE '^c[.][-][0-9]+(_|dup)' THEN '5''UTR'
     WHEN ",@myhgvs," RLIKE '^c[.][*][0-9]+(_|dup)' THEN '3''UTR'
ELSE NULL END
WHERE varType='insertion'
"); 
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET varLocation=
CASE WHEN ",@myhgvs," RLIKE '^c[.][0-9]+(_[0-9]+)?del' THEN 'exon'
     WHEN ",@myhgvs," RLIKE '^c[.][-*0-9]+[+-][0-9]+(_[-*0-9]+[+-][0-9]+)?del' THEN 'intron'
     WHEN ",@myhgvs," RLIKE '^c[.][-][0-9]+(_[-][0-9]+)?del' THEN '5''UTR'
     WHEN ",@myhgvs," RLIKE '^c[.][*][0-9]+(_[*][0-9]+)?del' THEN '3''UTR'
ELSE 'border' END
WHERE varType IN ('deletion','complex')
"); 
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`batch`@`localhost` PROCEDURE `get_varType_from_hgvs_cdna`(mytable VARCHAR(50), myhgvs VARCHAR(50))
main: BEGIN

SET @mytable = mytable;
SET @myhgvs = myhgvs;
IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name=@myhgvs AND table_name=@mytable AND table_schema=DATABASE())
THEN
 SET @sql_text = CONCAT('SELECT "Error in get_varType_from_hgvs_cdna: Table ',@mytable,' is missing the requireed field ',@myhgvs,'!" ERROR');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
 LEAVE main;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="varType" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET varType = NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD varType VARCHAR(12) NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET varType=
CASE WHEN ",@myhgvs," LIKE '%>%' THEN 'substitution'
     WHEN ",@myhgvs," LIKE '%del%ins%' THEN 'complex'
     WHEN ",@myhgvs," LIKE '%ins%' THEN 'insertion'
     WHEN ",@myhgvs," LIKE '%dup%' THEN 'insertion'
     WHEN ",@myhgvs," LIKE '%del%' THEN 'deletion'
ELSE NULL END" ); 
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8 */ ;
/*!50003 SET character_set_results = utf8 */ ;
/*!50003 SET collation_connection  = utf8_general_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = '' */ ;
DELIMITER ;;
CREATE DEFINER=`batch`@`localhost` PROCEDURE `make_hgvs`(mytable VARCHAR(50))
main: BEGIN

SET @mytable = mytable;
IF NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="gene" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="transcript" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="varType" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="varLocation" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="cdna_pos" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="offset" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="utr3offset" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="codon" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="ntwt" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="ntmut" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="aawt" AND table_name=@mytable AND table_schema=DATABASE())
OR NOT EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="aamut" AND table_name=@mytable AND table_schema=DATABASE())
THEN
 SET @sql_text = CONCAT('SELECT "Error in make_hgvs: Table ',@mytable,' is missing one of the required fields: gene,transcript,varType,varLocation,cdna_pos,offset,utr3offset,codon,ntwt,ntmut,aawt or aamut!" ERROR');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
 LEAVE main;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="hgvs_cdna" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET hgvs_cdna = NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD hgvs_cdna VARCHAR(100) DEFAULT ""');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="hgvs_prot" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET hgvs_prot = NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD hgvs_prot VARCHAR(100) DEFAULT ""');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="hgvs_prot_code1" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET hgvs_prot_code1 = NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD hgvs_prot_code1 VARCHAR(100) DEFAULT ""');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

IF EXISTS (SELECT * FROM information_schema.COLUMNS WHERE column_name="altname" AND table_name=@mytable AND table_schema=DATABASE())
THEN        
 SET @sql_text = CONCAT('UPDATE ',@mytable,' SET altname = NULL');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
ELSE
 SET @sql_text = CONCAT('ALTER TABLE ',@mytable,' ADD altname VARCHAR(100) DEFAULT ""');
 PREPARE stmt FROM @sql_text;
 EXECUTE stmt;
 DEALLOCATE PREPARE stmt;
END IF;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET hgvs_cdna=CONCAT('c.',cdna_pos,ntwt,'>',ntmut),
       hgvs_prot=CONCAT('p.',aawt,codon,aamut)
 WHERE varLocation='exon' AND varType='substitution'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m',
" JOIN tt1 t1 ON m.aawt=t1.code3
  JOIN tt1 t2 ON m.aamut=t2.code3
   SET m.hgvs_prot_code1=CONCAT('p.',t1.code1,m.codon,t2.code1)
 WHERE m.varLocation='exon' AND m.varType='substitution'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET hgvs_cdna=CONCAT('c.',cdna_pos,ntwt,'>',ntmut)
 WHERE varLocation='5''UTR' AND varType='substitution'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,
"  SET hgvs_cdna=CONCAT('c.*',utr3offset,ntwt,'>',ntmut)
 WHERE varLocation='3''UTR' AND varType='substitution'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
"  SET hgvs_cdna=CONCAT('c.',IF(utr3offset>0,CONCAT('*',utr3offset),cdna_pos),IF(offset>0,'+',''),offset,ntwt,'>',ntmut)
 WHERE varType='substitution' AND varLocation='intron'
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

SET @sql_text = CONCAT('UPDATE ',@mytable,' m ',
" JOIN capparegions r 
    ON r.gene=m.gene AND r.transcript=m.transcript
   AND m.varType='substitution' AND m.varLocation='intron'
   AND r.name LIKE '%intron%' AND (r.cdnafrom=m.cdna_pos or r.cdnato=m.cdna_pos)
   SET m.altname=CONCAT(r.altname,IF(m.offset>0,'+',''),m.offset,SUBSTR(m.hgvs_cdna,-3)); 
" );
PREPARE stmt FROM @sql_text;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;

END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-07-08 10:13:10
