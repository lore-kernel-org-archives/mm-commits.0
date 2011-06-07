From: akpm@linux-foundation.org
Subject: [folded] kexec-remove-kmsg_dump_kexec-fix.patch removed from -mm tree
Date: Tue, 07 Jun 2011 16:58:57 -0700
Message-ID: <201106072358.p57NwvO4003367@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:48494 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754138Ab1FGX73 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 7 Jun 2011 19:59:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, ebiederm@xmission.com, jarod@redhat.com, kosaki.motohiro@jp.fujitsu.com, vgoyal@redhat.com, xiyou.wangcong@gmail.com, mm-commits@vger.kernel.org


The patch titled
     kexec-remove-kmsg_dump_kexec-fix
has been removed from the -mm tree.  Its filename was
     kexec-remove-kmsg_dump_kexec-fix.patch

This patch was dropped because it was folded into kexec-remove-kmsg_dump_kexec.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kexec-remove-kmsg_dump_kexec-fix
From: Andrew Morton <akpm@linux-foundation.org>

fix powerpc build

Cc: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: Jarod Wilson <jarod@redhat.com>
Cc: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: WANG Cong <xiyou.wangcong@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/platforms/pseries/nvram.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN arch/powerpc/platforms/pseries/nvram.c~kexec-remove-kmsg_dump_kexec-fix arch/powerpc/platforms/pseries/nvram.c
--- a/arch/powerpc/platforms/pseries/nvram.c~kexec-remove-kmsg_dump_kexec-fix
+++ a/arch/powerpc/platforms/pseries/nvram.c
@@ -490,7 +490,6 @@ static void oops_to_nvram(struct kmsg_du
 		/* These are almost always orderly shutdowns. */
 		return;
 	case KMSG_DUMP_OOPS:
-	case KMSG_DUMP_KEXEC:
 		break;
 	case KMSG_DUMP_PANIC:
 		panicking = true;
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

backlight-add-backlight-type-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix.patch
vmscanmemcg-memcg-aware-swap-token-fix-checkpatch-fixes.patch
memcg-add-documentation-for-the-memorynumastat-api-fix.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
drivers-base-platformc-dont-mark-platform_device_register_resndata-as-__init_or_module.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machines-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
writeback-sync-expired-inodes-first-in-background-writeback.patch
writeback-split-inode_wb_list_lock-into-bdi_writebacklist_lock.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-calibratec-calibrate_delay-tidy-up-the-pr_info-messages.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-initialize-spread-rotor-lazily-fix.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

