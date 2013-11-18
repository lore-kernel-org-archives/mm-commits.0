From: akpm@linux-foundation.org
Subject: [merged] mm-drop-actor-argument-of-do_generic_file_read-fix.patch removed from -mm tree
Date: Mon, 18 Nov 2013 12:06:01 -0800
Message-ID: <528a7329.G4s5c69BWBW1zWTF%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:58179 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752355Ab3KRUGC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 18 Nov 2013 15:06:02 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, willy@linux.intel.com, liwanp@linux.vnet.ibm.com, kirill.shutemov@linux.intel.com, hughd@google.com, dave.hansen@linux.intel.com, akpm@linux-foundation.org

Subject: [merged] mm-drop-actor-argument-of-do_generic_file_read-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,dave.hansen@linux.intel.com,hughd@google.com,kirill.shutemov@linux.intel.com,liwanp@linux.vnet.ibm.com,willy@linux.intel.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Mon, 18 Nov 2013 12:06:01 -0800


The patch titled
     Subject: mm-drop-actor-argument-of-do_generic_file_read-fix
has been removed from the -mm tree.  Its filename was
     mm-drop-actor-argument-of-do_generic_file_read-fix.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: mm-drop-actor-argument-of-do_generic_file_read-fix

fix mm-drop-actor-argument-of-do_generic_file_read for linux-next changes

Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox <willy@linux.intel.com>
Cc: Wanpeng Li <liwanp@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/filemap.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/filemap.c~mm-drop-actor-argument-of-do_generic_file_read-fix mm/filemap.c
--- a/mm/filemap.c~mm-drop-actor-argument-of-do_generic_file_read-fix
+++ a/mm/filemap.c
@@ -1206,7 +1206,7 @@ page_ok:
 		 * "pos" here (the actor routine has to update the user buffer
 		 * pointers and the remaining count).
 		 */
-		ret = file_read_actor(desc, page, offset, nr);
+		ret = file_read_iter_actor(desc, page, offset, nr);
 		offset += ret;
 		index += offset >> PAGE_CACHE_SHIFT;
 		offset &= ~PAGE_CACHE_MASK;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
i-need-old-gcc.patch
kernel-time-tick-commonc-document-tick_do_timer_cpu.patch
drivers-block-ccissc-cciss_init_one-use-proper-errnos.patch
block-blk-mq-cpuc-use-hotcpu_notifier.patch
posix_acl-uninlining.patch
mm.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-fix.patch
kmod-run-usermodehelpers-only-on-cpus-allowed-for-kthreadd-v2-checkpatch-fixes.patch
linux-next.patch
debugging-keep-track-of-page-owners.patch
journal_add_journal_head-debug.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch
put_bh-debug.patch

