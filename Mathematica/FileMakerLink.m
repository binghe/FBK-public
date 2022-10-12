(* ::Package:: *)

(************************************************************************)
(* This file was generated automatically by the Mathematica front end.  *)
(* It contains Initialization cells from a Notebook file, which         *)
(* typically will have the same name as this file except ending in      *)
(* ".nb" instead of ".m".                                               *)
(*                                                                      *)
(* This file is intended to be loaded into the Mathematica kernel using *)
(* the package loading commands Get or Needs.  Doing so is equivalent   *)
(* to using the Evaluate Initialization Cells menu command in the front *)
(* end.                                                                 *)
(*                                                                      *)
(* DO NOT EDIT THIS FILE.  This entire file is regenerated              *)
(* automatically each time the parent Notebook file is saved in the     *)
(* Mathematica front end.  Any changes you make to this file will be    *)
(* overwritten.                                                         *)
(************************************************************************)



(* ::Input::Initialization:: *)
BeginPackage["FileMakerLink`", {"DatabaseLink`"}]


(* ::Input::Initialization:: *)
FileMakerLink::usage = "FileMakerLink.m is a package for connecting to FileMaker Pro databases."


(* ::Input::Initialization:: *)
OpenFMPConnection::usage =
  "OpenFMPConnection[dbname, opts ...] opens a connection to a (local) FileMaker Pro database."


(* ::Input::Initialization:: *)
Hostname::usage = "Hostname is an option of OpenFMPConnection[]"


(* ::Input::Initialization:: *)
CloseFMPConnection::usage = "CloseFMPConnection[conn] closes the FileMaker Pro database connection."


(* ::Input::Initialization:: *)
Begin["`Private`"]


(* ::Input::Initialization:: *)
protected = Unprotect[ OpenFMPConnection, CloseFMPConnection ]


Options[OpenFMPConnection] = Append[Options[OpenSQLConnection],Hostname -> "localhost"]


(* ::Input::Initialization:: *)
OpenFMPConnection[ dbname_, opts : OptionsPattern[] ] :=
	Module[{hostname, jdbcURL, sqlOpts},
		hostname = OptionValue[Hostname];
		jdbcURL = "jdbc:filemaker://" <> hostname <> "/" <> dbname;
		sqlOpts = Append[FilterRules[{opts}, Options[OpenSQLConnection]],
					     "Name" -> "FMP"]; (* fixed name required by FM JDBC *)
		OpenSQLConnection[JDBC["com.filemaker.jdbc.Driver", jdbcURL], sqlOpts]
	]


(* ::Input::Initialization:: *)
CloseFMPConnection[conn_] := CloseSQLConnection[conn]


(* ::Input::Initialization:: *)
Protect[ Evaluate[protected] ]


(* ::Input::Initialization:: *)
End[ ]


(* ::Input::Initialization:: *)
Protect[ OpenFMPConnection, CloseFMPConnection ]


(* ::Input::Initialization:: *)
EndPackage[ ]



