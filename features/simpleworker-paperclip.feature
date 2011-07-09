Feature: Paperclip configuration
  In order to reduce load on my application servers
  As an application developer
  I want to configure Paperclip to send jobs to SimpleWorker

  Scenario: Resize an avatar locally
    Given a test image located at "21st North Street"
    When I fake an upload of the avatar
    Then the image should be marked for processing
