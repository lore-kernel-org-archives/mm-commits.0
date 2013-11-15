From: akpm@linux-foundation.org
Subject: [folded-merged]
 debugging-keep-track-of-page-owners-fix-2-fix.patch removed from -mm tree
Date: Fri, 15 Nov 2013 14:24:04 -0800
Message-ID: <52869f04.jDt6lAABUsiNf+nd%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:36352 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752081Ab3KOWYF (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 15 Nov 2013 17:24:05 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, minchan@kernel.org, akpm@linux-foundation.org

Subject: [folded-merged] debugging-keep-track-of-page-owners-fix-2-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,minchan@kernel.org,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 15 Nov 2013 14:24:04 -0800


The patch titled
     Subject: debugging-keep-track-of-page-owners-fix-2-fix
has been removed from the -mm tree.  Its filename was
     debugging-keep-track-of-page-owners-fix-2-fix.patch

This patch was dropped because it was folded into debugging-keep-track-of-page-owners.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: debugging-keep-track-of-page-owners-fix-2-fix

Reduce scope of `val', fix coding style

Cc: Minchan Kim <minchan@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/page_owner.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff -puN Documentation/page_owner.c~debugging-keep-track-of-page-owners-fix-2-fix Documentation/page_owner.c
--- a/Documentation/page_owner.c~debugging-keep-track-of-page-owners-fix-2-fix
+++ a/Documentation/page_owner.c
@@ -32,12 +32,13 @@ int read_block(char *buf, FILE *fin)
 {
 	int ret = 0;
 	int hit = 0;
-	int val;
 	char *curr = buf;
 
 	for (;;) {
-		val = getc(fin);
-		if (val == EOF) return -1;
+		int val = getc(fin);
+
+		if (val == EOF)
+			return -1;
 		*curr = val;
 		ret++;
 		if (*curr == '\n' && hit == 1)
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
posix_acl-uninlining.patch
mm.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
mm-drop-actor-argument-of-do_generic_file_read-fix.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix-2-fix-fix-fix.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

