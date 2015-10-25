{-# OPTIONS_GHC -Wall #-}
{-# LANGUAGE PackageImports #-}
module Concord where

import qualified ComputationService
import qualified Data.Vector as V
import qualified Data.HashMap.Lazy as M

import Data.Text.Lazy as LT (pack, unpack)
import System.Environment (getEnv)
import Text.Read (readMaybe)
import Control.Monad.Trans.State
import Prelude hiding (init)

import Bolt_Consts
import Bolt_Types
import ComputationService_Iface

import Thrift.Server

-- Metadata
type StreamName = String
type IStreams = [StreamMetadata]
type OStreams = [String]

data Metadata = Metadata {
  metadata_streamName :: StreamName,
  metadata_istreams :: IStreams,
  metadata_ostreams :: OStreams
}

-- ComputationContext
type Records = [Record] -- V.Record
type Timer = M.HashMap String Int -- M.Map LT.Text I.Int64
data ComputationContext = ComputationContext {
  computationContext_records :: Records,
  computationContext_timers :: Timer
}

emptyContext :: ComputationContext
emptyContext = ComputationContext [] M.empty

-- Computation
type Concord a = StateT ComputationContext IO a
data Computation = Computation {
  computation_init :: Concord (),
  computation_processRecord :: Record -> Concord (),
  computation_processTimer :: String -> Int -> Concord (),
  computation_metadata :: Metadata
}

-- ComputationServiceWrapper (Thrift Client)
type ProxyHost = String
type ProxyPort = Int
data ComputationServiceWrapper = ComputationServiceWrapper {
  compsvcWrapper_computation :: Computation,
  compsvcWrapper_proxyHost :: ProxyHost,
  compsvcWrapper_proxyPort :: ProxyPort
}

instance ComputationService_Iface ComputationServiceWrapper where
  -- init :: a -> IO ComputationTx
  init self = return $ ComputationTx id records timers
    where ctx = runStateT  computation_init $ compsvcWrapper_computation self
          id = 0
          records = V.fromList (computationContext_records (get ctx))
          timers = M.empty -- M.map (LT.pack) computationContext_timers

  -- boltProcessRecords :: a -> (Vector.Vector Record) -> P.IO (Vector.Vector ComputationTx)
  -- boltProcessRecords = undefined

  -- boltProcessTimer :: a -> LT.Text -> I.Int64 -> P.IO ComputationTx
  -- boltProcessTimer = undefined

  -- boltMetadata :: a -> IO ComputationMetadata
  boltMetadata self = return $ ComputationMetadata name' taskId' istreams' ostreams' endpoint'
    where (Metadata name istreams ostreams) = computation_metadata $ compsvcWrapper_computation self
          name' = LT.pack name
          taskId' = LT.pack ""
          ostreams' = V.map LT.pack $ V.fromList ostreams
          istreams' = V.fromList istreams
          endpoint' = Endpoint taskId' 0

-- Entrypoint
addressString :: String -> Maybe (String, Int)
addressString str = fn hoststr portstr
  where (hoststr, portstr) = break (==':') str
        fn _ [] = Nothing
        fn h p = case readMaybe p of
          Nothing -> Nothing
          Just p' -> Just (h, p')

startThriftServices :: Computation -> (String, Int) -> (String, Int) -> IO ()
startThriftServices comp listen proxy = do
  putStrLn "Starting thrift server..."
  handler <- return $ ComputationServiceWrapper comp proxyAddr proxyPort
  runBasicServer handler ComputationService.process (fromIntegral listenPort)
  where (_, listenPort) = listen
        (proxyAddr, proxyPort) = proxy

serveComputation :: Computation -> IO ()
serveComputation computation = do
  listenAddr <- getEnv (LT.unpack kConcordEnvKeyClientListenAddr)
  proxyAddr <- getEnv (LT.unpack kConcordEnvKeyClientProxyAddr)
  let listenEndpoint = addressString listenAddr
  let proxyEndpoint = addressString proxyAddr
  case (listenEndpoint, proxyEndpoint) of
    (Just listen, Just proxy) -> startThriftServices computation listen proxy
    _ -> putStrLn "Error with proxy and/or listen endpoints"
