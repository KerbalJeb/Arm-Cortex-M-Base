include(FetchContent)
set(TOOL_CHAIN_VERSION 10.3-2021.07)
set(TOOLCHAIN_DIR ${CMAKE_CURRENT_LIST_DIR}/../../../cmake-build-toolchain)
set(TOOLCHAIN_BIN_DIR ${TOOLCHAIN_DIR}/bin)

# Download the required toolchain to cmake-build-toolchain
if ("${CMAKE_HOST_SYSTEM_NAME}" STREQUAL "Windows")
  set(TOOLCHAIN_SRC_URL "https://developer.arm.com/-/media/Files/downloads/gnu-rm/${TOOL_CHAIN_VERSION}/gcc-arm-none-eabi-${TOOL_CHAIN_VERSION}-win32.zip")
  set(TOOLCHAIN_POSTFIX ".exe")
else()
  message(FATAL_ERROR "No toolchain for ${CMAKE_HOST_SYSTEM_NAME}")
endif ()


if (NOT EXISTS ${TOOLCHAIN_DIR})
  message(STATUS "${TOOLCHAIN_DIR} Does not exist")
#  Seems to get stuck in an infinite downloading loop without check
  FetchContent_Declare(
      toolchain
      URL ${TOOLCHAIN_SRC_URL}
      SOURCE_DIR ${TOOLCHAIN_DIR}
  )
  FetchContent_MakeAvailable(toolchain)
endif ()

# Set Compiler and linker flags
set(CMAKE_C_COMPILER    ${TOOLCHAIN_BIN_DIR}/arm-none-eabi-gcc${TOOLCHAIN_POSTFIX})
set(CMAKE_CXX_COMPILER  ${TOOLCHAIN_BIN_DIR}/arm-none-eabi-g++${TOOLCHAIN_POSTFIX})
set(CMAKE_ASM_COMPILER  ${TOOLCHAIN_BIN_DIR}/arm-none-eabi-as${TOOLCHAIN_POSTFIX})
set(CMAKE_AR            ${TOOLCHAIN_BIN_DIR}/arm-none-eabi-ar${TOOLCHAIN_POSTFIX})
set(CMAKE_OBJCOPY       ${TOOLCHAIN_BIN_DIR}/arm-none-eabi-objcopy${TOOLCHAIN_POSTFIX})
set(CMAKE_OBJDUMP       ${TOOLCHAIN_BIN_DIR}/arm-none-eabi-objdump${TOOLCHAIN_POSTFIX})
set(SIZE                ${TOOLCHAIN_BIN_DIR}/arm-none-eabi-size${TOOLCHAIN_POSTFIX})

# Set Required flags
set(CMAKE_C_FLAGS   "${MCPU_FLAGS} ${VFP_FLAGS} -fno-builtin -fdata-sections -ffunction-sections" CACHE INTERNAL "c compiler flags")
set(CMAKE_CXX_FLAGS "${MCPU_FLAGS} ${VFP_FLAGS} -fno-builtin -fdata-sections -ffunction-sections" CACHE INTERNAL "cxx compiler flags")
set(CMAKE_ASM_FLAGS "${MCPU_FLAGS} -x assembler-with-cpp" CACHE INTERNAL "asm compiler flags")
set(CMAKE_EXE_LINKER_FLAGS "${MCPU_FLAGS} ${LD_FLAGS} -Wl,-gc-sections" CACHE INTERNAL "exe link flags")

# Limit library/inlcude search paths to avoid picking up system files (may not be needed)
set(CMAKE_TRY_COMPILE_TARGET_TYPE STATIC_LIBRARY)
set(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)
set(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)
set(CMAKE_FIND_ROOT_PATH_MODE_PACKAGE ONLY)