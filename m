From: akpm@linux-foundation.org
Subject: + kdump-documentation-cleanups.patch added to -mm tree
Date: Fri, 05 Oct 2007 16:27:36 -0700
Message-ID: <200710052327.l95NRapB030475@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33461 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759634AbXJEX1v (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2007 19:27:51 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: pavel@ucw.cz, pavel@suse.cz


The patch titled
     kdump: documentation cleanups
has been added to the -mm tree.  Its filename is
     kdump-documentation-cleanups.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: kdump: documentation cleanups
From: Pavel Machek <pavel@ucw.cz>

This cleans up kdump documentation a bit. Plus I do not think we want
to mention Linux trademark in _every_ file in documentation....

Signed-off-by: Pavel Machek <pavel@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---


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

hibernation-make-sure-that-acpi-is-enabled-in-acpi_hibernation_finish.patch
acpi-clean-up-acpi_enter_sleep_state_prep.patch
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
pnp-make-pnpacpi_suspend-handle-errors.patch
kdump-documentation-cleanups.patch
