

# CPLEX Directory and Libraries
set(CPLEX_VERSION "1271" CACHE STRING "CPLEX Version (without dots)")
set(CPLEX_STUDIO_DIR "/opt/ibm/ILOG/CPLEX_Studio1271" CACHE PATH "Path To CPLEX Install")
set(CPLEX_SYSTEM "x86-64_linux" CACHE STRING "CPLEX System Type")
set_property(CACHE CPLEX_SYSTEM PROPERTY STRINGS "x86-64_linux" "x86-64_osx")
set(CPLEX_LIBFORMAT "static_pic" CACHE STRING "CPLEX Library Format")
set_property(CACHE CPLEX_LIBFORMAT PROPERTY STRINGS "static_pic")

set(CPLEX_DIR "${CPLEX_STUDIO_DIR}/cplex")
set(CPLEX_BIN_DIR "${CPLEX_DIR}/bin/${CPLEX_SYSTEM}")
set(CPLEX_INCLUDE_DIR "${CPLEX_DIR}/include")
find_library(ILOCPLEX_LIB ilocplex
             PATHS "${CPLEX_DIR}/lib/${CPLEX_SYSTEM}/${CPLEX_LIBFORMAT}")
find_library(CPLEX_LIB cplex
             PATHS "${CPLEX_DIR}/lib/${CPLEX_SYSTEM}/${CPLEX_LIBFORMAT}")


set(CONCERT_DIR "${CPLEX_STUDIO_DIR}/concert")
set(CONCERT_INCLUDE_DIR "${CONCERT_DIR}/include")
find_library(CONCERT_LIB concert
             PATHS "${CONCERT_DIR}/lib/${CPLEX_SYSTEM}/${CPLEX_LIBFORMAT}")

set(OPL_INCLUDE_DIR "${CPLEX_STUDIO_DIR}/opl/include")
set(CPOPTIMIZER_INCLUDE_DIR "${CPLEX_STUDIO_DIR}/cpoptimizer/include")

find_package(Threads)
find_library(M_LIB m)

link_directories(${CPLEX_LIB_DIR} ${CPLEX_LIB_DIR})

# Call target_cplex(TGT) to add cplex to build
function(target_cplex TGT)
    if (NOT IS_DIRECTORY ${CPLEX_STUDIO_DIR} AND NOT EXISTS "${CPLEX_BIN_DIR}/cplex")
        message(FATAL_ERROR "Did not find cplex executable in ${CPLEX_BIN_DIR} - "
                "are CPLEX_STUDIO_DIR and CPLEX_SYSTEM set correctly?")
    endif()

    target_include_directories(${TGT} PRIVATE
                                ${CPLEX_INCLUDE_DIR} ${CONCERT_INCLUDE_DIR}
                                ${OPL_INCLUDE_DIR} ${CPOPTIMIZER_INCLUDE_DIR})

    target_link_libraries(${TGT} PRIVATE
                          ${M_LIB} ${CONCERT_LIB} ${ILOCPLEX_LIB} ${CPLEX_LIB}
                          ${CMAKE_DL_LIBS} Threads::Threads)

    target_compile_definitions(${TGT} PRIVATE IL_STD)

    if (CPLEX_LIBFORMAT EQUAL "static_pic")
        target_compile_options(${TGT} PRIVATE -fPIC)
    endif()
endfunction()
