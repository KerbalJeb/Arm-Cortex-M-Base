include(UsePackage)

set(CATCH2_VERSION v3.0.0-preview3)
use_package(TARGET catch2
        GIT_REPOSITORY "https://github.com/catchorg/Catch2.git"
        GIT_TAG "${CATCH2_VERSION}"
        )
list(APPEND CMAKE_MODULE_PATH "${catch2_SOURCE_DIR}/extras")