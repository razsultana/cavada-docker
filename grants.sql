## Grants for batch@% ##
GRANT USAGE ON *.* TO 'batch'@'%' IDENTIFIED BY PASSWORD '*92FA2D8D7CBE271BDE11255B486C8A3EDE3D38B4';
GRANT SELECT, CREATE TEMPORARY TABLES ON `cigma2`.* TO 'batch'@'%';
GRANT ALL PRIVILEGES ON `cigma2`.`dogma_batch` TO 'batch'@'%';
GRANT ALL PRIVILEGES ON `cigma2`.`dogma_batchlog` TO 'batch'@'%';
GRANT ALL PRIVILEGES ON `cigma2`.`batch` TO 'batch'@'%';
GRANT ALL PRIVILEGES ON `cigma2`.`batchlog` TO 'batch'@'%';
GRANT CREATE, ALTER ON `cigma2`.`cigma2` TO 'batch'@'%';
GRANT EXECUTE ON PROCEDURE `cigma2`.`get_cdnacoord_from_genomecoord` TO 'batch'@'%';
GRANT EXECUTE ON PROCEDURE `cigma2`.`check_consistency` TO 'batch'@'%';
GRANT EXECUTE ON PROCEDURE `cigma2`.`get_cdnacoord_from_hgvs_cdna` TO 'batch'@'%';
GRANT EXECUTE ON PROCEDURE `cigma2`.`get_varlocation_from_hgvs_cdna` TO 'batch'@'%';
GRANT EXECUTE ON PROCEDURE `cigma2`.`determine_codingeffect` TO 'batch'@'%';
GRANT EXECUTE ON PROCEDURE `cigma2`.`get_alleles_from_hgvs_cdna` TO 'batch'@'%';
GRANT EXECUTE ON PROCEDURE `cigma2`.`make_hgvs` TO 'batch'@'%';
GRANT EXECUTE ON PROCEDURE `cigma2`.`classify_by_vartype` TO 'batch'@'%';
GRANT EXECUTE ON PROCEDURE `cigma2`.`get_vartype_from_hgvs_cdna` TO 'batch'@'%';
GRANT EXECUTE ON PROCEDURE `cigma2`.`determine_varlocation` TO 'batch'@'%';
GRANT EXECUTE ON FUNCTION `cigma2`.`reverse_complement` TO 'batch'@'%';
GRANT EXECUTE ON PROCEDURE `cigma2`.`get_genomecoord_from_cdnacoord` TO 'batch'@'%';

## Grants for batch@localhost ##
GRANT USAGE ON *.* TO 'batch'@'localhost' IDENTIFIED BY PASSWORD '*92FA2D8D7CBE271BDE11255B486C8A3EDE3D38B4';
GRANT SELECT, INSERT, INDEX, CREATE TEMPORARY TABLES ON `cigma2`.* TO 'batch'@'localhost';
GRANT CREATE, ALTER ON `cigma2`.`cigma2` TO 'batch'@'localhost';
GRANT ALL PRIVILEGES ON `cigma2`.`batch` TO 'batch'@'localhost';
GRANT ALL PRIVILEGES ON `cigma2`.`batchlog` TO 'batch'@'localhost';
GRANT ALL PRIVILEGES ON `cigma2`.`dogma_batch` TO 'batch'@'localhost';
GRANT ALL PRIVILEGES ON `cigma2`.`dogma_batchlog` TO 'batch'@'localhost';
GRANT EXECUTE ON PROCEDURE `cigma2`.`get_cdnacoord_from_genomecoord` TO 'batch'@'localhost';
GRANT EXECUTE ON PROCEDURE `cigma2`.`check_consistency` TO 'batch'@'localhost';
GRANT EXECUTE ON PROCEDURE `cigma2`.`get_cdnacoord_from_hgvs_cdna` TO 'batch'@'localhost';
GRANT EXECUTE ON PROCEDURE `cigma2`.`get_varlocation_from_hgvs_cdna` TO 'batch'@'localhost';
GRANT EXECUTE ON PROCEDURE `cigma2`.`determine_codingeffect` TO 'batch'@'localhost';
GRANT EXECUTE ON PROCEDURE `cigma2`.`get_alleles_from_hgvs_cdna` TO 'batch'@'localhost';
GRANT EXECUTE ON PROCEDURE `cigma2`.`make_hgvs` TO 'batch'@'localhost';
GRANT EXECUTE ON PROCEDURE `cigma2`.`classify_by_vartype` TO 'batch'@'localhost';
GRANT EXECUTE ON PROCEDURE `cigma2`.`get_vartype_from_hgvs_cdna` TO 'batch'@'localhost';
GRANT EXECUTE ON PROCEDURE `cigma2`.`determine_varlocation` TO 'batch'@'localhost';
GRANT EXECUTE ON FUNCTION `cigma2`.`reverse_complement` TO 'batch'@'localhost';
GRANT EXECUTE ON PROCEDURE `cigma2`.`get_genomecoord_from_cdnacoord` TO 'batch'@'localhost';

