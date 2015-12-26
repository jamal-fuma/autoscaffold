/* Version: MPL 1.1/GPL 2.0
 *
 * The contents of this file are subject to the Mozilla Public License
 * Version 1.1 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 * http://www.mozilla.org/MPL/
 *
 * Software distributed under the License is distributed on an "AS IS"
 * basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See
 * the License for the specific language governing rights and
 * limitations under the License.
 *
 * The Original Code is libUtility
 *
 * The Initial Developers of the Original Code are FumaSoftware Ltd, and Jamal Natour.
 * Portions created before 1-Jan-2007 00:00:00 GMT by Jamal Natour, are Copyright
 * (C) 2004-2007 Jamal Natour
 *
 * Portions created by FumaSoftware Ltd are Copyright (C) 2009-2010 FumaSoftware
 * Ltd.
 *
 * Portions created by Jamal Natour are Copyright (C) 2009-2010
 * FumaSoftware Ltd and Jamal Natour.
 *
 * All Rights Reserved.
 *
 * Contributor(s): ______________________________________.
 *
 * Alternatively, the contents of this file may be used under the terms
 * of the GNU General Public License Version 2 or later (the "GPL"), in
 * which case the provisions of the GPL are applicable instead of those
 * above. If you wish to allow use of your version of this file only
 * under the terms of the GPL, and not to allow others to use your
 * version of this file under the terms of the MPL, indicate your
 * decision by deleting the provisions above and replace them with the
 * notice and other provisions required by the GPL. If you do not
 * delete the provisions above, a recipient may use your version of
 * this file under the terms of any one of the MPL or the GPL.
 */
#ifndef FUMA_TEST_HELPER_HPP
#define FUMA_TEST_HELPER_HPP

#if defined(HAVE_CONFIG_H)
#include "config.h"
#endif

#include <boost/test/unit_test.hpp>
#include <boost/test/mock_object.hpp>
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
                    : m_fixtures_dir(boost::filesystem::path(FIXTURES_DIR))
                {
                    // setup per test fixture data
                }

                // teardown
                virtual ~Fixture()
                {
                    // cleanup per test fixture data
                }

                // accessors
                std::string fixture_get_abs_filename() const
                {
                    return boost::filesystem::canonical(m_abs_filename).string();
                }

                std::string fixture_get_abs_dirname() const
                {
                    return boost::filesystem::canonical(m_fixtures_dir).string();
                }

                std::string fixture_get_rel_filename() const
                {
                    return m_rel_filename;
                }

                size_t fixture_get_size() const
                {
                    return m_data.size();
                }

                size_t fixture_get_filesystem_size() const
                {
                    // relies on stat(2) and the st_size member of struct stat
                    return boost::filesystem::file_size(m_abs_filename);
                }

                // mutators
                std::string fixture_to_string() const
                {
                    return std::string(fixture_begin(),fixture_end());
                }

                // path is relative to ${top_srcdir}/tests/fixtures
                void fixture_set_rel_filename(const std::string & relative_fixture_filename)
                {
                    m_rel_filename = relative_fixture_filename;

                    // reset to base path
                    m_abs_filename = m_fixtures_dir;

                    // glue paths together
                    m_abs_filename /= m_rel_filename.c_str();
                }

                void fixture_set_abs_dirname(const std::string & dir)
                {
                    m_fixtures_dir = boost::filesystem::path(dir);
                }

                void fixture_refresh_from_disk()
                {
                    // read the file into the vector
                    size_t size = fixture_get_filesystem_size();

                    // swap with a temporary to release the memory
                    std::vector<char>(size).swap(m_data);

                    // stream it in so we get the normal behaviour
                    std::ifstream input(fixture_get_abs_filename().c_str());
                    input.read(&m_data[0], size);
                }

                // const iterator access
                std::vector<char>::const_iterator fixture_begin() const
                {
                    return m_data.begin();
                }

                std::vector<char>::const_iterator fixture_end() const
                {
                    return m_data.end();
                }

                // non const iterator access
                std::vector<char>::iterator fixture_begin()
                {
                    return m_data.begin();
                }

                std::vector<char>::iterator fixture_end()
                {
                    return m_data.end();
                }

                // public data the testcases can use
                boost::filesystem::path m_fixtures_dir;
                boost::filesystem::path m_abs_filename;
                std::string m_rel_filename;
                std::vector<char> m_data;
        };

    } // Fuma::Test namespace
} // Fuma namespace

#endif /* ndef FUMA_TEST_HELPER_HPP */
