################################################################################

begin

  ################################################################################

  # project
  projDir = "/Users/drivas/Factorem/Syncytin"

  ################################################################################

  # source
  utilDir = string( projDir, "/src/Utilities" )

  ################################################################################

  # data
  dataDir = string( projDir, "/data" )

  alignmentDir = string( dataDir, "/alignmentMultipleSequence" )
  annotationDir = string( dataDir, "/annotationSource" )
  assemblyReadmeDir = string( dataDir, "/assemblyREADME" )
  candidateDir = string( dataDir, "/candidateSyncytinExtraction" )
  diamondDir = string( dataDir, "/diamondOutput" )
  DNAzooDir = string( dataDir, "/DNAzooSource" )
  insertionDir = string( dataDir, "/insertionSequenceExtraction" )
  ncbiDir = string( dataDir, "/ncbiAssemblyAnnotationSource" )
  phylogenyDir = string( dataDir, "/phylogenyTimeTree" )
  predictionDir = string( dataDir, "/predictionAlphaFold" )
  profileDir = string( dataDir, "/profileProtein" )
  statsDir = string( dataDir, "/statsMiscellaneous" )
  syntenyDir = string( dataDir, "/syntenyAnnotationExtraction" )
  taxonomistDir = string( dataDir, "/taxonomistIDExtraction" )
  wasabiDir = string( dataDir, "/wasabiScrappedSource" )

  databaseDir = string( dataDir, "/syncytinDataBase" )
  accNDir = string( databaseDir, "/accessionN" )
  accPDir = string( databaseDir, "/accessionP" )
  genBankDir = string( databaseDir, "/genBank" )

  ################################################################################

  # list
  listDir = string( projDir, "/list" )

  ################################################################################

  # assembly
  DNAzooList = string( listDir, "/DNAzooList.csv" )
  ncbiList = string( listDir, "/ncbiList.csv" )

  ################################################################################

end;

################################################################################
