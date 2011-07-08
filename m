From: akpm@linux-foundation.org
Subject: [folded] w1-ds1wm-add-a-reset-recovery-parameter-checkpatch-fixes.patch removed from -mm tree
Date: Fri, 08 Jul 2011 15:33:04 -0700
Message-ID: <201107082233.p68MX4eM019238@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59231 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751872Ab1GHWdn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Jul 2011 18:33:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, dagenaisj@sonatest.com, mm-commits@vger.kernel.org


The patch titled
     w1-ds1wm-add-a-reset-recovery-parameter-checkpatch-fixes
has been removed from the -mm tree.  Its filename was
     w1-ds1wm-add-a-reset-recovery-parameter-checkpatch-fixes.patch

This patch was dropped because it was folded into w1-ds1wm-add-a-reset-=
recovery-parameter.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: w1-ds1wm-add-a-reset-recovery-parameter-checkpatch-fixes
=46rom: Andrew Morton <akpm@linux-foundation.org>

ERROR: Invalid UTF-8, patch and commit message should be encoded in UTF=
-8
#1:=20
               ^

ERROR: Invalid UTF-8, patch and commit message should be encoded in UTF=
-8
#33:=20
Signed-off-by: Jean-Fran=E7ois Dagenais <dagenaisj@sonatest.com>
                        ^

ERROR: space required before the open parenthesis '('
#81: FILE: drivers/w1/masters/ds1wm.c:191:
+	if(ds1wm_data->reset_recover_delay)

total: 3 errors, 0 warnings, 48 lines checked

=2E/patches/w1-ds1wm-add-a-reset-recovery-parameter.patch has style pro=
blems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Jean-Fran=E7ois Dagenais <dagenaisj@sonatest.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/w1/masters/ds1wm.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/w1/masters/ds1wm.c~w1-ds1wm-add-a-reset-recovery-para=
meter-checkpatch-fixes drivers/w1/masters/ds1wm.c
--- a/drivers/w1/masters/ds1wm.c~w1-ds1wm-add-a-reset-recovery-paramete=
r-checkpatch-fixes
+++ a/drivers/w1/masters/ds1wm.c
@@ -188,7 +188,7 @@ static int ds1wm_reset(struct ds1wm_data
 		return 1;
 	}
=20
-	if(ds1wm_data->reset_recover_delay)
+	if (ds1wm_data->reset_recover_delay)
 		msleep(ds1wm_data->reset_recover_delay);
=20
 	return 0;
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
headers_check-is-broken.patch
samples-hidraw-is-busted.patch
memcg-fix-reclaimable-lru-check-in-memcg.patch
memcg-fix-numa-scan-information-update-to-be-triggered-by-memory-event.=
patch
w1-ds1wm-add-a-reset-recovery-parameter.patch
xtensa-prevent-arbitrary-read-in-ptrace-fix.patch
mm-preallocate-page-before-lock_page-at-filemap-cow.patch
linux-next.patch
linux-next-git-rejects.patch
i-need-old-gcc.patch
arch-alpha-kernel-systblss-remove-debug-check.patch
cris-fix-a-build-error-in-kernel-forkc-checkpatch-fixes.patch
kernel-timec-change-jiffies_to_clock_t-input-parameters-type-to-unsigne=
d-long-fix.patch
arch-x86-platform-iris-irisc-register-a-platform-device-and-a-platform-=
driver-fix.patch
arch-x86-include-asm-delayh-fix-udelay-and-ndelay-for-8-bit-args.patch
drivers-net-skgec-support-dlink-dge-530t-rev-c1.patch
drivers-video-backlight-aat2870_blc-make-it-buildable-as-a-module.patch
pci-enumerate-the-pci-device-only-removed-out-pci-hierarchy-of-os-when-=
re-scanning-pci-fix.patch
drivers-staging-speakup-devsynthc-fix-buffer-size-is-not-provably-corre=
ct-error.patch
drivers-staging-gma500-psb_intel_displayc-fix-build.patch
drivers-staging-dt3155v4l-dt3155v4lc-needs-slabh.patch
drivers-staging-solo6x10-corec-needs-slabh.patch
drivers-staging-solo6x10-p2mc-needs-slabh.patch
staging-more-missing-slabh-inclusions.patch
slab-use-numa_no_node.patch
mm.patch
mm-extend-memory-hotplug-api-to-allow-memory-hotplug-in-virtual-machine=
s-fix.patch
pagewalk-add-locking-rule-comments-fix.patch
mm-memoryc-remove-zap_block_size.patch
mm-memblockc-avoid-abuse-of-red_inactive.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
hpet-factor-timer-allocate-from-open.patch
drivers-misc-add-support-the-fsa9480-usb-switch-fix.patch
leds-route-kbd-leds-through-the-generic-leds-layer.patch
checkpatch-suggest-using-min_t-or-max_t-v2.patch
checkpatch-add-a-prefer-__aligned-check.patch
lib-hexdumpc-make-hex2bin-return-the-updated-src-address.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix.patch
fs-binfmt_miscc-use-kernels-hex_to_bin-method-fix-fix.patch
init-skip-calibration-delay-if-previously-done-fix.patch
init-skip-calibration-delay-if-previously-done-fix-fix.patch
init-skip-calibration-delay-if-previously-done-4.patch
drivers-rtc-add-support-for-qualcomm-pmic8xxx-rtc-fix.patch
memcg-consolidates-memory-cgroup-lru-stat-functions-fix.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-fix-2.patch
cpusets-randomize-node-rotor-used-in-cpuset_mem_spread_node-cpusets-ini=
tialize-spread-rotor-lazily-fix.patch
h8300-m68k-xtensa-__fd_isset-should-return-0-1.patch
proc-pid-fdinfo-add-cloexec-information-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-fix-2.patch
ipc-introduce-shm_rmid_forced-sysctl-cleanup.patch
ipc-introduce-shm_rmid_forced-sysctl-comments-fix.patch
ipc-introduce-shm_rmid_forced-sysctl-testing.patch
scatterlist-new-helper-functions.patch
scatterlist-new-helper-functions-update-fix.patch
kexec-remove-kmsg_dump_kexec.patch
ramoops-use-module-parameters-instead-of-platform-data-if-not-available=
-checkpatch-fixes.patch
journal_add_journal_head-debug.patch
mutex-subsystem-synchro-test-module-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
memblock-add-input-size-checking-to-memblock_find_region.patch
memblock-add-input-size-checking-to-memblock_find_region-fix.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
