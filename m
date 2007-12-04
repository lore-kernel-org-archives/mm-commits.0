From: akpm@linux-foundation.org
Subject: - uml-after_sleep_interval-should-return-something.patch removed from -mm tree
Date: Mon, 03 Dec 2007 23:37:43 -0800
Message-ID: <200712040737.lB47bh53006815@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:33981 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751617AbXLDHiR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 02:38:17 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jdike@addtoit.com, jdike@linux.intel.com, mm-commits@vger.kernel.org


The patch titled
     uml: after_sleep_interval should return something
has been removed from the -mm tree.  Its filename was
     uml-after_sleep_interval-should-return-something.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: uml: after_sleep_interval should return something
From: Jeff Dike <jdike@addtoit.com>

I forgot to have an int-returning function actually return something.

Signed-off-by: Jeff Dike <jdike@linux.intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/um/os-Linux/time.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/um/os-Linux/time.c~uml-after_sleep_interval-should-return-something arch/um/os-Linux/time.c
--- a/arch/um/os-Linux/time.c~uml-after_sleep_interval-should-return-something
+++ a/arch/um/os-Linux/time.c
@@ -77,6 +77,7 @@ long long os_nsecs(void)
 #ifdef UML_CONFIG_NO_HZ
 static int after_sleep_interval(struct timespec *ts)
 {
+	return 0;
 }
 #else
 static inline long long timespec_to_us(const struct timespec *ts)
_

Patches currently in -mm which might be from jdike@addtoit.com are

aio-only-account-i-o-wait-time-in-read_events-if-there-are-active-requests.patch
git-kvm.patch
uml-add-asm-um-asmh.patch
uml-arch-um-include-inith-needs-a-definition-of-__used.patch
uml-implement-get_wchan.patch
uml-implement-get_wchan-fix.patch
uml-get-rid-of-asmlinkage.patch
uml-get-rid-of-asmlinkage-checkpatch-fixes.patch
uml-document-new-ubd-flag.patch
uml-further-bugsc-tidying.patch
uml-further-bugsc-tidying-checkpatch-fixes.patch
uml-smp-needs-to-depend-on-broken-for-now.patch
uml-console-driver-cleanups.patch
uml-clonec-tidying.patch
uml-borrow-consth-techniques.patch
uml-delete-some-unused-headers.patch
uml-allow-lflags-on-command-line.patch
uml-tidy-kern_utilh.patch
uml-tidy-pgtableh.patch
uml-tidy-pgtableh-fix.patch
uml-reconst-a-parameter.patch
arch-um-remove-duplicate-includes.patch
uml-host-tls-diagnostics.patch
uml-move-um_virt_to_phys.patch
uml-header-untangling.patch
uml-style-cleanup.patch
uml-currenth-cleanup.patch
uml-fix-page-table-data-sizes.patch
uml-add-virt_to_pte.patch
uml-simplify-sigsegv-handling.patch
uml-use-ptrace-directly-in-libc-code.patch
uml-kill-processes-instead-of-panicing-kernel.patch
uml-clean-up-task_size-usage.patch
uml-cover-stubs-with-a-vma.patch
uml-fix-command-line-cflags-and-ldflags-support.patch
uml-style-fixes-in-arch-um-os-linux.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
iget-stop-hostfs-from-using-iget-and-read_inode.patch
iget-stop-hostfs-from-using-iget-and-read_inode-checkpatch-fixes.patch
