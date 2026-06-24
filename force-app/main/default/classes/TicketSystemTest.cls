@isTest(seeAllData=false)
private class TicketSystemTest {

    private class TicketSystemMock implements HttpCalloutMock {
        public HTTPResponse respond(HTTPRequest req) {
            HttpResponse res = new HttpResponse();
            res.setHeader('Content-Type', 'application/json');
            res.setStatusCode(201);
            res.setBody('{"id":12345}');
            return res;
        }
    }

    @isTest
    static void testCreateTicketReturnsTicketId() {
        Test.setMock(HttpCalloutMock.class, new TicketSystemMock());

        String ticketId = TicketSystem.createTicket(
            'Test Subject',
            'test@example.com',
            'Test description',
            1,
            2
        );

        System.assertEquals('12345', ticketId);
    }
}
