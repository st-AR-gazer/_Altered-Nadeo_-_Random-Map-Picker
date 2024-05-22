/* 
    I'ma be real, everything here should probably actually be in openplanet propper, but makeing a featurerequest is a lot of work... 
    And since they're not already there allready, the ods of them being added are slim imo... 
*/

namespace Text
{
    int LastIndexOf(const string &in str, const string &in value) {
        int lastIndex = -1;
        int index = str.IndexOf(value);
        while (index != -1) {
            lastIndex = index;
            index = str.IndexOf(value, lastIndex + 1);
        }
        return lastIndex;
    }
}

namespace Json {
    bool AsBool(const Json::Value &in value) {
        return value.GetType() == Json::Type::Boolean && value;
    }
}