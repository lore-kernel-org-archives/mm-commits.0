From: akpm@linux-foundation.org
Subject: [merged] patch-b26b2d49-added-lines-with-a-missing-semicolons.patch removed from -mm tree
Date: Tue, 30 Mar 2010 12:00:34 -0400
Message-ID: <201003301901.o2UJ1gXZ031483@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54031 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753907Ab0C3TCd (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 30 Mar 2010 15:02:33 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: dhowells@redhat.com, linux@dominikbrodowski.net, starvik@axis.com, mm-commits@vger.kernel.org


The patch titled
     Patch b26b2d49 added lines with a missing semicolons
has been removed from the -mm tree.  Its filename was
     patch-b26b2d49-added-lines-with-a-missing-semicolons.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: Patch b26b2d49 added lines with a missing semicolons
From: David Howells <dhowells@redhat.com>

The following patch added lines with a missing semicolons:

	commit b26b2d494b659f988b4d75eb394dfa0ddac415c9
	Author: Dominik Brodowski <linux@dominikbrodowski.net>
	Date:   Fri Jan 1 17:40:49 2010 +0100

	resource/PCI: align functions now return start of resource

Add the missing semicolons to the FRV and CRIS arch code.

Signed-off-by: David Howells <dhowells@redhat.com>
Cc: Dominik Brodowski <linux@dominikbrodowski.net>
Cc: Mikael Starvik <starvik@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/cris/arch-v32/drivers/pci/bios.c |    2 +-
 arch/frv/mb93090-mb00/pci-frv.c       |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff -puN arch/cris/arch-v32/drivers/pci/bios.c~patch-b26b2d49-added-lines-with-a-missing-semicolons arch/cris/arch-v32/drivers/pci/bios.c
--- a/arch/cris/arch-v32/drivers/pci/bios.c~patch-b26b2d49-added-lines-with-a-missing-semicolons
+++ a/arch/cris/arch-v32/drivers/pci/bios.c
@@ -50,7 +50,7 @@ pcibios_align_resource(void *data, const
 	if ((res->flags & IORESOURCE_IO) && (start & 0x300))
 		start = (start + 0x3ff) & ~0x3ff;
 
-	return start
+	return start;
 }
 
 int pcibios_enable_resources(struct pci_dev *dev, int mask)
diff -puN arch/frv/mb93090-mb00/pci-frv.c~patch-b26b2d49-added-lines-with-a-missing-semicolons arch/frv/mb93090-mb00/pci-frv.c
--- a/arch/frv/mb93090-mb00/pci-frv.c~patch-b26b2d49-added-lines-with-a-missing-semicolons
+++ a/arch/frv/mb93090-mb00/pci-frv.c
@@ -41,7 +41,7 @@ pcibios_align_resource(void *data, const
 	if ((res->flags & IORESOURCE_IO) && (start & 0x300))
 		start = (start + 0x3ff) & ~0x3ff;
 
-	return start
+	return start;
 }
 
 
_

Patches currently in -mm which might be from dhowells@redhat.com are

linux-next.patch
frv-hide-uncached_access-when-pgprot_noncached-is-not-defined.patch
frv-fix-kernel-user-segment-handling-in-nommu-mode.patch
frv-extend-gdbstub-to-support-more-features-of-gdb.patch
frv-extend-gdbstub-to-support-more-features-of-gdb-fix.patch
keys-dont-need-to-use-rcu-in-keyring_read-as-semaphore-is-held.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
frv-duplicate-output_buffer-of-e03.patch
nommu-allow-private-mappings-of-read-only-devices.patch
umh-creds-convert-call_usermodehelper_keys-to-use-subprocess_info-init.patch
umh-creds-kill-subprocess_info-cred-logic.patch
coredump-factor-out-the-not-ispipe-file-checks.patch
coredump-cleanup-ispipe-code.patch
coredump-factor-out-put_cred-calls.patch
coredump-shift-down_writemmap_sem-into-coredump_wait.patch
proc-get_nr_threads-doesnt-need-siglock-any-longer.patch
proc-make-collect_sigign_sigcatch-rcu-safe.patch
proc-make-task_sig-lockless.patch
proc_sched_show_task-use-get_nr_threads.patch
keyctl_session_to_parent-use-thread_group_empty-to-check-singlethreadness.patch
mutex-subsystem-synchro-test-module.patch
mutex-subsystem-synchro-test-module-add-missing-header-file.patch

