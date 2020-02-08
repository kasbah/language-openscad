{-# LANGUAGE OverloadedStrings #-}
module Language.OpenSCAD.Writer where
import Language.OpenSCAD
import qualified Data.ByteString.Char8 as BS
import Data.Maybe (fromMaybe)

write :: [TopLevel] -> [BS.ByteString]
write = map writeTopLevel

writeTopLevel :: TopLevel -> BS.ByteString
writeTopLevel x = case x of
    TopLevelScope obj    -> writeObject True obj
    UseDirective str     -> BS.pack ("use <" ++ str ++ ">")
    IncludeDirective str -> BS.pack ("include <" ++ str ++ ">")

writeObject :: Bool -> Object -> BS.ByteString
writeObject isTopLevel obj = case obj of
     Module (Ident ident) args maybeObj ->
        BS.pack (ident ++ "()")
        `BS.append` fromMaybe BS.empty (fmap (BS.append (BS.pack " ") . writeObject False) maybeObj)
        `BS.append` if isTopLevel then BS.pack ";" else BS.empty
     ForLoop ident expr obj     -> undefined
     Objects objs               -> undefined
     If expr obj maybeObj       -> undefined
     BackgroundMod obj          -> undefined
     DebugMod obj               -> undefined
     RootMod obj                -> undefined
     DisableMod obj             -> undefined
     ModuleDef name args body   -> undefined
     VarDef name value          -> undefined
     FuncDef name args body     -> undefined
