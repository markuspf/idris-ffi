module ForeignTests

%include C "idris_ffi.h"
%lib C "idris_ffi.o"

ForeignReturnTy : List FTy -> Type
ForeignReturnTy [] = ()
-- ForeignReturnTy (t :: Nil) = interpFTy t
ForeignReturnTy (t :: ts) = (interpFTy t, ForeignReturnTy (ts))

ForeignMultiTy : (xs : List FTy) -> (rt : List FTy) -> Type
ForeignMultiTy Nil     rt = World -> PrimIO (ForeignReturnTy rt)
ForeignMultiTy (t::ts) rt = interpFTy t -> ForeignMultiTy ts rt 

extractForeignReturn : Ptr -> Nat -> (t : FTy) -> IO (interpFTy t)
extractForeignReturn p i (FIntT ITNative) = mkForeign (FFun "idris_ffi_extract_int" [FPtr, FInt] FInt) p (fromNat i)
extractForeignReturn p i FFloat           = mkForeign (FFun "idris_ffi_extract_float" [FPtr, FInt] FFloat) p (fromNat i)
extractForeignReturn p i FString          = mkForeign (FFun "idris_ffi_extract_string" [FPtr, FInt] FString) p (fromNat i)

extractForeignReturns : Ptr -> Nat -> (ts : List FTy) -> IO (ForeignReturnTy ts)
extractForeignReturns p k (t :: ts) = do
	x <- extractForeignReturn p k t
	xs <- extractForeignReturns p (S k) ts
	return (x, xs)

tryOne : String -> (xts : List FTy) -> (yts : List FTy) -> (ForeignMultiTy xts yts)
tryOne n xts yts ?= \xs => do
	b <- mkForeign (FFun "idris_ffi_allocate" [FInt] FPtr) (fromNat (length yts))
	mkForeign (FFun n (FPtr :: xts) FUnit) b xs
	r <- extractForeignReturns b Z yts
	mkForeign (FFun "idris_ffi_free" [FPtr] FUnit) b
	return r 


	

