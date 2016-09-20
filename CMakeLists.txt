cmake_minimum_required(VERSION 3.0)
project(sca_documentation)

#------------------------------------------------------------
# doc
#------------------------------------------------------------
find_program(
    MKDOCS_BIN
    mkdocs
    DOC "Find the mkdocs executable"
)
if(MKDOCS_BIN-NOTFOUND)
    message(FATAL_ERROR "mkdocs not found. Install: 'pip install mkdocs'")
endif()

execute_process(
    COMMAND pip show mkdocs-material
    COMMAND grep Name
    RESULT_VARIABLE MKDOCS_TEMPLATE
    OUTPUT_QUIET
)
if(MKDOCS_TEMPLATE)
    message(FATAL_ERROR "mkdocs material theme not found; install: 'pip install mkdocs-material'")
endif()

add_custom_target(
    doc COMMENT "Generate the documentation"
)

add_custom_command(
    TARGET doc
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    COMMAND mkdocs build
)

add_custom_target(
    doc_serve COMMENT "Serve the documentation on http://localhost:9000"
)

add_custom_command(
    TARGET doc_serve
    WORKING_DIRECTORY ${PROJECT_SOURCE_DIR}
    COMMAND mkdocs serve -a localhost:9000
)
#------------------------------------------------------------
