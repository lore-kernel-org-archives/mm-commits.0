From: akpm@linux-foundation.org
Subject: [merged] checkpatch-fix-spello.patch removed from -mm tree
Date: Tue, 14 Oct 2014 11:19:33 -0700
Message-ID: <543d6935.YrEZ2IJbdruJl98/%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44148 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755448AbaJNSTb (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 14 Oct 2014 14:19:31 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, joe@perches.com, mm-commits@vger.kernel.org


The patch titled
     Subject: checkpatch: fix spello
has been removed from the -mm tree.  Its filename was
     checkpatch-fix-spello.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: checkpatch: fix spello

The plural of parenthesis is parentheses.

Cc: Joe Perches <joe@perches.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 scripts/checkpatch.pl |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN scripts/checkpatch.pl~checkpatch-fix-spello scripts/checkpatch.pl
--- a/scripts/checkpatch.pl~checkpatch-fix-spello
+++ a/scripts/checkpatch.pl
@@ -4126,7 +4126,7 @@ sub process {
 					      "Macros with multiple statements should be enclosed in a do - while loop\n" . "$herectx");
 				} else {
 					ERROR("COMPLEX_MACRO",
-					      "Macros with complex values should be enclosed in parenthesis\n" . "$herectx");
+					      "Macros with complex values should be enclosed in parentheses\n" . "$herectx");
 				}
 			}
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
kernel-posix-timersc-code-clean-up-checkpatch-fixes.patch
input-route-kbd-leds-through-the-generic-leds-layer.patch
o2dlm-fix-null-pointer-dereference-in-o2dlm_blocking_ast_wrapper-checkpatch-fixes.patch
ocfs2-free-inode-when-i_count-becomes-zero.patch
ocfs2-add-orphan-recovery-types-in-ocfs2_recover_orphans-fix.patch
mm.patch
mm-introduce-do_shared_fault-and-drop-do_fault-fix-fix.patch
do_shared_fault-check-that-mmap_sem-is-held.patch
rtc-pm8xxx-rework-to-support-pm8941-rtc-checkpatch-fixes.patch
linux-next.patch
linux-next-git-rejects.patch
drivers-gpio-gpio-zevioc-fix-build.patch
mm-replace-remap_file_pages-syscall-with-emulation.patch
debugging-keep-track-of-page-owners.patch
debugging-keep-track-of-page-owners-fix.patch
journal_add_journal_head-debug.patch
journal_add_journal_head-debug-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch
mutex-subsystem-synchro-test-module.patch
slab-leaks3-default-y.patch

