module Cli where

import Options.Applicative ((<**>), auto, fullDesc, help, helper, info, long, metavar, option, Parser, ParserInfo, progDesc,
    short, showDefault, strOption, switch, value)

data CliOptions = CliOptions {
    alphabetPath :: String,
    characterFrequenciesPath :: String,
    digramFrequenciesPath :: String,
    separatorChar :: Char,
    spaceInDigrams :: Bool,
    printSubstitution :: Bool
}

parserOptions :: Parser CliOptions
parserOptions = CliOptions
    <$> strOption (
        long "alphabet"
        <> short 'a'
        <> help "Text file with all characters of the alphabet in the language"
        <> metavar "PATH"
    ) <*> strOption (
        long "char-frequencies"
        <> short 'c'
        <> help "2-column CSV file with all characters and their respective frequencies in the language"
        <> metavar "PATH"
    ) <*> strOption (
        long "digram-frequencies"
        <> short 'd'
        <> help "2-column CSV file with all digrams and their respective frequencies in the language"
        <> metavar "PATH"
    ) <*> option auto (
        long "separator"
        <> showDefault
        <> value ','
        <> help "Column separator for the CSV files"
        <> metavar "CHAR"
    ) <*> switch (
        long "space-in-digrams"
        <> help "If present, will expect the digram frequencies file to contain frequencies for digrams containing a space"
    ) <*> switch (
        long "print-substitution"
        <> help "If present, prints the substitution in addition to the substituted text"
    )

parser :: ParserInfo CliOptions
parser = info (parserOptions <**> helper) (
    fullDesc
    <> progDesc "Decrypt a substitution cipher using frequency analysis"
    )
