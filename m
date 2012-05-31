From: akpm@linux-foundation.org
Subject: [folded] ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix.patch removed from -mm tree
Date: Thu, 31 May 2012 16:16:02 -0700
Message-ID: <20120531231602.9BCEAA009B@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-bk0-f74.google.com ([209.85.214.74]:40275 "EHLO
	mail-bk0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758594Ab2EaXQF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 31 May 2012 19:16:05 -0400
Received: by bkty5 with SMTP id y5so82531bkt.1
        for <mm-commits@vger.kernel.org>; Thu, 31 May 2012 16:16:03 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, dledford@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: ipc/mqueue: using vmalloc requires including vmalloc.h
has been removed from the -mm tree.  Its filename was
     ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix.patch

This patch was dropped because it was folded into ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: ipc/mqueue: using vmalloc requires including vmalloc.h

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Doug Ledford <dledford@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN ipc/mqueue.c~ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix ipc/mqueue.c
--- a/ipc/mqueue.c~ipc-mqueue-update-maximums-for-the-mqueue-subsystem-fix
+++ a/ipc/mqueue.c
@@ -24,6 +24,7 @@
 #include <linux/mqueue.h>
 #include <linux/msg.h>
 #include <linux/skbuff.h>
+#include <linux/vmalloc.h>
 #include <linux/netlink.h>
 #include <linux/syscalls.h>
 #include <linux/audit.h>
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

origin.patch
ipc-mqueue-update-maximums-for-the-mqueue-subsystem.patch
ipc-mqueue-improve-performance-of-send-recv.patch
ipc-mqueue-improve-performance-of-send-recv-fix.patch
ipc-mqueue-improve-performance-of-send-recv-use-correct-gfp-flags-in-msg_insert.patch
ipc-mqueue-correct-mq_attr_ok-test.patch
ipc-mqueue-correct-mq_attr_ok-test-fix.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation.patch
ipc-mqueue-strengthen-checks-on-mqueue-creation-fix.patch
tools-selftests-add-mq_perf_tests.patch
tools-selftests-add-mq_perf_tests-checkpatch-fixes.patch
ipc-mqueue-add-rbtree-node-caching-support.patch

