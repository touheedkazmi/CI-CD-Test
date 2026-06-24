@isTest(seeAllData=false)
private class ZipCodeNameTest {

    private class ZipCodeNameMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(200);
            res.setBody('{"results":{"90210":[{"city":"Beverly Hills"}]}}');
            return res;
        }
    }

    @isTest
    static void testGetCityForZipCodeReturnsCityName() {
        Test.setMock(HttpCalloutMock.class, new ZipCodeNameMock());

        List<String> result = ZipCodeName.getCityForZipCode(new List<Integer>{90210});

        System.assertEquals(1, result.size());
        System.assertEquals('Beverly Hills', result[0]);
    }
}
