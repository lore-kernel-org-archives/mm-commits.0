From: akpm@linux-foundation.org
Subject: + ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch added to
 -mm tree
Date: Mon, 10 Feb 2014 16:16:12 -0800
Message-ID: <52f96bcc.ZGHyjtEp4bjW36KA%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:59974 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752721AbaBKAQN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 10 Feb 2014 19:16:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, petr@vandrovec.name, joe@perches.com, akpm@linux-foundation.org

Subject: + ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch added to -mm tree
To: akpm@linux-foundation.org,joe@perches.com,petr@vandrovec.name
From: akpm@linux-foundation.org
Date: Mon, 10 Feb 2014 16:16:12 -0800


The patch titled
     Subject: ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix
has been added to the -mm tree.  Its filename is
     ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch

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
Subject: ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix

Cc: Joe Perches <joe@perches.com>
Cc: Petr Vandrovec <petr@vandrovec.name>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/ncpfs/ncp_fs.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/ncpfs/ncp_fs.h~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix fs/ncpfs/ncp_fs.h
--- a/fs/ncpfs/ncp_fs.h~ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix
+++ a/fs/ncpfs/ncp_fs.h
@@ -22,7 +22,7 @@
 
 #define ncp_dbg(level, fmt, ...)				\
 do {								\
-	if (level >= DEBUG_NCP)					\
+	if (level < DEBUG_NCP)					\
 		pr_debug(fmt, ##__VA_ARGS__);			\
 } while (0)
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
xen-properly-account-for-_page_numa-during-xen-pte-translations.patch
ocfs2-fix-ocfs2_sync_file-if-filesystem-is-readonly.patch
mm-memory-failurec-move-refcount-only-in-mf_count_increased.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
mm.patch
mm-hugetlb-improve-page-fault-scalability-fix.patch
mm-vmstat-fix-up-zone-state-accounting-fix.patch
mm-keep-page-cache-radix-tree-nodes-in-check-fix-fix.patch
ncpfs-convert-dprintk-ddprintk-to-ncp_dbg-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
linux-next-rejects.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

