# longrangerWgs

Workflow that takes demultiplexed FASTQ files from a whole genome sample and performs alignment, de-duplication and filtering, and uses the Chromium molecular barcodes to call and phases SNPs, indels and structural variants.

## Overview

## Usage

### Cromwell
```
java -jar cromwell.jar run longrangerWgs.wdl --inputs inputs.json
```

### Inputs

#### Required workflow parameters:
Parameter|Value|Description
---|---|---
`runID`|String|A unique run ID string.
`samplePrefix`|String|Sample name (FASTQ file prefix). Can take multiple comma-separated values.
`fastqs`|Array[File]|Array of input fastqs.
`referenceDirectory`|String|Path to 10x compatible reference.


#### Optional workflow parameters:
Parameter|Value|Default|Description
---|---|---|---
`samplePrefix`|String?|None|Sample name (FASTQ file prefix). Can take multiple comma-separated values.
`sex`|String?|None|(Optional) Sex of the sample: male or female. Sex will be detected based on coverage if not supplied.
`vcMode`|String?|freebayes|(Required, except when specifying --precalled) Must be one of: 'freebayes', 'gatk:/path/to/GenomeAnalysisTK.jar', or 'disable'.
`precalled`|String?|None|(Optional) Path to a 'pre-called' VCF file. Variants in this file will be phased. When setting --precalled, do not specifiy a --vcmode.
`timeout`|Int?|168h|Restricts longranger to run in the specified time budget.

#### Optional task parameters:
Parameter|Value|Default|Description
---|---|---|---
`wgs.modules`|String?|"longranger"|Environment module name to load before command execution.
`wgs.longranger`|String?|"longranger"|
`wgs.mem`|Int|128|

### Outputs

Output | Type | Description
---|---|---
`runSummary`|File|Run summary metrics in CSV format.
`phasedPossortedBam`|File|Aligned reads annotated with barcode information.
`phasedPossortedBamIndex`|File|Index for phased_possorted_bam.bam
`vcfPhased`|File|VCF annotated with barcode and phasing information.
`vcfIndex`|File|Index for phased_variants.vcf.gz
`largeScaleSVCalls`|File|Large-scale (>=30Kbp or inter-chromosomal) structural variant and CNV calls, excluding low confidence candidates, in BEDPE format.
`largeScaleSVCandidates`|File|Large-scale (>=30Kbp or inter-chromosomal) structural variant and CNV calls, including low confidence candidates, in BEDPE format.
`largeScaleSVs`|File|Large-scale (>=30Kbp or inter-chromosomal) structural variant and CNV calls, including low confidence candidates, in VCF format.
`largeScaleSVsIndex`|File|Index for large_svs.vcf.gz
`midscaleDeletions`|File|Mid-scale deletion structural variant calls (50bp-30Kbp).
`midscaleDeletionsIndex`|File|Index for dels.vcf.gz
`loupe`|File|	File that can be opened in the Loupe genome browser.


## Niassa + Cromwell

This WDL workflow is wrapped in a Niassa workflow (https://github.com/oicr-gsi/pipedev/tree/master/pipedev-niassa-cromwell-workflow) so that it can used with the Niassa metadata tracking system (https://github.com/oicr-gsi/niassa).

* Building
```
mvn clean install
```

* Testing
```
mvn clean verify \
-Djava_opts="-Xmx1g -XX:+UseG1GC -XX:+UseStringDeduplication" \
-DrunTestThreads=2 \
-DskipITs=false \
-DskipRunITs=false \
-DworkingDirectory=/path/to/tmp/ \
-DschedulingHost=niassa_oozie_host \
-DwebserviceUrl=http://niassa-url:8080 \
-DwebserviceUser=niassa_user \
-DwebservicePassword=niassa_user_password \
-Dcromwell-host=http://cromwell-url:8000
```

## Support

For support, please file an issue on the [Github project](https://github.com/oicr-gsi) or send an email to gsi@oicr.on.ca .

_Generated with wdl_doc_gen (https://github.com/oicr-gsi/wdl_doc_gen/)_
