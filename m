From: akpm@linux-foundation.org
Subject: + docbook-add-futexes-to-kernel-locking-docbook.patch added to
 -mm tree
Date: Fri, 14 Jun 2013 14:39:13 -0700
Message-ID: <51bb8d81.OhR22XVQ1/4Cy2ki%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:47019 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752310Ab3FNVjO (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 14 Jun 2013 17:39:14 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, rdunlap@infradead.org

Subject: + docbook-add-futexes-to-kernel-locking-docbook.patch added to -mm tree
To: rdunlap@infradead.org,rob@landley.net
From: akpm@linux-foundation.org
Date: Fri, 14 Jun 2013 14:39:13 -0700


The patch titled
     Subject: docbook: add futexes to kernel-locking docbook
has been added to the -mm tree.  Its filename is
     docbook-add-futexes-to-kernel-locking-docbook.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: docbook: add futexes to kernel-locking docbook

Add Fast User Mutexes (futexes) to kernel-locking docbook.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Rob Landley <rob@landley.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/DocBook/kernel-locking.tmpl |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff -puN Documentation/DocBook/kernel-locking.tmpl~docbook-add-futexes-to-kernel-locking-docbook Documentation/DocBook/kernel-locking.tmpl
--- a/Documentation/DocBook/kernel-locking.tmpl~docbook-add-futexes-to-kernel-locking-docbook
+++ a/Documentation/DocBook/kernel-locking.tmpl
@@ -1955,12 +1955,17 @@ machines due to caching.
    </sect1>
   </chapter>
 
-  <chapter id="apiref">
+  <chapter id="apiref-mutex">
    <title>Mutex API reference</title>
 !Iinclude/linux/mutex.h
 !Ekernel/mutex.c
   </chapter>
 
+  <chapter id="apiref-futex">
+   <title>Futex API reference</title>
+!Ikernel/futex.c
+  </chapter>
+
   <chapter id="references">
    <title>Further reading</title>
 
_

Patches currently in -mm which might be from rdunlap@infradead.org are

linux-next.patch
docbook-add-futexes-to-kernel-locking-docbook.patch
debugging-keep-track-of-page-owners-fix-2.patch

