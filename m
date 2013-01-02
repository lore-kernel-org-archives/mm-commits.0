From: akpm@linux-foundation.org
Subject: + synchro-test-module-document-default-load-and-interval-values.patch added to -mm tree
Date: Wed, 02 Jan 2013 14:34:25 -0800
Message-ID: <20130102223426.83EA920004E@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ea0-f201.google.com ([209.85.215.201]:41278 "EHLO
	mail-ea0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752743Ab3ABWe3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 17:34:29 -0500
Received: by mail-ea0-f201.google.com with SMTP id b14so909941eaa.2
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 14:34:27 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: walken@google.com, dhowells@redhat.com, riel@redhat.com


The patch titled
     Subject: synchro-test module: document default load and interval values
has been added to the -mm tree.  Its filename is
     synchro-test-module-document-default-load-and-interval-values.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Michel Lespinasse <walken@google.com>
Subject: synchro-test module: document default load and interval values

The synchro-test module default parameters are to keep the lock for 2uS
and wait 2uS between release and the next attempted acquisition.  Having
the documentation wrong on this point was quite confusing !

Signed-off-by: Michel Lespinasse <walken@google.com>
Cc: David Howells <dhowells@redhat.com>
Cc: Rik van Riel <riel@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/synchro-test.txt |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN Documentation/synchro-test.txt~synchro-test-module-document-default-load-and-interval-values Documentation/synchro-test.txt
--- a/Documentation/synchro-test.txt~synchro-test-module-document-default-load-and-interval-values
+++ a/Documentation/synchro-test.txt
@@ -42,12 +42,12 @@ The available arguments are:
 
  (*) load=N
 
-	Each thread delays for N uS whilst holding the lock. The default is 0.
+	Each thread delays for N uS whilst holding the lock. The default is 2.
 
  (*) interval=N
 
 	Each thread delays for N uS whilst not holding the lock. The default
-	is 0.
+	is 2.
 
  (*) do_sched=1
 
_

Patches currently in -mm which might be from walken@google.com are

linux-next.patch
mtd-mtd_nandecctest-use-prandom_bytes-instead-of-get_random_bytes.patch
mtd-mtd_oobtest-convert-to-use-prandom-library.patch
mtd-mtd_pagetest-convert-to-use-prandom-library.patch
mtd-mtd_speedtest-use-prandom_bytes.patch
mtd-mtd_subpagetest-convert-to-use-prandom-library.patch
mtd-mtd_stresstest-use-prandom_bytes.patch
synchro-test-module-add-spinlock-test.patch
synchro-test-module-document-default-load-and-interval-values.patch

