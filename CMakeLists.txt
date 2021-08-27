# Project Config
cmake_minimum_required (VERSION 3.20)
set (CMAKE_CXX_STANDARD 17)

project ("Arm Cortex-M Base")

# Configuration Director for config files for third party libraries (ex. FreeRTOS)
set(CONFIG_DIR config)

# Get FreeRTOS
set(FREERTOS_VERSION V10.4.4)
include(cmake/FreeRTOS.cmake)

# Get TinyUSB
set(TINYUSB_VERSION 0.10.1)
include(cmake/TinyUSB.cmake)

# Get CMSIS
set(CMSIS_VERSION 5.8.0)
include(cmake/cmsis.cmake)

# Executable ELF File
set(EXECUTABLE_NAME bin)
add_executable (${EXECUTABLE_NAME}.elf app/main.cpp)

# Link Options/Libs
target_link_libraries(${EXECUTABLE_NAME}.elf freertos::freertos cmsis::cmsis)
target_link_options(${EXECUTABLE_NAME}.elf
                    PRIVATE
                      # Set custom linker script
                      # todo make configuration file that picks up start and end of RAM/ROM from toolchain file
                      -T ${CMAKE_SOURCE_DIR}/LinkerScript.ld
                      # Link for no system calls
                      --specs=nosys.specs
                      # Print memory usage and generate map file
                      -Wl,--print-memory-usage,-Map=${PROJECT_BINARY_DIR}/map.map
                    )

# Use objcopy to create bin, hex and asm files
set (HEX_FILE ${PROJECT_BINARY_DIR}/${EXECUTABLE_NAME}.hex)
set (BIN_FILE ${PROJECT_BINARY_DIR}/${EXECUTABLE_NAME}.bin)
set (ASM_FILE ${PROJECT_BINARY_DIR}/${EXECUTABLE_NAME}.s)

add_custom_command (TARGET ${EXECUTABLE_NAME}.elf POST_BUILD
                    COMMAND ${CMAKE_OBJCOPY} -Oihex $<TARGET_FILE:${EXECUTABLE_NAME}.elf> ${HEX_FILE}
                    COMMAND ${CMAKE_OBJCOPY} -Obinary $<TARGET_FILE:${EXECUTABLE_NAME}.elf> ${BIN_FILE}
                    COMMAND ${CMAKE_OBJDUMP} -d -C -S $<TARGET_FILE:${EXECUTABLE_NAME}.elf> > ${ASM_FILE}
                    )

# Doxygen Documentation Target
add_subdirectory(docs)

