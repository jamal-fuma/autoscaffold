#include "TestHelper.hpp"

#include <libpq-fe.h>

struct FixtureData
	: public Fuma::Test::Fixture
{
    FixtureData()
        : m_db{nullptr}
        , m_stmt{nullptr}
    {
    }

    ~FixtureData()
    {
        if(m_stmt)
            PQclear(m_stmt);

        if(m_db)
            PQfinish(m_db);

        m_db = nullptr;
    }

    PGconn   * m_db;
    PGresult * m_stmt;
};

BOOST_FIXTURE_TEST_SUITE(PostgresSuite, FixtureData)

BOOST_AUTO_TEST_CASE(retrieving_library_version)
{
    int library_version = PQlibVersion();
    BOOST_REQUIRE(library_version > 0);
}

BOOST_AUTO_TEST_CASE(failing_connection_to_server)
{
    auto connection_str = "user=test_user password=test_pass dbname=testdb";
    m_db = PQconnectdb(connection_str);
    BOOST_REQUIRE(m_db != nullptr);
    BOOST_CHECK_EQUAL(CONNECTION_BAD,PQstatus(m_db));
    BOOST_CHECK_EQUAL("Connection to database failed", PQstatus(m_db));
}

BOOST_AUTO_TEST_CASE(success_connection_to_server)
{
    auto connection_str = "user=test_user password=test_pass dbname=testdb";
    m_db = PQconnectdb(connection_str);
    BOOST_REQUIRE(m_db != nullptr);
    BOOST_CHECK_EQUAL(CONNECTION_OK,PQstatus(m_db));
    BOOST_CHECK_EQUAL("test_user",PQuser(m_db));
    BOOST_CHECK_EQUAL("test_pass",PQpass(m_db));
    BOOST_CHECK_EQUAL("testdb",   PQdb(m_db));
}

BOOST_AUTO_TEST_CASE(success_single_shot_exec)
{
    auto connection_str = "user=test_user password=test_pass dbname=testdb";
    m_db = PQconnectdb(connection_str);
    BOOST_REQUIRE(m_db != nullptr);
    BOOST_CHECK_EQUAL(CONNECTION_OK,PQstatus(m_db));
    BOOST_CHECK_EQUAL("test_user",PQuser(m_db));
    BOOST_CHECK_EQUAL("test_pass",PQpass(m_db));
    BOOST_CHECK_EQUAL("testdb",   PQdb(m_db));

    // dont' get clever here, this will only work for literal ints
    m_stmt = PQexec(conn, "select 1 as id, 12 as name");

    // check we can make a query
    BOOST_REQUIRE_EQUAL(PGRES_COMMAND_OK,PQstatus(m_db));
    BOOST_REQUIRE_EQUAL(1,PQntuples(m_stmt));
    BOOST_REQUIRE_EQUAL(2,PQnfields(m_stmt));

    // check we can pull an ID
    BOOST_REQUIRE_EQUAL(0,PQfnumber(m_stmt,"id"));
    BOOST_REQUIRE_EQUAL(1,PQgetlength(m_stmt, 0, PQfnumber(m_stmt,"id")));
    BOOST_REQUIRE_EQUAL("1",PQgetvalue(m_stmt, 0, PQfnumber(m_stmt,"id")));

    // check we can pull a Name
    BOOST_REQUIRE_EQUAL(1,PQfnumber(m_stmt,"name"));
    BOOST_REQUIRE_EQUAL(2,PQgetlength(m_stmt, 0, PQfnumber(m_stmt,"name")));
    BOOST_REQUIRE_EQUAL("12",PQgetvalue(m_stmt, 0, PQfnumber(m_stmt,"name")));
}

BOOST_AUTO_TEST_SUITE_END()
