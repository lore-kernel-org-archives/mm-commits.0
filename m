From: akpm@linux-foundation.org
Subject: [merged] docbook-add-futexes-to-kernel-locking-docbook.patch
 removed from -mm tree
Date: Mon, 08 Jul 2013 12:35:35 -0700
Message-ID: <51db1487.Eu2G3HSeGFBa7+n4%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51434 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752752Ab3GHTff (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 8 Jul 2013 15:35:35 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rob@landley.net, rdunlap@infradead.org

Subject: [merged] docbook-add-futexes-to-kernel-locking-docbook.patch removed from -mm tree
To: rdunlap@infradead.org,rob@landley.net,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 08 Jul 2013 12:35:35 -0700


The patch titled
     Subject: docbook: add futexes to kernel-locking docbook
has been removed from the -mm tree.  Its filename was
     docbook-add-futexes-to-kernel-locking-docbook.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Randy Dunlap <rdunlap@infradead.org>
Subject: docbook: add futexes to kernel-locking docbook

Add Fast User Mutexes (futexes) to kernel-locking docbook.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Acked-by: Rob Landley <rob@landley.net>
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

origin.patch
linux-next.patch
debugging-keep-track-of-page-owners-fix-2.patch

