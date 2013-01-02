From: akpm@linux-foundation.org
Subject: [folded-merged] synchro-test-module-document-default-load-and-interval-values.patch removed from -mm tree
Date: Wed, 02 Jan 2013 14:37:02 -0800
Message-ID: <20130102223703.4A11A200059@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-fa0-f73.google.com ([209.85.161.73]:57911 "EHLO
	mail-fa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752757Ab3ABWhF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 2 Jan 2013 17:37:05 -0500
Received: by mail-fa0-f73.google.com with SMTP id v1so909424fav.4
        for <mm-commits@vger.kernel.org>; Wed, 02 Jan 2013 14:37:04 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: walken@google.com, dhowells@redhat.com, riel@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: synchro-test module: document default load and interval values
has been removed from the -mm tree.  Its filename was
     synchro-test-module-document-default-load-and-interval-values.patch

This patch was dropped because it was folded into mutex-subsystem-synchro-test-module.patch

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
mutex-subsystem-synchro-test-module.patch

