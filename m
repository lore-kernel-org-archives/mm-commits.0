From: akpm@linux-foundation.org
Subject: - sysrq-docs-document-sequence-that-actually-works.patch removed from -mm tree
Date: Wed, 10 Oct 2007 14:10:06 -0700
Message-ID: <200710102110.l9ALA6rJ025901@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:36226 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756558AbXJJVKQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 10 Oct 2007 17:10:16 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     sysrq docs: document sequence that actually works
has been removed from the -mm tree.  Its filename was
     sysrq-docs-document-sequence-that-actually-works.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: sysrq docs: document sequence that actually works
From: Pavel Machek <pavel@ucw.cz>

Document sequence of keypresses that actually works. Yes, this changed
year-or-so ago.

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysrq.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/sysrq.txt~sysrq-docs-document-sequence-that-actually-works Documentation/sysrq.txt
--- a/Documentation/sysrq.txt~sysrq-docs-document-sequence-that-actually-works
+++ a/Documentation/sysrq.txt
@@ -43,7 +43,7 @@ On x86   - You press the key combo 'ALT-
            keyboards may not have a key labeled 'SysRq'. The 'SysRq' key is
            also known as the 'Print Screen' key. Also some keyboards cannot
 	   handle so many keys being pressed at the same time, so you might
-	   have better luck with "press Alt", "press SysRq", "release Alt",
+	   have better luck with "press Alt", "press SysRq", "release SysRq",
 	   "press <command key>", release everything.
 
 On SPARC - You press 'ALT-STOP-<command key>', I believe.
_

Patches currently in -mm which might be from pavel@ucw.cz are

git-acpi.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
make-kernel-power-maincsuspend_enter-static.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
freezer-be-more-verbose.patch
freezer-use-wait-queue-instead-of-busy-looping.patch
freezer-measure-freezing-time.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option.patch
serial-turn-serial-console-suspend-a-boot-rather-than-compile-time-option-update.patch
s2ram-kill-old-debugging-junk.patch
hibernation-arbitrary-boot-kernel-support-generic-code-rev-2.patch
hibernation-arbitrary-boot-kernel-support-on-x86_64-rev-2.patch
hibernation-pass-cr3-in-the-image-header-on-x86_64-rev-2.patch
hibernation-use-temporary-page-tables-for-kernel-text-mapping-on-x86_64.patch
hibernation-check-if-acpi-is-enabled-during-restore-in-the-right-place.patch
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4.patch
hibernation-enter-platform-hibernation-state-in-a-consistent-way-rev-4-fix.patch
lp_console-cleanups.patch
pnp-make-pnpacpi_suspend-handle-errors.patch
kdump-documentation-cleanups.patch
vmtxt-document-min_free_pages-as-critical-for-correctness.patch
