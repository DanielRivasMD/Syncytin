################################################################################

# declarations
begin
  include( "/Users/drivas/Factorem/Syncytin/src/Config/syncytinConfig.jl" )
end;

################################################################################

# load project enviroment
using Pkg
if Pkg.project().path != string( projDir, "/Project.toml" )
  Pkg.activate(projDir)
end

################################################################################

# load packages
begin
end;

################################################################################

# load modules
begin
  include( string( utilDir, "/ioDataFrame.jl" ) )
end;

################################################################################

# "AEX32761.1"  # Canis lupus familiaris
# "AEX32762.1"  # Crocuta crocuta
# "AGE09538.1"  # Bos taurus
# "AGE09543.1"  # Ovis aries
# "AIQ85116.1"  # Echinops telfairi
# "ATY46611.1"  # Mabuya sp.

# "AEX32761.1"
# "AEX32762.1"
# "AGE09538.1"
# "AGE09543.1"
# "AIQ85116.1"
# "ATY46611.1"

################################################################################
