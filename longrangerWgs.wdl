version 1.0

workflow longrangerWgs {
  input {
    String runID
    String fastqDirectory
    String referenceDirectory
    String? sex
    String? vcMode
    String? precalled
  }

  call wgs {
    input:
      runID = runID,
      fastqDirectory = fastqDirectory,
      referenceDirectory = referenceDirectory,
      sex = sex,
      vcMode = vcMode,
      precalled = precalled
  }

  output {
    File runSummary = wgs.runSummary
    File phasedPossortedBam = wgs.phasedPossortedBam
    File phasedPossortedBamIndex = wgs.phasedPossortedBamIndex
    File vcfPhased = wgs.vcfPhased
    File vcfIndex = wgs.vcfIndex
    File largeScaleSVCalls = wgs.largeScaleSVCalls
    File largeScaleSVCandidates = wgs.largeScaleSVCandidates
    File largeScaleSVs = wgs.largeScaleSVs
    File largeScaleSVsIndex = wgs.largeScaleSVsIndex
    File midscaleDeletions = wgs.midscaleDeletions
    File midscaleDeletionsIndex = wgs.midscaleDeletionsIndex
    File loupe = wgs.loupe
  }

  parameter_meta {
    runID: "A unique run ID string."
    fastqDirectory: "Path to folder containing fastq files."
    referenceDirectory: "Path to 10x compatible reference."
    sex: "(Optional) Sex of the sample: male or female. Sex will be detected based on coverage if not supplied."
    vcMode: "(Required, except when specifying --precalled) Must be one of: 'freebayes', 'gatk:/path/to/GenomeAnalysisTK.jar', or 'disable'."
    precalled: "(Optional) Path to a 'pre-called' VCF file. Variants in this file will be phased. When setting --precalled, do not specifiy a --vcmode."
  }

  meta {
    author: "Angie Mosquera"
    email: "Angie.Mosquera@oicr.on.ca"
    description: "Workflow that takes demultiplexed FASTQ files from a whole genome sample and performs alignment, de-duplication and filtering, and uses the Chromium molecular barcodes to call and phases SNPs, indels and structural variants."
    dependencies: []
  }
}

task wgs {
  input {
    String? modules = "longranger"
    String? longranger = "longranger"
    String runID
    String fastqDirectory
    String referenceDirectory
    String? sex
    String? vcMode
    String? precalled
  }

  command <<<
   ~{longranger} wgs \
   --id "~{runID}" \
   --fastqs "~{fastqDirectory}" \
   --reference "~{referenceDirectory}" \
   ~{"--sex"} "~{sex}" \
   ~{"--vcmode"} "~{vcMode}" \
   ~{"--precalled"} "~{precalled}"
  >>>

  runtime {
    modules: "~{modules}"
  }

  output {
    File runSummary = "outs/summary.csv"
    File phasedPossortedBam = "outs/phased_possorted_bam.bam"
    File phasedPossortedBamIndex = "outs/phased_possorted_bam.bam.bai"
    File vcfPhased = "outs/phased_variants.vcf.gz"
    File vcfIndex = "outs/phased_variants.vcf.gz.tbi"
    File largeScaleSVCalls = "outs/large_sv_calls.bedpe"
    File largeScaleSVCandidates = "outs/large_sv_candidates.bedpe"
    File largeScaleSVs = "outs/large_svs.vcf.gz"
    File largeScaleSVsIndex = "outs/large_svs.vcf.gz.tbi"
    File midscaleDeletions = "outs/dels.vcf.gz"
    File midscaleDeletionsIndex = "outs/dels.vcf.gz.tbi"
    File loupe = "outs/loupe.loupe"
  }

  parameter_meta {
    runID: "A unique run ID string."
    fastqDirectory: "Path to folder containing fastq files."
    referenceDirectory: "Path to 10x compatible reference."
    sex: "(Optional) Sex of the sample: male or female. Sex will be detected based on coverage if not supplied."
    vcMode: "(Required, except when specifying --precalled) Must be one of: 'freebayes', 'gatk:/path/to/GenomeAnalysisTK.jar', or 'disable'."
    precalled: "(Optional) Path to a 'pre-called' VCF file. Variants in this file will be phased. When setting --precalled, do not specifiy a --vcmode."
    modules: "Environment module name to load before command execution."
  }

  meta {
    output_meta: {
      runSummary: "Run summary metrics in CSV format.",
      phasedPossortedBam: "Aligned reads annotated with barcode information.",
      phasedPossortedBamIndex: "Index for phased_possorted_bam.bam",
      vcfPhased: "VCF annotated with barcode and phasing information.",
      vcfIndex: "Index for phased_variants.vcf.gz",
      largeScaleSVCalls: "Large-scale (>=30Kbp or inter-chromosomal) structural variant and CNV calls, excluding low confidence candidates, in BEDPE format.",
      largeScaleSVCandidates: "Large-scale (>=30Kbp or inter-chromosomal) structural variant and CNV calls, including low confidence candidates, in BEDPE format.",
      largeScaleSVs: "Large-scale (>=30Kbp or inter-chromosomal) structural variant and CNV calls, including low confidence candidates, in VCF format.",
      largeScaleSVsIndex: "Index for large_svs.vcf.gz",
      midscaleDeletions: "Mid-scale deletion structural variant calls (50bp-30Kbp).",
      midscaleDeletionsIndex: "Index for dels.vcf.gz",
      loupe: "	File that can be opened in the Loupe genome browser."
    }
  }
}