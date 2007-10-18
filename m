From: akpm@linux-foundation.org
Subject: - kdump-documentation-cleanups.patch removed from -mm tree
Date: Thu, 18 Oct 2007 00:04:51 -0700
Message-ID: <200710180704.l9I74pK7031594@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58052 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753735AbXJRHXN (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Thu, 18 Oct 2007 03:23:13 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: pavel@ucw.cz, pavel@suse.cz, mm-commits@vger.kernel.org


The patch titled
     kdump: documentation cleanups
has been removed from the -mm tree.  Its filename was
     kdump-documentation-cleanups.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: kdump: documentation cleanups
From: Pavel Machek <pavel@ucw.cz>

This cleans up kdump documentation a bit. Plus I do not think we want
to mention Linux trademark in _every_ file in documentation....

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kdump/kdump.txt |   12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff -puN Documentation/kdump/kdump.txt~kdump-documentation-cleanups Documentation/kdump/kdump.txt
--- a/Documentation/kdump/kdump.txt~kdump-documentation-cleanups
+++ a/Documentation/kdump/kdump.txt
@@ -13,7 +13,7 @@ dump of the system kernel's memory needs
 the system panics). The system kernel's memory image is preserved across
 the reboot and is accessible to the dump-capture kernel.
 
-You can use common Linux commands, such as cp and scp, to copy the
+You can use common commands, such as cp and scp, to copy the
 memory image to a dump file on the local disk, or across the network to
 a remote system.
 
@@ -69,7 +69,7 @@ http://www.kernel.org/pub/linux/kernel/p
 
 This is a symlink to the latest version, which at the time of writing is
 20061214, the only release of kexec-tools-testing so far. As other versions
-are made released, the older onese will remain available at
+are released, the older ones will remain available at
 http://www.kernel.org/pub/linux/kernel/people/horms/kexec-tools/
 
 Note: Latest kexec-tools-testing git tree is available at
@@ -339,7 +339,7 @@ If die() is called, and it happens to be
 is called inside interrupt context or die() is called and panic_on_oops is set,
 the system will boot into the dump-capture kernel.
 
-On powererpc systems when a soft-reset is generated, die() is called by all cpus
+On powerpc systems when a soft-reset is generated, die() is called by all cpus
 and the system will boot into the dump-capture kernel.
 
 For testing purposes, you can trigger a crash by using "ALT-SysRq-c",
@@ -405,9 +405,3 @@ Contact
 Vivek Goyal (vgoyal@in.ibm.com)
 Maneesh Soni (maneesh@in.ibm.com)
 
-
-Trademark
-=========
-
-Linux is a trademark of Linus Torvalds in the United States, other
-countries, or both.
_

Patches currently in -mm which might be from pavel@ucw.cz are

origin.patch
git-acpi.patch
working-3d-dri-intel-agpko-resume-for-i815-chip.patch
git-x86.patch
make-kernel-power-maincsuspend_enter-static.patch
pm-move-definition-of-struct-pm_ops-to-suspendh.patch
pm-rename-struct-pm_ops-and-related-things.patch
pm-rework-struct-platform_suspend_ops.patch
pm-rework-struct-platform_suspend_ops-fixup.patch
pm-rework-struct-platform_suspend_ops-fixup-checkpatch-fixes.patch
pm-make-suspend_ops-static.patch
pm-rework-struct-hibernation_ops.patch
pm-rename-hibernation_ops-to-platform_hibernation_ops.patch
freezer-document-relationship-with-memory-shrinking.patch
freezer-do-not-sync-filesystems-from-freeze_processes.patch
freezer-prevent-new-tasks-from-inheriting-tif_freeze-set.patch
freezer-introduce-freezer-firendly-waiting-macros.patch
freezer-do-not-send-signals-to-kernel-threads.patch
freezer-be-more-verbose.patch
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
