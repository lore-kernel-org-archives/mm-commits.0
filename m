From: akpm@linux-foundation.org
Subject: + move-slabinfoc-to-tools-vm.patch added to -mm tree
Date: Thu, 09 Feb 2012 15:03:29 -0800
Message-ID: <20120209230329.E4B58A0341@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ee0-f74.google.com ([74.125.83.74]:35848 "EHLO
	mail-ee0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758629Ab2BIXDc (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 9 Feb 2012 18:03:32 -0500
Received: by eekb15 with SMTP id b15so72493eek.1
        for <mm-commits@vger.kernel.org>; Thu, 09 Feb 2012 15:03:30 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: dyoung@redhat.com, cl@linux.com, fengguang.wu@intel.com, fweisbec@gmail.com, penberg@cs.helsinki.fi


The patch titled
     Subject: mm: move slabinfo.c to tools/vm
has been added to the -mm tree.  Its filename is
     move-slabinfoc-to-tools-vm.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Dave Young <dyoung@redhat.com>
Subject: mm: move slabinfo.c to tools/vm

We have tools/vm/ folder for vm tools, so move slabinfo.c from tools/slub/
to tools/vm/

Signed-off-by: Dave Young <dyoung@redhat.com>
Cc: Wu Fengguang <fengguang.wu@intel.com>
Acked-by: Christoph Lameter <cl@linux.com>
Cc: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/Makefile |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff -puN tools/vm/Makefile~move-slabinfoc-to-tools-vm tools/vm/Makefile
--- a/tools/vm/Makefile~move-slabinfoc-to-tools-vm
+++ a/tools/vm/Makefile
@@ -3,9 +3,9 @@
 CC = $(CROSS_COMPILE)gcc
 CFLAGS = -Wall -Wextra
 
-all: page-types
+all: page-types slabinfo
 %: %.c
 	$(CC) $(CFLAGS) -o $@ $^
 
 clean:
-	$(RM) page-types
+	$(RM) page-types slabinfo
_
Subject: Subject: mm: move slabinfo.c to tools/vm

Patches currently in -mm which might be from dyoung@redhat.com are

linux-next.patch
loop-zero-fill-bio-instead-of-return-eio-for-partial-read.patch
selftests-launch-individual-selftests-from-the-main-makefile.patch
move-page-typesc-from-documentation-to-tools-vm.patch
move-slabinfoc-to-tools-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm.patch
move-hugepage-test-examples-to-tools-testing-selftests-vm-fix.patch

