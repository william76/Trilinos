# @HEADER
# ************************************************************************
#
#            Trilinos: An Object-Oriented Solver Framework
#                 Copyright (2001) Sandia Corporation
#
#
# Copyright (2001) Sandia Corporation. Under the terms of Contract
# DE-AC04-94AL85000, there is a non-exclusive license for use of this
# work by or on behalf of the U.S. Government.  Export of this program
# may require a license from the United States Government.
#
# 1. Redistributions of source code must retain the above copyright
# notice, this list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright
# notice, this list of conditions and the following disclaimer in the
# documentation and/or other materials provided with the distribution.
#
# 3. Neither the name of the Corporation nor the names of the
# contributors may be used to endorse or promote products derived from
# this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY SANDIA CORPORATION "AS IS" AND ANY
# EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR
# PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL SANDIA CORPORATION OR THE
# CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
# EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
# PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
# PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
# LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
# NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
# SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
# NOTICE:  The United States Government is granted for itself and others
# acting on its behalf a paid-up, nonexclusive, irrevocable worldwide
# license in this data to reproduce, prepare derivative works, and
# perform publicly and display publicly.  Beginning five (5) years from
# July 25, 2001, the United States Government is granted for itself and
# others acting on its behalf a paid-up, nonexclusive, irrevocable
# worldwide license in this data to reproduce, prepare derivative works,
# distribute copies to the public, perform publicly and display
# publicly, and to permit others to do so.
#
# NEITHER THE UNITED STATES GOVERNMENT, NOR THE UNITED STATES DEPARTMENT
# OF ENERGY, NOR SANDIA CORPORATION, NOR ANY OF THEIR EMPLOYEES, MAKES
# ANY WARRANTY, EXPRESS OR IMPLIED, OR ASSUMES ANY LEGAL LIABILITY OR
# RESPONSIBILITY FOR THE ACCURACY, COMPLETENESS, OR USEFULNESS OF ANY
# INFORMATION, APPARATUS, PRODUCT, OR PROCESS DISCLOSED, OR REPRESENTS
# THAT ITS USE WOULD NOT INFRINGE PRIVATELY OWNED RIGHTS.
#
# ************************************************************************
# @HEADER


INCLUDE("${CTEST_SCRIPT_DIRECTORY}/TrilinosCTestDriverCore.trilinos-test.gcc.cmake")

#
# Set the options specific to this build case
#

SET(COMM_TYPE MPI)
SET(BUILD_TYPE RELEASE)
SET(BUILD_DIR_NAME CONTINUOUS_${COMM_TYPE}_OPT_DEV_SHARED)
#SET(CTEST_TEST_TIMEOUT 900)

#override the default number of processors to run on.
SET( CTEST_BUILD_FLAGS "-j11 -i" )
SET( CTEST_PARALLEL_LEVEL "4" )

SET(Trilinos_ENABLE_SECONDARY_TESTED_CODE ON)

#disabling Mesquite because of a build error when shared libs is turned on.
SET(EXTRA_EXCLUDE_PACKAGES Mesquite STK Claps PyTrilinos)

SET( EXTRA_CONFIGURE_OPTIONS
  "-DTrilinos_ENABLE_EXPLICIT_INSTANTIATION:BOOL=ON"
  "-DTrilinos_ENABLE_DEBUG:BOOL=ON"
  "-DBUILD_SHARED_LIBS:BOOL=ON"
  "-DMPI_BASE_DIR:PATH=/home/trilinos/gcc4.7.2/openmpi-1.6.5"
  "-DTPL_ENABLE_Pthread:BOOL=ON"
  "-DTPL_ENABLE_Boost:BOOL=ON"
  "-DBoost_INCLUDE_DIRS:FILEPATH=/home/trilinos/tpl/gcc4.1.2/boost_1_55_0"
  "-DBoostLib_INCLUDE_DIRS:FILEPATH=/home/trilinos/tpl/gcc4.1.2/boost_1_55_0_compiled/include"
  "-DBoostLib_LIBRARY_DIRS:FILEPATH=/home/trilinos/tpl/gcc4.1.2/boost_1_55_0_compiled/lib"
  "-DGLM_INCLUDE_DIRS=/home/trilinos/tpl/gcc4.1.2/glm-0.9.4.6"
  )

# 2009/11/26: rabartl: Do we really wantk to be pointing to Trilinos_DATA_DIR?
# Unless the CI sever is going to be updatting this every iteration this is
# likely to cause an inconsistency and a test failure.  For example, if
# someone adds a new test and then adds new test data, the CI server will only
# get the new test but not the new test data.  Therefore, I am removing this.
# # "-DTrilinos_DATA_DIR:STRING=$ENV{TRILINOSDATADIRECTORY}"


#
# Set the rest of the system-specific options and run the dashboard build/test
#

SET(CTEST_TEST_TYPE Continuous)

SET(CTEST_START_WITH_EMPTY_BINARY_DIRECTORY ON)
SET(CTEST_ENABLE_MODIFIED_PACKAGES_ONLY OFF)
SET(done 0)

WHILE(NOT done)
  SET(START_TIME ${CTEST_ELAPSED_TIME})

  TRILINOS_SYSTEM_SPECIFIC_CTEST_DRIVER()

  SET(CTEST_START_WITH_EMPTY_BINARY_DIRECTORY OFF)
  SET(CTEST_ENABLE_MODIFIED_PACKAGES_ONLY ON)

  MESSAGE("Before CTEST_SLEEP: CTEST_ELAPSED_TIME='${CTEST_ELAPSED_TIME}'")

  # Loop at most once every 3 minutes (180 seconds)
  CTEST_SLEEP(${START_TIME} 180 ${CTEST_ELAPSED_TIME})

  # Stop after 14 hours:
  IF(${CTEST_ELAPSED_TIME} GREATER 50400)
    SET(done 1)
  ENDIF()

  MESSAGE("Bottom of continuous while loop: CTEST_ELAPSED_TIME='${CTEST_ELAPSED_TIME}'")
ENDWHILE()
