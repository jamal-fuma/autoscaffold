#include <stdio.h>
#include <stdlib.h>
#include <string>
#include <libpq-fe.h>

struct Version
{
    enum { eMajorBase = 10000, eMinorBase = 100 };

    int m_major, m_minor, m_micro;

    Version()
        : m_major(0)
        , m_minor(0)
        , m_micro(0)
    {
    }
    ~Version() {}

    int number() const
    {
        int sum = (m_major * 10  * Version::eMajorBase);
        sum += (m_minor * 10 * Version::eMinorBase);
        if(m_minor <= 10)
            sum /= 10;

        sum += (m_micro);
        return sum;
    }

    std::string to_string() const
    {
        char buf[256] = {0};
        snprintf(buf,sizeof(buf)-1,"%d.%d.%d",
                 m_major, m_minor, m_micro
                );
        return buf;
    }

    bool operator ==(const Version & rhs) const
    {
        if(rhs.m_major == m_major)
            if(rhs.m_minor == m_minor)
                return (rhs.m_micro == m_micro);
        return false;
    }

    void reset(const std::string & ver)
    {
        reset(ver.c_str());
    }

    void reset(const char * ver)
    {
        sscanf(ver,"%d.%d.%d",&m_major,&m_minor,&m_micro);
    }

    void reset(int val)
    {
        m_major = val / eMajorBase;
        val %= eMajorBase;

        m_minor = val / eMinorBase;
        val %= eMinorBase;

        m_micro = val;
    }
};

struct PostgreSQLVersion
{
    Version m_version;

    PostgreSQLVersion()
        : m_version() {}

    ~PostgreSQLVersion() {}

    template <typename T>
    explicit PostgreSQLVersion(const T & ver)
        : m_version()
    {
        m_version.reset(ver);
    }

    bool operator==(const PostgreSQLVersion & rhs) const
    {
        return rhs.m_version == m_version;
    }

    int number() const
    {
        return m_version.number();
    }

    std::string to_string() const
    {
        return m_version.to_string();
    }

    static int Match(const char * version, const char * opcode)
    {
        PostgreSQLVersion actual((PostgreSQLVersion(PQlibVersion())));
        PostgreSQLVersion expected((PostgreSQLVersion(version)));
        bool status = false;

        int diff = (actual.number() - expected.number());
        switch(*opcode++)
        {
        default: // fall through
        case '=':
            status = (diff == 0);
            break;

        case '<':
            status = (*opcode && '=' == *opcode)
                     ? (diff <= 0)
                     : (diff < 0) ;
            break;

        case '>':
            status = (*opcode && '=' == *opcode)
                     ? (diff >= 0)
                     : (diff > 0) ;
            break;
        }

        const char * text = (status) ? "Pass" : "Fail";

        printf("%s:%d:%s\n", text, expected.number(), actual.to_string().c_str());
        return (status) ? EXIT_SUCCESS : EXIT_FAILURE;
    }
};

int main(int argc, char ** argv)
{
    return (argc > 2) ?  PostgreSQLVersion::Match(argv[2],argv[1]) : EXIT_FAILURE;
}
