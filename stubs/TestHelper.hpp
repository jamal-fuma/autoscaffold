#ifndef FUMA_TEST_HELPER_HPP
#define FUMA_TEST_HELPER_HPP

#if defined(HAVE_CONFIG_H)
    #include "config.h"
#endif

#include <boost/test/unit_test.hpp>
#include <assert.h>
#include <boost/lexical_cast.hpp>
#include <boost/filesystem.hpp>

#include <iterator>
#include <iostream>
#include <fstream>

#include <vector>
#include <stdlib.h>
namespace Fuma
{
    namespace Test
    {
        struct Fixture
        {
            public:
                // setup
                Fixture()
                    : m_data{}
                {
                    // setup per test fixture data
                }

                // teardown
                ~Fixture()
                {
                    // cleanup per test fixture data
                }

                // test helpers
                std::string fixture_load(const std::string & fname)
                {
                    // glue paths together
                    boost::filesystem::path full_path(FIXTURES_DIR);
                    full_path /= fname.c_str();
                    // get a suitable string
                    std::string abs_fname =
                        boost::filesystem::canonical(full_path).string();
                    uintmax_t size = boost::filesystem::file_size(full_path);
                    // read the file into the vector
                    std::vector<char>(size).swap(m_data);
                    std::ifstream input(abs_fname.c_str());
                    input.read(&m_data[0], size);
                    return abs_fname;
                }

                // public data the testcases can use
                std::vector<char> m_data;
        };

    } // Fuma::Test namespace
} // Fuma namespace

#endif /* ndef FUMA_TEST_HELPER_HPP */
