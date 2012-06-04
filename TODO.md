TODO
========

* Upgrade Yesod to 1.0
* Change directory structure
* New models

        Project sql=projects
          name Text
          createdAt UTCTime
        TimeAllocReport sql=time_alloc_reports
          projectId #ProjectId
          commandLine Text
          rawData ByteString
          createdAt UTCTime
        HeapReport sql=heap_reports
          projectId #ProjectId
          commandLine Text
          rawData ByteString
          createdAt UTCTime
        EventReport sql=event_reports
          projectId #ProjectId
          commandLine Text
          rawData ByteString
          createdAt UTCTime

* New routes

        /projects GET POST
        /projects/#ProjectId GET DELETE
        /projects/#ProjectId/time POST
        /projects/#ProjectId/time/#TimeAllocReportId GET DELETE
        /projects/#ProjectId/alloc POST -- same as /time
        /projects/#ProjectId/alloc/#TimeAllocReportId GET DELETE
        /projects/#ProjectId/heap POST
        /projects/#ProjectId/heap/#HeapReportId GET DELETE
        /projects/#ProjectId/event POST
        /projects/#ProjectId/event/#EventReportId GET DELETE

* Use a persistent database i.e. SQLite
* Rewrite JavaScript code with Batman.js
* Upgrade d3.js to version 2
* Design
    - Twitter Bootstrap?
    - Responsive?
