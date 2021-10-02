## ---- echo=FALSE, results="hide", message=FALSE-------------------------------
knitr::opts_chunk$set(error=FALSE, message=FALSE, warning=FALSE)
library(BiocStyle)
library(magmaR)
library(vcr)

TOKEN <- magmaR:::.get_sysenv_or_mock("TOKEN")
prod <- magmaRset(TOKEN)

vcr::vcr_configure(
    filter_sensitive_data = list("<<<my_token>>>" = TOKEN),
    dir = "../tests/fixtures"
)
insert_cassette(name = "Upload-vignette")

## -----------------------------------------------------------------------------
revs <- list(
    "biospecimen" = list(
        "EXAMPLE-HS1-WB1" = list(biospecimen_type = "Whole Blood"),
        "EXAMPLE-HS2-WB1" = list(biospecimen_type = "Whole Blood")
        ),
    "rna_seq" = list(
        "EXAMPLE-HS1-WB1-RSQ1" = list(fraction = "Tcells")
    )
)
updateValues(
    target = prod,
    project = "example",
    revisions = revs,
    auto.proceed = TRUE) ## <---

## -----------------------------------------------------------------------------
library(magmaR)
retrieveAttributes(target = prod, "example", "biospecimen")
retrieveAttributes(target = prod, "example", "rna_seq")

## ---- eval = FALSE------------------------------------------------------------
#  ### From a csv
#  updateMatrix(
#      target = prod,
#      projectName = "example",
#      modelName = "rna_seq",
#      attributeName = "gene_counts",
#      matrix = "path/to/rna_seq_counts.csv")
#  
#  ### From a tsv, set the 'separator' input to "\t"
#  updateMatrix(
#      target = prod,
#      projectName = "example",
#      modelName = "rna_seq",
#      attributeName = "gene_counts",
#      matrix = "path/to/rna_seq_counts.tsv",
#      # Use separator to adjust parsing for tab-separated values
#      separator = "\t")
#  
#  ### From an already loaded matrix:
#  matrix <- retrieveMatrix(target = prod, "example", "rna_seq", "all", "gene_counts")
#  updateMatrix(
#      target = prod,
#      projectName = "example",
#      modelName = "rna_seq",
#      attributeName = "gene_counts",
#      matrix = matrix)

## ---- include = FALSE---------------------------------------------------------
matrix <- retrieveMatrix(target = prod, "example", "rna_seq", "all", "gene_counts")

## -----------------------------------------------------------------------------
head(matrix, n = c(6,2))

## ---- eval = FALSE------------------------------------------------------------
#  ### From a csv
#  updateFromDF(
#      target = prod,
#      projectName = "example",
#      modelName = "rna_seq",
#      df = "path/to/rna_seq_attributes.csv")
#  
#  ### From a tsv, set the 'separator' input to "\t"
#  updateFromDF(
#      target = prod,
#      projectName = "example",
#      modelName = "rna_seq",
#      df = "path/to/rna_seq_attributes.tsv",
#      # Use separator to adjust parsing for tab-separated values
#      separator = "\t")
#  
#  ### From an already loaded data.frame:
#  df <- retrieve(target = prod, "example", "rna_seq", "all",
#                 c("tube_name", "cell_number", "fraction"))
#  updateFromDF(
#      target = prod,
#      projectName = "example",
#      modelName = "rna_seq",
#      df = df)

## ---- include = FALSE---------------------------------------------------------
df <- retrieve(target = prod, "example", "rna_seq", "all",
               c("tube_name", "cell_number", "fraction"))

## -----------------------------------------------------------------------------
head(df, n = c(6,3))

## ---- eval = FALSE------------------------------------------------------------
#  # Create 'revisions'
#  revs <- list(
#      "biospecimen" = list(
#          "EXAMPLE-HS1-WB1" = list(biospecimen_type = "Whole Blood"),
#          "EXAMPLE-HS2-WB1" = list(biospecimen_type = "Whole Blood")
#          ),
#      "rna_seq" = list(
#          "EXAMPLE-HS1-WB1-RSQ1" = list(fraction = "Tcells")
#      )
#  )
#  
#  # Run update()
#  updateValues(
#      target = prod,
#      project = "example",
#      revisions = revs)

## ---- include = FALSE---------------------------------------------------------
revs <- list(
    "biospecimen" = list(
        "EXAMPLE-HS1-WB1" = list(biospecimen_type = "Whole Blood"),
        "EXAMPLE-HS2-WB1" = list(biospecimen_type = "Whole Blood")
        ),
    "rna_seq" = list(
        "EXAMPLE-HS1-WB1-RSQ1" = list(fraction = "Tcells")
    )
)

## -----------------------------------------------------------------------------
updateValues(
    target = prod,
    project = "example",
    revisions = revs,
    auto.proceed = TRUE)

## ---- include = FALSE---------------------------------------------------------
eject_cassette()

## -----------------------------------------------------------------------------
sessionInfo()

