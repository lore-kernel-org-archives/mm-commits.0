From: akpm@linux-foundation.org
Subject: [folded-merged] rtc-add-nxp-pcf2127-support-i2c-fix.patch removed from -mm tree
Date: Wed, 03 Jul 2013 14:41:16 -0700
Message-ID: <51d49a7c.jnjz3OOZf4LUE7hE%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:40264 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932128Ab3GCVlR (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Jul 2013 17:41:17 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, r.cerrato@til-technologies.fr, jg1.han@samsung.com, akpm@linux-foundation.org

Subject: [folded-merged] rtc-add-nxp-pcf2127-support-i2c-fix.patch removed from -mm tree
To: akpm@linux-foundation.org,jg1.han@samsung.com,r.cerrato@til-technologies.fr,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Wed, 03 Jul 2013 14:41:16 -0700


The patch titled
     Subject: rtc-add-nxp-pcf2127-support-i2c-fix
has been removed from the -mm tree.  Its filename was
     rtc-add-nxp-pcf2127-support-i2c-fix.patch

This patch was dropped because it was folded into rtc-add-nxp-pcf2127-support-i2c.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: rtc-add-nxp-pcf2127-support-i2c-fix

fix typo, fix warnings

Cc: Jingoo Han <jg1.han@samsung.com>
Cc: Renaud Cerrato <r.cerrato@til-technologies.fr>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/rtc/rtc-pcf2127.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff -puN drivers/rtc/rtc-pcf2127.c~rtc-add-nxp-pcf2127-support-i2c-fix drivers/rtc/rtc-pcf2127.c
--- a/drivers/rtc/rtc-pcf2127.c~rtc-add-nxp-pcf2127-support-i2c-fix
+++ a/drivers/rtc/rtc-pcf2127.c
@@ -37,7 +37,7 @@ static struct i2c_driver pcf2127_driver;
 
 struct pcf2127 {
 	struct rtc_device *rtc;
-	int voltage_low; /* incicates if a low_voltage was detected */
+	int voltage_low; /* indicates if a low_voltage was detected */
 };
 
 /*
@@ -99,7 +99,6 @@ static int pcf2127_get_datetime(struct i
 
 static int pcf2127_set_datetime(struct i2c_client *client, struct rtc_time *tm)
 {
-	struct pcf2127 *pcf2127 = i2c_get_clientdata(client);
 	unsigned char buf[8];
 	int i = 0, err;
 
@@ -141,7 +140,6 @@ static int pcf2127_rtc_ioctl(struct devi
 				unsigned int cmd, unsigned long arg)
 {
 	struct pcf2127 *pcf2127 = i2c_get_clientdata(to_i2c_client(dev));
-	struct rtc_time tm;
 
 	switch (cmd) {
 	case RTC_VL_READ:
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
include-linux-smph-on_each_cpu-switch-back-to-a-macro.patch
sound-soc-codecs-si476xc-dont-use-0bnnn.patch
ocfs2-xattr-remove-useless-free-space-checking.patch
ocfs2-rework-transaction-rollback-in-ocfs2_relink_block_group-fix.patch
ocfs2-fix-readonly-issue-in-ocfs2_unlink.patch
ocfs2-adjust-switch_case-syntax-at-o2net_state_change.patch
clear_refs-sanitize-accepted-commands-declaration.patch
mm-remove-compressed-copy-from-zram-in-memory.patch
memory_hotplug-use-pgdat_resize_lock-in-__offline_pages.patch
include-linux-mmh-add-page_aligned-helper.patch
vmcore-allocate-buffer-for-elf-headers-on-page-size-alignment.patch
vmalloc-introduce-remap_vmalloc_range_partial.patch
vmcore-allocate-elf-note-segment-in-the-2nd-kernel-vmalloc-memory.patch
vmcore-allow-user-process-to-remap-elf-note-segment-buffer.patch
vmcore-support-mmap-on-proc-vmcore.patch
mm-remove-lru-parameter-from-__lru_cache_add-and-lru_cache_add_lru.patch
mm-tune-vm_committed_as-percpu_counter-batching-size.patch
swap-discard-while-swapping-only-if-swap_flag_discard_pages.patch
mm-use-a-dedicated-lock-to-protect-totalram_pages-and-zone-managed_pages.patch
mm-correctly-update-zone-managed_pages.patch
clean-up-scary-strncpydst-src-strlensrc-uses.patch
dump_stack-serialize-the-output-from-dump_stack.patch
checkpatch-warn-when-using-gccs-binary-constant-extension.patch
rtc-add-nxp-pcf2127-support-i2c.patch
ptrace-add-ability-to-get-set-signal-blocked-mask-fix.patch
dev-oldmem-remove-the-interface-fix.patch
idr-print-a-stack-dump-after-ida_remove-warning-fix.patch
documentation-accounting-getdelaysc-avoid-strncpy-in-accounting-tool-fix.patch
drivers-w1-slaves-w1_ds2408c-add-magic-sequence-to-disable-p0-test-mode-fix.patch
tools-testing-selftests-dont-assume-the-x-bit-is-set-on-scripts.patch

