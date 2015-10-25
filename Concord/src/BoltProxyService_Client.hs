{-# LANGUAGE DeriveDataTypeable #-}
{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -fno-warn-missing-fields #-}
{-# OPTIONS_GHC -fno-warn-missing-signatures #-}
{-# OPTIONS_GHC -fno-warn-name-shadowing #-}
{-# OPTIONS_GHC -fno-warn-unused-imports #-}
{-# OPTIONS_GHC -fno-warn-unused-matches #-}

-----------------------------------------------------------------
-- Autogenerated by Thrift Compiler (0.9.2)                      --
--                                                             --
-- DO NOT EDIT UNLESS YOU ARE SURE YOU KNOW WHAT YOU ARE DOING --
-----------------------------------------------------------------

module BoltProxyService_Client(updateTopology,dispatchRecords,updateSchedulerAddress,registerWithScheduler) where
import MutableEphemeralStateService_Client
import qualified Data.IORef as R
import Prelude (($), (.), (>>=), (==), (++))
import qualified Prelude as P
import qualified Control.Exception as X
import qualified Control.Monad as M ( liftM, ap, when )
import Data.Functor ( (<$>) )
import qualified Data.ByteString.Lazy as LBS
import qualified Data.Hashable as H
import qualified Data.Int as I
import qualified Data.Maybe as M (catMaybes)
import qualified Data.Text.Lazy.Encoding as E ( decodeUtf8, encodeUtf8 )
import qualified Data.Text.Lazy as LT
import qualified Data.Typeable as TY ( Typeable )
import qualified Data.HashMap.Strict as Map
import qualified Data.HashSet as Set
import qualified Data.Vector as Vector
import qualified Test.QuickCheck.Arbitrary as QC ( Arbitrary(..) )
import qualified Test.QuickCheck as QC ( elements )

import qualified Thrift as T
import qualified Thrift.Types as T
import qualified Thrift.Arbitraries as T


import Bolt_Types
import BoltProxyService
seqid = R.newIORef 0
updateTopology (ip,op) arg_topology = do
  send_updateTopology op arg_topology
  recv_updateTopology ip
send_updateTopology op arg_topology = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("updateTopology", T.M_CALL, seqn)
  write_UpdateTopology_args op (UpdateTopology_args{updateTopology_args_topology=arg_topology})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)
recv_updateTopology ip = do
  (fname, mtype, rseqid) <- T.readMessageBegin ip
  M.when (mtype == T.M_EXCEPTION) $ do { exn <- T.readAppExn ip ; T.readMessageEnd ip ; X.throw exn }
  res <- read_UpdateTopology_result ip
  T.readMessageEnd ip
  P.maybe (P.return ()) X.throw (updateTopology_result_e res)
  P.return ()
dispatchRecords (ip,op) arg_records = do
  send_dispatchRecords op arg_records
  recv_dispatchRecords ip
send_dispatchRecords op arg_records = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("dispatchRecords", T.M_CALL, seqn)
  write_DispatchRecords_args op (DispatchRecords_args{dispatchRecords_args_records=arg_records})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)
recv_dispatchRecords ip = do
  (fname, mtype, rseqid) <- T.readMessageBegin ip
  M.when (mtype == T.M_EXCEPTION) $ do { exn <- T.readAppExn ip ; T.readMessageEnd ip ; X.throw exn }
  res <- read_DispatchRecords_result ip
  T.readMessageEnd ip
  P.maybe (P.return ()) X.throw (dispatchRecords_result_e res)
  P.return ()
updateSchedulerAddress (ip,op) arg_e = do
  send_updateSchedulerAddress op arg_e
  recv_updateSchedulerAddress ip
send_updateSchedulerAddress op arg_e = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("updateSchedulerAddress", T.M_CALL, seqn)
  write_UpdateSchedulerAddress_args op (UpdateSchedulerAddress_args{updateSchedulerAddress_args_e=arg_e})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)
recv_updateSchedulerAddress ip = do
  (fname, mtype, rseqid) <- T.readMessageBegin ip
  M.when (mtype == T.M_EXCEPTION) $ do { exn <- T.readAppExn ip ; T.readMessageEnd ip ; X.throw exn }
  res <- read_UpdateSchedulerAddress_result ip
  T.readMessageEnd ip
  P.maybe (P.return ()) X.throw (updateSchedulerAddress_result_e res)
  P.return ()
registerWithScheduler (ip,op) arg_meta = do
  send_registerWithScheduler op arg_meta
send_registerWithScheduler op arg_meta = do
  seq <- seqid
  seqn <- R.readIORef seq
  T.writeMessageBegin op ("registerWithScheduler", T.M_ONEWAY, seqn)
  write_RegisterWithScheduler_args op (RegisterWithScheduler_args{registerWithScheduler_args_meta=arg_meta})
  T.writeMessageEnd op
  T.tFlush (T.getTransport op)