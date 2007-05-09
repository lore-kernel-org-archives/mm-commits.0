From: akpm@linux-foundation.org
Subject: - pasemi-hardware-rng-driver-tidy.patch removed from -mm tree
Date: Wed, 09 May 2007 01:50:07 -0700
Message-ID: <200705090850.l498o7Av018432@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([65.172.181.25]:32780 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754511AbXEIIux (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 9 May 2007 04:50:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, egor@pasemi.com, galak@gate.crashing.org, mb@bu3sch.de, olof@lixom.net, paulus@samba.org, mm-commits@vger.kernel.org


The patch titled
     pasemi-hardware-rng-driver-tidy
has been removed from the -mm tree.  Its filename was
     pasemi-hardware-rng-driver-tidy.patch

This patch was dropped because it was folded into pasemi-hardware-rng-driver.patch

------------------------------------------------------
Subject: pasemi-hardware-rng-driver-tidy
From: Andrew Morton <akpm@linux-foundation.org>

Cc: Egor Martovetsky <egor@pasemi.com>
Cc: Kumar Gala <galak@gate.crashing.org>
Cc: Michael Buesch <mb@bu3sch.de>
Cc: Olof Johansson <olof@lixom.net>
Cc: Paul Mackerras <paulus@samba.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/hw_random/pasemi-rng.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff -puN drivers/char/hw_random/pasemi-rng.c~pasemi-hardware-rng-driver-tidy drivers/char/hw_random/pasemi-rng.c
--- a/drivers/char/hw_random/pasemi-rng.c~pasemi-hardware-rng-driver-tidy
+++ a/drivers/char/hw_random/pasemi-rng.c
@@ -125,16 +125,14 @@ static int __devexit rng_remove(struct o
 	return 0;
 }
 
-static struct of_device_id rng_match[] =
-{
+static struct of_device_id rng_match[] = {
 	{
 		.compatible      = "1682m-rng",
 	},
 	{},
 };
 
-static struct of_platform_driver rng_driver =
-{
+static struct of_platform_driver rng_driver = {
 	.name		= "pasemi-rng",
 	.match_table	= rng_match,
 	.probe		= rng_probe,
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
slub-add-support-for-dynamic-cacheline-size-determination.patch
swsusp-clean-up-print.patch
display-all-possible-partitions-when-the-root-filesystem-failed-to-mount.patch
pasemi-hardware-rng-driver.patch
pasemi-hardware-rng-driver-tidy.patch
nbd-check-the-return-value-of-sysfs_create_file-fix.patch
mutex_lock_interruptible-add-__must_check.patch
mutex_lock_interruptible-add-__must_check-must-fix.patch
afs-implement-basic-file-write-support-fix.patch
tty-add-compat_ioctl-fix.patch
blacklist-dell-optiplex-320-from-using-the-hpet-fix.patch
define-and-use-new-eventscpu_lock_acquire-and-cpu_lock_release.patch
call-cpu_chain-with-cpu_down_failed-if-cpu_down_prepare-failed-vs-reduce-size-of-task_struct-on-64-bit-machines.patch
kthread-dont-depend-on-work-queues-take-2.patch
fix-kthread_create-vs-freezer-theoretical-race.patch
make-cancel_rearming_delayed_work-reliable-spelling.patch
declare-struct-ktime.patch
make-futex_wait-use-an-hrtimer-for-timeout.patch
linux-kernel-markers-i386-optimization.patch
signal-timer-event-fds-v9-signalfd-core.patch
signal-timer-event-fds-v9-timerfd-core.patch
signal-timer-event-fds-v9-eventfd-core.patch
revoke-core-code-fix-shared-mapping-revoke.patch
revoke-wire-up-i386-system-calls.patch
lguest-vs-x86_64-mm-use-per-cpu-variables-for-gdt-pda.patch
lguest-the-host-code-vs-x86_64-mm-i386-separate-hardware-defined-tss-from-linux-additions.patch
lguest-the-host-code-vs-futex-new-private-futexes.patch
fs-convert-core-functions-to-zero_user_page-pass-kmap-type.patch
fs-convert-core-functions-to-zero_user_page-fix-2.patch
ntfs-use-zero_user_page-fix.patch
make-vm-statistics-update-interval-configurable-fix.patch
rename-thread_info-to-stack-fix.patch
reiser4-slab-allocators-remove-slab_debug_initial-flag.patch
integrity-new-hooks-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix.patch
integrity-evm-as-an-integrity-service-provider-tidy-fix-2.patch
integrity-ima-integrity_measure-support-tidy.patch
integrity-ima-integrity_measure-support-fix.patch
integrity-ima-integrity_measure-support-fix-2.patch
integrity-tpm-internal-kernel-interface-tidy.patch
w1-build-fix.patch
