{-# LANGUAGE DeriveGeneric #-}

module Language.Mulang.Analyzer.Analysis (
  Expectation(..),

  Analysis(..),
  AnalysisSpec(..),
  SmellsSet(..),
  DomainLanguage(..),
  CaseStyle(..),
  Smell,
  SignatureAnalysisType(..),
  SignatureStyle(..),
  Sample(..),
  Language(..),

  AnalysisResult(..),
  ExpectationResult(..)) where

import GHC.Generics

import Language.Mulang.Ast

---
-- Common structures
--

type Smell = String
type Inspection = String

data Expectation
  = Expectation { binding :: String, inspection :: Inspection } deriving (Show, Eq, Generic)

--
-- Analysis input structures
--

data Analysis = Analysis {
  sample :: Sample,
  spec :: AnalysisSpec
} deriving (Show, Eq, Generic)

data AnalysisSpec = AnalysisSpec {
  expectations :: [Expectation],
  smellsSet :: SmellsSet,
  signatureAnalysisType :: Maybe SignatureAnalysisType,
  domainLanguage :: Maybe DomainLanguage,
  includeIntermediateLanguage :: Maybe Bool
} deriving (Show, Eq, Generic)

data DomainLanguage
  = DomainLanguage {
      dictionaryFilePath :: Maybe FilePath,
      caseStyle :: Maybe CaseStyle,
      minimumIdentifierSize :: Maybe Int,
      jargon :: Maybe [String]
    }  deriving (Show, Eq, Generic)

data CaseStyle
  = CamelCase
  | SnakeCase
  | RubyCase deriving (Show, Eq, Generic)

data SmellsSet
  = NoSmells { include :: Maybe [Smell] }
  | AllSmells { exclude :: Maybe [Smell] } deriving (Show, Eq, Generic)

data SignatureAnalysisType
  = NoSignatures
  | DefaultSignatures
  | StyledSignatures { style :: SignatureStyle } deriving (Show, Eq, Generic)

data SignatureStyle
  = MulangStyle
  | UntypedCStyle
  | HaskellStyle
  | PrologStyle deriving (Show, Eq, Generic)

data Sample
  = MulangSample { ast :: Expression }
  | CodeSample { language :: Language, content :: Code } deriving (Show, Eq, Generic)

data Language
  =  Json
  |  Java
  |  JavaScript
  |  Prolog
  |  Haskell deriving (Show, Eq, Generic)

--
-- Analysis Output structures
--

data AnalysisResult
  = AnalysisCompleted { expectationResults :: [ExpectationResult],
                        smells :: [Expectation],
                        signatures :: [Code],
                        intermediateLanguage :: Maybe Expression }
  | AnalysisFailed { reason :: String } deriving (Show, Eq, Generic)

data ExpectationResult = ExpectationResult {
  expectation :: Expectation,
  result :: Bool
} deriving (Show, Eq, Generic)


