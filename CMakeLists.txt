cmake_minimum_required(VERSION 3.0)
project(sca_documentation)

#------------------------------------------------------------
# doc
#------------------------------------------------------------
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
