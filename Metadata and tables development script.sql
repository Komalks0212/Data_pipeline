create schema staging;

create schema meta;

create schema mart;

show search_path;

SET search_path TO staging,mart,public;

create table meta.database_log
(log_id integer NOT NULL GENERATED ALWAYS AS identity,
 proc_name varchar null, 
 error varchar null,
 logged_at timestamp NULL DEFAULT now());

-- drop table meta.clinical_cdisc_domains;
create table meta.clinical_cdisc_domains(
domain_num integer NOT NULL GENERATED ALWAYS AS identity, -- 
domain_name varchar,
domain_description varchar, 
primary_keys varchar,
do_not_truncate boolean default false,
comments varchar
);

INSERT INTO meta.clinical_cdisc_domains
(domain_name, domain_description, primary_keys, do_not_truncate, "comments")
VALUES('BE', 'Biospecimen Events', 'STUDYID, USUBJID, BEREFID, BETERM, BESDTC', false, NULL),
('BS', 'Biospecimen Findings', 'STUDYID, USUBJID, BSREFID, BSTESTCD', false, NULL),
('CP', 'Cell Phenotype Findings', 'STUDYID, USUBJID, CPTESTCD, CPSPEC, VISITNUM, CPTPTREF, CPTPTNUM', false, NULL),
('GF', 'Genomics Findings', 'STUDYID, USUBJID, GFTESTCD, GFSPEC, VISITNUM, GFTPTREF, GFTPTNUM', false, NULL),
('AE', 'Adverse Events', 'STUDYID, USUBJID, AEDECOD, AESTDTC', false, NULL),
('AG', 'Procedure Agents', 'STUDYID, USUBJID, AGTRT, AGSTDTC', false, NULL),
('CE', 'Clinical Events', 'STUDYID, USUBJID, CETERM, CESTDTC', false, NULL),
('CM', 'Concomitant/Prior Medications', 'STUDYID, USUBJID, CMTRT, CMSTDTC', false, NULL),
('CO', 'Comments', 'STUDYID, USUBJID, IDVAR, COREF, CODTC', false, NULL),
('CV', 'Cardiovascular System Findings', 'STUDYID, USUBJID, VISITNUM, CVTESTCD,CVTPTREF, CVTPTNUM', false, NULL),
('DA', 'Drug Accountability', 'STUDYID, USUBJID, DATESTCD, DADTC', false, NULL),
('DD', 'Death Details', 'STUDYID, USUBJID, DDTESTCD, DDDTC', false, NULL),
('DM', 'Demographics', 'STUDYID, USUBJID', false, NULL),
('DS', 'Disposition', 'STUDYID, USUBJID, DSDECOD, DSSTDTC', false, NULL),
('DV', 'Protocol Deviations', 'STUDYID, USUBJID, DVTERM, DVSTDTC', false, NULL),
('EC', 'Exposure as Collected', 'STUDYID, USUBJID, ECTRT, ECSTDTC, ECMOOD', false, NULL),
('EG', 'ECG Test Results', 'STUDYID, USUBJID, EGTESTCD, VISITNUM,EGTPTREF, EGTPTNUM', false, NULL),
('EX', 'Exposure', 'STUDYID, USUBJID, EXTRT, EXSTDTC', false, NULL),
('FA', 'Findings About Events or Interventions', 'STUDYID, USUBJID, FATESTCD, FAOBJ,VISITNUM, FATPTREF, FATPTNUM', false, NULL),
('FT', 'Functional Tests', 'STUDYID, USUBJID, TESTCD, VISITNUM, FTTPTREF, FTTPTNUM', false, NULL),
('HO', 'Healthcare Encounters', 'STUDYID, USUBJID, HOTERM, HOSTDTC', false, NULL),
('IE', 'Inclusion/Exclusion Criteria Not Met', 'STUDYID, USUBJID, IETESTCD', false, NULL),
('IS', 'Immunogenicity Specimen Assessment', 'STUDYID, USUBJID, ISTESTCD, VISITNUM', false, NULL),
('LB', 'Laboratory Test Results', 'STUDYID, USUBJID, LBTESTCD, LBSPEC, VISITNUM, LBTPTREF, LBTPTNUM', false, NULL),
('MB', 'Microbiology Specimen', 'STUDYID, USUBJID, MBTESTCD, VISITNUM, MBTPTREF, MBTPTNUM', false, NULL),
('MH', 'Medical History', 'STUDYID, USUBJID, MHDECOD', false, NULL),
('MI', 'Microscopic Findings', 'STUDYID, USUBJID, MISPEC, MITESTCD', false, NULL),
('MK', 'Musculoskeletal System Findings', 'STUDYID, USUBJID, VISITNUM, MKTESTCD, MKLOC, MKLAT', false, NULL),
('ML', 'Meal Data', 'STUDYID, USUBJID, MLTRT, MLSTDTC', false, NULL),
('MO', 'Morphology', 'STUDYID, USUBJID, VISITNUM, MOTESTCD, MOLOC, MOLAT', false, NULL),
('MS', 'Microbiology Susceptibility', 'STUDYID, USUBJID, MSTESTCD, VISITNUM, MSTPTREF, MSTPTNUM', false, NULL),
('NV', 'Nervous System Findings', 'STUDYID, USUBJID, VISITNUM, CVTPTNUM, CVLOC, NVTESTCD', false, NULL),
('OE', 'Ophthalmic Examinations', 'STUDYID, USUBJID, FOCID, OETESTCD, OETSTDTL, OEMETHOD, OELOC, OELAT, OEDIR, VISITNUM, OEDTC, OETPTREF, OETPTNUM, OEREPNUM', false, NULL),
('OI', 'Non-host Organism Identifiers', 'NHOID, OISEQ', false, NULL),
('PC', 'Pharmacokinetics Concentrations', 'STUDYID, USUBJID, PCTESTCD, VISITNUM, PCTPTREF, PCTPTNUM', false, NULL),
('PE', 'Physical Examination', 'STUDYID, USUBJID, PETESTCD, VISITNUM', false, NULL),
('PP', 'Pharmacokinetics Parameters', 'STUDYID, USUBJID, PPTESTCD, PPCAT, VISITNUM, PPTPTREF', false, NULL),
('PR', 'Procedures', 'STUDYID, USUBJID, PRTRT, PRSTDTC', false, NULL),
('QS', 'Questionnaires', 'STUDYID, USUBJID, QSCAT, QSSCAT, VISITNUM, QSTESTCD', false, NULL),
('RE', 'Respiratory System Findings', 'STUDYID, USUBJID, VISITNUM, RETESTCD, RETPTNUM, REREPNUM', false, NULL),
('RELREC', 'Related Records', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, RELID', false, NULL),
('RELSUB', 'Related Subjects', 'STUDYID, USUBJID, RSUBJID, SREL', false, NULL),
('RP', 'Reproductive System Findings', 'STUDYID, DOMAIN, USUBJID, RPTESTCD, VISITNUM', false, NULL),
('RS', 'Disease Response', 'STUDYID, USUBJID, RSTESTCD, VISITNUM, RSTPTREF, RSTPTNUM, RSEVAL, RSEVALID', false, NULL),
('SC', 'Subject Characteristics', 'STUDYID, USUBJID, SCTESTCD', false, NULL),
('SE', 'Subject Elements', 'STUDYID, USUBJID, ETCD, SESTDTC', false, NULL),
('SM', 'Subject Disease Milestones', 'STUDYID, USUBJID, MIDS', false, NULL),
('SR', 'Skin Response', 'STUDYID, USUBJID, SRTESTCD, SROBJ, VISITNUM, SRTPTREF, SRTPTNUM', false, NULL),
('SS', 'Subject Status', 'STUDYID, USUBJID, SSTESTCD, VISITNUM', false, NULL),
('SU', 'Substance Use', 'STUDYID, USUBJID, SUTRT, SUSTDTC', false, NULL),
('SV', 'Subject Visits', 'STUDYID, USUBJID, VISITNUM', false, NULL),
('TA', 'Trial Arms', 'STUDYID, ARMCD, TAETORD', false, NULL),
('TD', 'Trial Disease Assessments', 'STUDYID, TDORDER', false, NULL),
('TE', 'Trial Elements', 'STUDYID, ETCD', false, NULL),
('TI', 'Trial Inclusion/Exclusion Criteria', 'STUDYID, IETESTCD', false, NULL),
('TM', 'Trial Disease Milestones', 'STUDYID, MIDSTYPE', false, NULL),
('TR', 'Tumor/Lesion Results', 'STUDYID, USUBJID, TRTESTCD, EVALID, VISITNUM', false, NULL),
('TS', 'Trial Summary Information', 'STUDYID, TSPARMCD, TSSEQ', false, NULL),
('TU', 'Tumor/Lesion Identification', 'STUDYID, USUBJID, EVALID, LNKID', false, NULL),
('TV', 'Trial Visits', 'STUDYID, ARM, VISIT', false, NULL),
('UR', 'Urinary System Findings', 'STUDYID, USUBJID, VISITNUM, URTESTCD, URLOC, URLAT, URDIR', false, NULL),
('VS', 'Vital Signs', 'STUDYID, USUBJID, VSTESTCD, VISITNUM, VSTPTREF, VSTPTNUM', false, NULL),
('SUPPAE', 'Supplemental Qualifiers for AE', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPCM', 'Supplemental Qualifiers for CM', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPDM', 'Supplemental Qualifiers for DM', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPDS', 'Supplemental Qualifiers for DS', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPDV', 'Supplemental Qualifiers for DV', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPEC', 'Supplemental Qualifiers for EC', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPEG', 'Supplemental Qualifiers for EG', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPEX', 'Supplemental Qualifiers for EX', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPFA', 'Supplemental Qualifiers for FA', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPIS', 'Supplemental Qualifiers for IS', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPLB', 'Supplemental Qualifiers for LB', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPMH', 'Supplemental Qualifiers for MH', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPPE', 'Supplemental Qualifiers for PE', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPPR', 'Supplemental Qualifiers for PR', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPTR', 'Supplemental Qualifiers for TR', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPTU', 'Supplemental Qualifiers for TU', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPVS', 'Supplemental Qualifiers for VS', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('RELSPEC', 'Related Specimens', 'STUDYID, USUBJID, REFID', false, NULL),
('SUPPRS', 'Supplemental Qualifiers for RS', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPPP', 'Supplemental Qualifiers for PP', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPMI', 'Supplemental Qualifiers for MI', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL),
('SUPPDD', 'Supplemental Qualifiers for DD', 'STUDYID, RDOMAIN, USUBJID, IDVAR, IDVARVAL, QNAM', false, NULL);

--drop table meta.clinical_cdisc_domains_variable
create table meta.clinical_cdisc_domains_variable
( id integer NOT NULL GENERATED ALWAYS AS identity primary key,
domain_name varchar,
variable varchar,
variable_datatype varchar,
sdtm_v_1pt4 boolean,
sdtm_v_1pt7 boolean,
sdtm_v_2pt0 boolean,
optional_variable boolean,
comments varchar
);

select * from meta.clinical_cdisc_domains_variable;

INSERT INTO meta.clinical_cdisc_domains_variable
(domain_name, variable, variable_datatype, sdtm_v_1pt4, sdtm_v_1pt7, sdtm_v_2pt0, optional_variable, "comments")
values
('ae', 'studyid', 'Char', true, true, true, NULL, NULL),
('ae', 'domain', 'Char', true, true, true, NULL, NULL),
('ae', 'usubjid', 'Char', true, true, true, NULL, NULL),
('ae', 'spdevid', 'Char', false, false, true, NULL, NULL),
('ae', 'aeseq', 'Num', true, true, true, NULL, NULL),
('ae', 'aegrpid', 'Char', true, true, true, NULL, NULL),
('ae', 'aerefid', 'Char', true, true, true, NULL, NULL),
('ae', 'aespid', 'Char', true, true, true, NULL, NULL),
('ae', 'aeterm', 'Char', true, true, true, NULL, NULL),
('ae', 'aemodify', 'Char', true, true, true, NULL, NULL),
('ae', 'aellt', 'Char', true, true, true, NULL, NULL),
('ae', 'aelltcd', 'Num', true, true, true, NULL, NULL),
('ae', 'aedecod', 'Char', true, true, true, NULL, NULL),
('ae', 'aeptcd', 'Num', true, true, true, NULL, NULL),
('ae', 'aehlt', 'Char', true, true, true, NULL, NULL),
('ae', 'aehltcd', 'Num', true, true, true, NULL, NULL),
('ae', 'aehlgt', 'Char', true, true, true, NULL, NULL),
('ae', 'aehlgtcd', 'Num', true, true, true, NULL, NULL),
('ae', 'aecat', 'Char', true, true, true, NULL, NULL),
('ae', 'aescat', 'Char', true, true, true, NULL, NULL),
('ae', 'aepresp', 'Char', true, true, true, NULL, NULL),
('ae', 'aebodsys', 'Char', true, true, true, NULL, NULL),
('ae', 'aebdsycd', 'Num', true, true, true, NULL, NULL),
('ae', 'aesoc', 'Char', true, true, true, NULL, NULL),
('ae', 'aesoccd', 'Num', true, true, true, NULL, NULL),
('ae', 'aeloc', 'Char', true, true, true, NULL, NULL),
('ae', 'aesev', 'Char', true, true, true, NULL, NULL),
('ae', 'aeser', 'Char', true, true, true, NULL, NULL),
('ae', 'aeacn', 'Char', true, true, true, NULL, NULL),
('ae', 'aeacnoth', 'Char', true, true, true, NULL, NULL),
('ae', 'aeacndev', 'Char', false, false, true, NULL, NULL),
('ae', 'aerel', 'Char', true, true, true, NULL, NULL),
('ae', 'aerldev', 'Char', false, false, true, NULL, NULL),
('ae', 'aerelnst', 'Char', true, true, true, NULL, NULL),
('ae', 'aepatt', 'Char', true, true, true, NULL, NULL),
('ae', 'aeout', 'Char', true, true, true, NULL, NULL),
('ae', 'aescan', 'Char', true, true, true, NULL, NULL),
('ae', 'aescong', 'Char', true, true, true, NULL, NULL),
('ae', 'aesdisab', 'Char', true, true, true, NULL, NULL),
('ae', 'aesdth', 'Char', true, true, true, NULL, NULL),
('ae', 'aeshosp', 'Char', true, true, true, NULL, NULL),
('ae', 'aeslife', 'Char', true, true, true, NULL, NULL),
('ae', 'aesod', 'Char', true, true, true, NULL, NULL),
('ae', 'aesmie', 'Char', true, true, true, NULL, NULL),
('ae', 'aesintv', 'Char', false, false, true, NULL, NULL),
('ae', 'aeunant', 'Char', false, false, true, NULL, NULL),
('ae', 'aerlprt', 'Char', false, false, true, NULL, NULL),
('ae', 'aerlprc', 'Char', false, false, true, NULL, NULL),
('ae', 'aecontrt', 'Char', true, true, true, NULL, NULL),
('ae', 'aetoxgr', 'Char', true, true, true, NULL, NULL),
('ae', 'taetord', 'Num', true, true, true, NULL, NULL),
('ae', 'epoch', 'Char', true, true, true, NULL, NULL),
('ae', 'aestdtc', 'Char', true, true, true, NULL, NULL),
('ae', 'aeendtc', 'Char', true, true, true, NULL, NULL),
('ae', 'aestdy', 'Num', true, true, true, NULL, NULL),
('ae', 'aeendy', 'Num', true, true, true, NULL, NULL),
('ae', 'aedur', 'Char', true, true, true, NULL, NULL),
('ae', 'aeenrf', 'Char', true, true, true, NULL, NULL),
('ae', 'aeenrtpt', 'Char', true, true, true, NULL, NULL),
('ae', 'aeentpt', 'Char', true, true, true, NULL, NULL),
('ag', 'studyid', 'Char', false, true, true, NULL, NULL),
('ag', 'domain', 'Char', false, true, true, NULL, NULL),
('ag', 'usubjid', 'Char', false, true, true, NULL, NULL),
('ag', 'agseq', 'Num', false, true, true, NULL, NULL),
('ag', 'aggrpid', 'Char', false, true, true, NULL, NULL),
('ag', 'agspid', 'Char', false, true, true, NULL, NULL),
('ag', 'aglnkid', 'Char', false, true, true, NULL, NULL),
('ag', 'aglnkgrp', 'Char', false, true, true, NULL, NULL),
('ag', 'agtrt', 'Char', false, true, true, NULL, NULL),
('ag', 'agmodify', 'Char', false, true, true, NULL, NULL),
('ag', 'agdecod', 'Char', false, true, true, NULL, NULL),
('ag', 'agcat', 'Char', false, true, true, NULL, NULL),
('ag', 'agscat', 'Char', false, true, true, NULL, NULL),
('ag', 'agpresp', 'Char', false, true, true, NULL, NULL),
('ag', 'agoccur', 'Char', false, true, true, NULL, NULL),
('ag', 'agstat', 'Char', false, true, true, NULL, NULL),
('ag', 'agreasnd', 'Char', false, true, true, NULL, NULL),
('ag', 'agclas', 'Char', false, true, true, NULL, NULL),
('ag', 'agclascd', 'Char', false, true, true, NULL, NULL),
('ag', 'agdose', 'Num', false, true, true, NULL, NULL),
('ag', 'agdostxt', 'Char', false, true, true, NULL, NULL),
('ag', 'agdosu', 'Char', false, true, true, NULL, NULL),
('ag', 'agdosfrm', 'Char', false, true, true, NULL, NULL),
('ag', 'agdosfrq', 'Char', false, true, true, NULL, NULL),
('ag', 'agroute', 'Char', false, true, true, NULL, NULL),
('ag', 'visitnum', 'Num', false, true, true, NULL, NULL),
('ag', 'visit', 'Char', false, true, true, NULL, NULL),
('ag', 'visitdy', 'Num', false, true, true, NULL, NULL),
('ag', 'taetord', 'Num', false, true, true, NULL, NULL),
('ag', 'epoch', 'Char', false, true, true, NULL, NULL),
('ag', 'agstdtc', 'Char', false, true, true, NULL, NULL),
('ag', 'agendtc', 'Char', false, true, true, NULL, NULL),
('ag', 'agstdy', 'Num', false, true, true, NULL, NULL),
('ag', 'agendy', 'Num', false, true, true, NULL, NULL),
('ag', 'agdur', 'Char', false, true, true, NULL, NULL),
('ag', 'agstrf', 'Char', false, true, true, NULL, NULL),
('ag', 'agenrf', 'Char', false, true, true, NULL, NULL),
('ag', 'agstrtpt', 'Char', false, true, true, NULL, NULL),
('ag', 'agsttpt', 'Char', false, true, true, NULL, NULL),
('ag', 'agenrtpt', 'Char', false, true, true, NULL, NULL),
('ag', 'agentpt', 'Char', false, true, true, NULL, NULL),
('be', 'studyid', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'domain', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'usubjid', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'spdevid', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'beseq', 'Num', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'begrpid', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'berefid', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'bespid', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'beterm', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'bemodify', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'bedecod', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'becat', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'bescat', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'beloc', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'beparty', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'beprtyid', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'visitnum', 'Num', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'visit', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'visitdy', 'Num', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'bedtc', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'bestdtc', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'beendtc', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'bestdy', 'Num', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'beendy', 'Num', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('be', 'bedur', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'studyid', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'domain', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'usubjid', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'spdevid', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsseq', 'Num', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsgrpid', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsrefid', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsspid', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bstestcd', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bstest', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bscat', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsscat', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsorres', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsorresu', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsstresc', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsstresn', 'Num', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsstresu', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsstat', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsreasnd', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsnam', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsspec', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsantreg', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsspccnd', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsmethod', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsblfl', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'visitnum', 'Num', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'visit', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'visitdy', 'Num', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsdtc', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsdy', 'Num', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bstpt', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bstptnum', 'Num', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bseltm', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bstptref', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('bs', 'bsrftdtc', 'Char', false, true, true, NULL, 'This domain is available for SDTM v 1.7 as part of ''SDTMIG for Pharmacogenomics/Genetics'' instead of the SDTMIG v 3.3'),
('ce', 'studyid', 'Char', true, true, true, NULL, NULL),
('ce', 'domain', 'Char', true, true, true, NULL, NULL),
('ce', 'usubjid', 'Char', true, true, true, NULL, NULL),
('ce', 'ceseq', 'Num', true, true, true, NULL, NULL),
('ce', 'cegrpid', 'Char', true, true, true, NULL, NULL),
('ce', 'cerefid', 'Char', true, true, true, NULL, NULL),
('ce', 'cespid', 'Char', true, true, true, NULL, NULL),
('ce', 'ceterm', 'Char', true, true, true, NULL, NULL),
('ce', 'cedecod', 'Char', true, true, true, NULL, NULL),
('ce', 'cecat', 'Char', true, true, true, NULL, NULL),
('ce', 'cescat', 'Char', true, true, true, NULL, NULL),
('ce', 'cepresp', 'Char', true, true, true, NULL, NULL),
('ce', 'ceoccur', 'Char', true, true, true, NULL, NULL),
('ce', 'cestat', 'Char', true, true, true, NULL, NULL),
('ce', 'cereasnd', 'Char', true, true, true, NULL, NULL),
('ce', 'cebodsys', 'Char', true, true, true, NULL, NULL),
('ce', 'cesev', 'Char', true, true, true, NULL, NULL),
('ce', 'taetord', 'Num', true, true, true, NULL, NULL),
('ce', 'epoch', 'Char', true, true, true, NULL, NULL),
('ce', 'cedtc', 'Char', true, true, true, NULL, NULL),
('ce', 'cestdtc', 'Char', true, true, true, NULL, NULL),
('ce', 'ceendtc', 'Char', true, true, true, NULL, NULL),
('ce', 'cedy', 'Num', true, true, true, NULL, NULL),
('ce', 'cestdy', 'Num', true, true, true, NULL, NULL),
('ce', 'ceendy', 'Num', true, true, true, NULL, NULL),
('ce', 'cestrf', 'Char', true, true, true, NULL, NULL),
('ce', 'ceenrf', 'Char', true, true, true, NULL, NULL),
('ce', 'cestrtpt', 'Char', true, true, true, NULL, NULL),
('ce', 'cesttpt', 'Char', true, true, true, NULL, NULL),
('ce', 'ceenrtpt', 'Char', true, true, true, NULL, NULL),
('ce', 'ceentpt', 'Char', true, true, true, NULL, NULL),
('cm', 'studyid', 'Char', true, true, true, NULL, NULL),
('cm', 'domain', 'Char', true, true, true, NULL, NULL),
('cm', 'usubjid', 'Char', true, true, true, NULL, NULL),
('cm', 'cmseq', 'Num', true, true, true, NULL, NULL),
('cm', 'cmgrpid', 'Char', true, true, true, NULL, NULL),
('cm', 'cmspid', 'Char', true, true, true, NULL, NULL),
('cm', 'cmtrt', 'Char', true, true, true, NULL, NULL),
('cm', 'cmmodify', 'Char', true, true, true, NULL, NULL);


-- create all domain tables according to CDISC SDTM standard

call staging.proc_create_domain_table('staging', 'load_domain_');
call staging.proc_create_domain_table('mart', 'domain_');

--drop procedure pr_create_domain_table;
CREATE OR REPLACE PROCEDURE staging.proc_create_domain_table(pvi_schema_name varchar, pvi_tab_name_prefix varchar default '')
 LANGUAGE plpgsql
AS $procedure$
DECLARE 
	vv_domain_name varchar;
	vv_domain_variable varchar;
	variable_list varchar;
	vv_variable_datatype varchar;
	vv_datatype varchar;
	vv_proc_name varchar := 'proc_create_domain_table';
	error_msg varchar; 

begin
	for vv_domain_name in (select domain_name from meta.clinical_cdisc_domains order by domain_num) loop 
		variable_list := '';
	
		if (pvi_tab_name_prefix || lower(vv_domain_name)) not in (select table_name from information_schema.tables
where table_schema = pvi_schema_name) then 
			
			RAISE NOTICE '% doesnt exist', (pvi_tab_name_prefix || lower(vv_domain_name));
		
			for vv_domain_variable, vv_variable_datatype in (select variable,variable_datatype from meta.clinical_cdisc_domains_variable
where upper(domain_name) = vv_domain_name order by id) loop		
							
--				if vv_variable_datatype = 'Char' then
--					vv_datatype := 'varchar';
--				elseif vv_variable_datatype = 'Num' then
--					vv_datatype := 'numeric';
--				end if;
	
				vv_datatype := 'varchar';	
			
				variable_list := concat(variable_list, vv_domain_variable, ' ', vv_datatype, ', ');
			
			end loop;
		
			variable_list := rtrim(variable_list, ', ');
	
			execute 'create table ' || pvi_schema_name || '.' || pvi_tab_name_prefix || vv_domain_name|| '( ' || variable_list || ' );' ; 
		
		else
			RAISE NOTICE '% already exists', (pvi_tab_name_prefix || lower(vv_domain_name));
			continue;
		end if;
	
	end loop;

	exception when others then 
	
		error_msg := 'error occurred while executing procedure ' || coalesce(vv_proc_name,'')   ||  ' while creating table for domain : ' || coalesce(vv_domain_name,'') ; 
		
		EXECUTE 'INSERT INTO meta.database_log(proc_name, error) VALUES($1, $2) RETURNING load_id'
		USING vv_proc_name, error_msg;    
END;
$procedure$
;


select * from meta.database_log
order by log_id desc;

call staging.proc_delete_clin_tables('mart', 'clin_domain_');
						
CREATE OR REPLACE PROCEDURE staging.proc_delete_clin_tables(pvi_schema_name varchar, pvi_tab_name_prefix varchar default '') 
LANGUAGE plpgsql
AS $procedure$
    declare  

		vv_table_name varchar;
		vv_proc_name varchar := 'proc_delete_clin_tables';
		error_msg varchar;
	
	begin
		
		for vv_table_name in (SELECT table_name
							FROM information_schema.tables is_tab join meta.clinical_cdisc_domains metadata_tab on is_tab.table_name = (pvi_tab_name_prefix || lower(metadata_tab.domain_name))
							WHERE is_tab.table_schema = pvi_schema_name 
							order by table_name limit 1)	loop 
								
								execute format('drop table $1 ;') , (pvi_schema_name || '.' || vv_table_name); 			
		end loop;
						
	exception when others then 
		 
		error_msg := 'error occurred while executing procedure ' || coalesce(vv_proc_name,'')   ||  ' while deleting table ' || coalesce(vv_table_name,'') || ' error: '  || sqlerrm;  
		
		EXECUTE 'INSERT INTO meta.database_log(proc_name, error) VALUES($1, $2)'
		USING vv_proc_name, error_msg;
	
end;
$procedure$;


create table staging.generic_load_table
(   id integer NOT NULL GENERATED ALWAYS AS identity primary key,
	column1 varchar,
	column2 varchar,
	column3 varchar,
	column4 varchar,
	column5 varchar,
	column6 varchar,
	column7 varchar,
	column8 varchar,
	column9 varchar,
	column10 varchar,
	column11 varchar,
	column12 varchar,
	column13 varchar,
	column14 varchar,
	column15 varchar,
	column16 varchar,
	column17 varchar,
	column18 varchar,
	column19 varchar,
	column20 varchar,
	column21 varchar,
	column22 varchar,
	column23 varchar,
	column24 varchar,
	column25 varchar,
	column26 varchar,
	column27 varchar,
	column28 varchar,
	column29 varchar,
	column30 varchar,
	column31 varchar,
	column32 varchar,
	column33 varchar,
	column34 varchar,
	column35 varchar,
	column36 varchar,
	column37 varchar,
	column38 varchar,
	column39 varchar,
	column40 varchar,
	column41 varchar,
	column42 varchar,
	column43 varchar,
	column44 varchar,
	column45 varchar,
	column46 varchar,
	column47 varchar,
	column48 varchar,
	column49 varchar,
	column50 varchar,
	column51 varchar,
	column52 varchar,
	column53 varchar,
	column54 varchar,
	column55 varchar,
	column56 varchar,
	column57 varchar,
	column58 varchar,
	column59 varchar,
	column60 varchar,
	column61 varchar,
	column62 varchar,
	column63 varchar,
	column64 varchar,
	column65 varchar,
	column66 varchar,
	column67 varchar,
	column68 varchar,
	column69 varchar,
	column70 varchar,
	column71 varchar,
	column72 varchar,
	column73 varchar,
	column74 varchar,
	column75 varchar,
	column76 varchar,
	column77 varchar,
	column78 varchar,
	column79 varchar,
	column80 varchar,
	column81 varchar,
	column82 varchar,
	column83 varchar,
	column84 varchar,
	column85 varchar,
	column86 varchar,
	column87 varchar,
	column88 varchar,
	column89 varchar,
	column90 varchar,
	column91 varchar,
	column92 varchar,
	column93 varchar,
	column94 varchar,
	column95 varchar,
	column96 varchar,
	column97 varchar,
	column98 varchar,
	column99 varchar,
	column100 varchar
);

select * from meta.load_tables_population_log;

call proc_update_log_table(pvi_purpose:= 'INSERT'::varchar, pvi_table_name:= 'dm.tab'::varchar);
call proc_update_log_table(pvi_purpose:= 'UPDATE', pvo_load_id:= 1, pvi_status_ld_spec_tab := 'E');
