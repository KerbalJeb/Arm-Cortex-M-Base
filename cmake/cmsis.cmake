message(STATUS "Using CMSIS ${CMSIS_VERSION}")

FetchContent_Declare(cmsis_core
                     GIT_REPOSITORY "https://github.com/ARM-software/CMSIS_5.git"
                     GIT_TAG "${CMSIS_VERSION}"
                     )
FetchContent_MakeAvailable(cmsis_core)

enable_language(ASM)

add_library(cmsis_core INTERFACE)
target_include_directories(cmsis_core INTERFACE ${cmsis_core_SOURCE_DIR}/CMSIS/Core/Include)
add_library(cmsis::core ALIAS cmsis_core)

if (${MCU_LINE} STREQUAL stm32f0)
  set(${CMSIS_DEVICE_URL} https://github.com/STMicroelectronics/cmsis_device_f0.git)
else()
  message(FATAL_ERROR "Unknown MCU Line: ${MCU_LINE}")
endif ()


FetchContent_Declare(cmsis_device
                     GIT_REPOSITORY "https://github.com/STMicroelectronics/cmsis_device_f0.git"
                     )
FetchContent_MakeAvailable(cmsis_device)

add_library(cmsis_device
            ${cmsis_device_SOURCE_DIR}/${START_UP_PATH}
            ${cmsis_device_SOURCE_DIR}/${SYSTEM_UP_PATH}
            )

target_include_directories(cmsis_device PUBLIC ${cmsis_device_SOURCE_DIR}/Include)
target_link_libraries(cmsis_device PRIVATE cmsis::core)
add_library(cmsis::device ALIAS cmsis_device)


add_library(cmsis INTERFACE)
target_link_libraries(cmsis INTERFACE cmsis::device cmsis::core)
add_library(cmsis::cmsis ALIAS cmsis)
