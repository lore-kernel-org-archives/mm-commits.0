From: akpm@linux-foundation.org
Subject: + ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch added
 to -mm tree
Date: Tue, 11 Feb 2014 12:04:28 -0800
Message-ID: <52fa824c.joT6XaU3KTC127zB%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:41065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753998AbaBKUE3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 11 Feb 2014 15:04:29 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, petr@vandrovec.name, joe@perches.com, akpm@linux-foundation.org

Subject: + ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch added to -mm tree
To: akpm@linux-foundation.org,joe@perches.com,petr@vandrovec.name
From: akpm@linux-foundation.org
Date: Tue, 11 Feb 2014 12:04:28 -0800


The patch titled
     Subject: ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix
has been added to the -mm tree.  Its filename is
     ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix

Cc: Joe Perches <joe@perches.com>
Cc: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ncp_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ncpfs/ncp_fs.h~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix fs/ncpfs/ncp_fs.h
--- a/fs/ncpfs/ncp_fs.h~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix
+++ a/fs/ncpfs/ncp_fs.h
@@ -22,7 +22,7 @@
 
 #define ncp_dbg(level, fmt, ...)				\
 do {								\
-	if (level < DEBUG_NCP)					\
+	if (level <= DEBUG_NCP)					\
 		pr_debug(fmt, ##__VA_ARGS__);			\
 } while (0)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

