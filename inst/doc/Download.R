## ---- echo=FALSE, results="hide", message=FALSE-------------------------------
knitr::opts_chunk$set(error=FALSE, message=FALSE, warning=FALSE)
library(BiocStyle)
library(vcr)
library(magmaR)

TOKEN <- magmaR:::.get_sysenv_or_mock("TOKEN")
URL <- magmaRset("")$url

vcr_configure(
    filter_sensitive_data = list("<<<my_token>>>" = TOKEN),
    dir = "../tests/fixtures"
)
insert_cassette(name = "Download-vignette")

## ---- eval = FALSE------------------------------------------------------------
#  # Installation options (Choose one. CRAN method is recommended for most users.)
#  
#  ## 1. Most recent release version via CRAN
#  install.packages("magmaR")
#  
#  ## 2. Development version via GitHub
#  remotes::install_github("mountetna/monoetna", subdir = "etna/packages/magmaR")
#  
#  # Check installation and load the package
#  library(magmaR)
#  
#  # Set up your authorization token and where to find magma
#  magma <- magmaRset()
#  ## Note: run as above, you will be prompted in the console to provide your token.
#  ## This token can be obtained from Janus.
#  
#  # Now, you're ready to retrieve some data!
#  retrieve(
#      target = magma,
#      projectName  = "example",
#      modelName = "subject"
#  )

## ---- eval = FALSE------------------------------------------------------------
#  install.packages("magmaR")

## ---- eval = FALSE------------------------------------------------------------
#  if (!requireNamespace("remotes", quietly = TRUE))
#      install.packages("remotes")
#  remotes::install_github("mountetna/monoetna", subdir = "etna/packages/magmaR")

## -----------------------------------------------------------------------------
library(magmaR)

## ---- hide = TRUE, echo=FALSE-------------------------------------------------
prod <- magmaRset(token = TOKEN, url = URL)

## ---- eval = FALSE------------------------------------------------------------
#  # Method1: User will be prompted to give their token in the R console
#  prod <- magmaRset()
#  
#  ids_subject <- retrieveProjects(
#      # Now, we give the output of magmaRset() to the 'target' input of any
#      # other magmaR function.
#      target = prod)

## ---- eval = FALSE------------------------------------------------------------
#  prod <- magmaRset(token = "<your-token-here>")
#  
#  ids_subject <- retrieveProjects(
#      # Now, we give the output of magmaRset() to the 'target' input of any
#      # other magmaR function.
#      target = prod)

## ---- eval = FALSE------------------------------------------------------------
#  dev <- magmaRset(url = "http://magma.development.local")
#  
#  # When calling to magma...
#  ids_subject <- retrieveIds(
#      # Now give this to 'target':
#      target = dev,
#      # ^^
#      projectName = "example",
#      modelName = "subject",
#      url.base = "http://magma.development.local")

## -----------------------------------------------------------------------------
# projectName options:
retrieveProjects(
    target = prod)

# modelName options:
retrieveModels(
    target = prod,
    projectName = "example")

# recordNames options:
retrieveIds(
    target = prod,
    projectName = "example",
    modelName = "subject")

# attributeName(s) options:
retrieveAttributes(
    target = prod,
    projectName = "example",
    modelName = "subject")

## -----------------------------------------------------------------------------
# To retrieve the project template:
temp <- retrieveTemplate(
    target = prod,
    projectName = "example")

## -----------------------------------------------------------------------------
str(temp, max.level = 3)

## -----------------------------------------------------------------------------
# For the "subject" model:
str(temp$models$subject$template)

## -----------------------------------------------------------------------------
df <- retrieve(
    target = prod,
    projectName = "example",
    modelName = "subject")

head(df)

## -----------------------------------------------------------------------------
df <- retrieve(
    target = prod,
    projectName = "example",
    modelName = "subject",
    recordNames = c("EXAMPLE-HS1", "EXAMPLE-HS2"),
    attributeNames = "group")

head(df)

## ----retJSON------------------------------------------------------------------
json <- retrieveJSON(
    target = prod,
    projectName = "example",
    modelName = "rna_seq",
    recordNames = c("EXAMPLE-HS1-WB1-RSQ1", "EXAMPLE-HS2-WB1-RSQ1"),
    attributeNames = "gene_counts")

## ----matrix-------------------------------------------------------------------
mat <- retrieveMatrix(
    target = prod,
    projectName = "example",
    modelName = "rna_seq",
    recordNames = "all",
    attributeNames = "gene_tpm")

head(mat, n = c(6,3))

## ----query--------------------------------------------------------------------
query_out <- query(
    target = prod,
    projectName = "example",
    queryTerms = 
        list('rna_seq',
             '::all',
             'biospecimen',
             '::identifier')
    )

## -----------------------------------------------------------------------------
names(query_out)

## ----query2-------------------------------------------------------------------
subject_ids_of_rnaseq_records <- query(
    target = prod,
    projectName = "example",
    queryTerms = 
        list('rna_seq',
             '::all',
             'biospecimen',
             '::identifier'),
    format = "df"
    )

head(subject_ids_of_rnaseq_records)

## ----meta---------------------------------------------------------------------
meta <- retrieveMetadata(
    target = prod,
    projectName = "example",
    meta_modelName = "subject",
    meta_attributeNames = "all",
    target_modelName = "rna_seq",
    target_recordNames = "all")

head(meta, n = c(6,10))

## -----------------------------------------------------------------------------
library(dittoSeq)
# Make plot with dittoSeq
sce <- importDittoBulk(
  list(tpm = mat), # mat was obtained with retrieveMatrix()
  metadata = meta # meta was obtained with retrieveMetadata()
)

dittoBoxPlot(sce, "gene1", group.by = "group")

## ---- include = FALSE---------------------------------------------------------
eject_cassette()

## -----------------------------------------------------------------------------
sessionInfo()

