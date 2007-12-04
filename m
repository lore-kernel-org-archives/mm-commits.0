From: akpm@linux-foundation.org
Subject: + drivers-s390-net-ctcmainc-fix-build-bug.patch added to -mm tree
Date: Tue, 04 Dec 2007 11:56:03 -0800
Message-ID: <200712041956.lB4Ju3u9002133@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:46257 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751689AbXLDT5N (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 4 Dec 2007 14:57:13 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: mingo@elte.hu, heiko.carstens@de.ibm.com, kamalesh@linux.vnet.ibm.com, schwidefsky@de.ibm.com


The patch titled
     drivers/s390/net/ctcmain.c: fix build bug
has been added to the -mm tree.  Its filename is
     drivers-s390-net-ctcmainc-fix-build-bug.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: drivers/s390/net/ctcmain.c: fix build bug
From: Ingo Molnar <mingo@elte.hu>

SET_MODULE_OWNER() is obsolete.

Signed-off-by: Ingo Molnar <mingo@elte.hu>
Cc: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/s390/net/ctcmain.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN drivers/s390/net/ctcmain.c~drivers-s390-net-ctcmainc-fix-build-bug drivers/s390/net/ctcmain.c
--- a/drivers/s390/net/ctcmain.c~drivers-s390-net-ctcmainc-fix-build-bug
+++ a/drivers/s390/net/ctcmain.c
@@ -2802,7 +2802,6 @@ void ctc_init_netdevice(struct net_devic
 	dev->type = ARPHRD_SLIP;
 	dev->tx_queue_len = 100;
 	dev->flags = IFF_POINTOPOINT | IFF_NOARP;
-	SET_MODULE_OWNER(dev);
 }
 
 
_

Patches currently in -mm which might be from mingo@elte.hu are

get_task_comm-return-the-result.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped.patch
clone-prepare-to-recycle-clone_detached-and-clone_stopped-fix.patch
__group_complete_signal-fix-coredump-with-group-stop-race.patch
remove-handle_group_stop-in-favor-of-do_signal_stop.patch
exec-rework-the-group-exit-and-fix-the-race-with-kill.patch
git-acpi.patch
git-alsa.patch
git-hrt.patch
revert-git-hrt.patch
git-kvm.patch
git-sched.patch
track-accurate-idle-time-with-tick_schedidle_sleeptime.patch
merge-multiple-error-paths-in-alloc_uid-into-one.patch
iommu-sg-merging-x86-make-pci-gart-iommu-respect-the-segment-size-limits.patch
git-x86.patch
git-x86-arch-x86-kernel-ptracec-build-fix.patch
git-x86-ptrace-fix.patch
uml-add-asm-um-asmh.patch
x86_64-add-acpi-reboot-option.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support.patch
x86_64-efi-runtime-service-support-efi-basic-runtime-service-support-fixes.patch
x86_64-efi-runtime-service-support-efi-runtime-services.patch
x86_64-efi-runtime-service-support-document-for-efi-runtime-services.patch
x86_64-efi-runtime-service-support-remove-duplicated-code-from-efi_32c.patch
git-cryptodev-fixup.patch
drivers-s390-net-ctcmainc-fix-build-bug.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh.patch
i386-resolve-dependency-of-asm-i386-pgtableh-on-highmemh-checkpatch-fixes.patch
fix-proc-dcache-deadlock-in-do_exit.patch
pie-executable-randomization.patch
pie-executable-randomization-uninlining.patch
pie-executable-randomization-checkpatch-fixes.patch
read_current_time-cleanups.patch
printk-trivial-optimizations.patch
kernel-add-mutex_lock_killable.patch
vfs-use-mutex_lock_killable-in-vfs_readdir.patch
fix-__const_udelay-declaration-and-definition-mismatches.patch
clean-up-drivers-char-rtcc.patch
move-kprobes-examples-to-samples-resend-vs-git-x86.patch
isapnp-driver-semaphore-to-mutex.patch
isapnp-driver-semaphore-to-mutex-fix.patch
isapnp-driver-semaphore-to-mutex-fix-fix.patch
add-cmpxchg64-and-cmpxchg64_local-to-x86_64.patch
proc-fix-the-threaded-proc-self.patch
modules-fold-percpu_modcopy-into-modulec-and-get-rid-of-the-macro-from-hell.patch
clocksource-remove-redundant-code.patch
clockevent-simplify-list-operations.patch
timekeeping-rename-timekeeping_is_continuous-to-timekeeping_valid_for_hres.patch
time-fix-typo-in-comments.patch
time-delete-comments-that-refer-to-noexistent-symbols.patch
aout-suppress-aout-library-support-if-config_arch_supports_aout-vs-git-x86.patch
detect-atomic-counter-underflows.patch
make-frame_pointer-default=y.patch
mutex-subsystem-synchro-test-module.patch
