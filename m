From: akpm@linux-foundation.org
Subject: + kernelh-add-build_bug_on_not_power_of_2-fix.patch added to -mm tree
Date: Wed, 06 Jan 2010 15:08:25 -0800
Message-ID: <201001062308.o06N8Pbq023716@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57777 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932984Ab0AFXIr (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 6 Jan 2010 18:08:47 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, rolandd@cisco.com


The patch titled
     kernelh-add-build_bug_on_not_power_of_2-fix
has been added to the -mm tree.  Its filename is
     kernelh-add-build_bug_on_not_power_of_2-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: kernelh-add-build_bug_on_not_power_of_2-fix
From: Andrew Morton <akpm@linux-foundation.org>

Improve the comment

Cc: Roland Dreier <rolandd@cisco.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kernel.h |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN include/linux/kernel.h~kernelh-add-build_bug_on_not_power_of_2-fix include/linux/kernel.h
--- a/include/linux/kernel.h~kernelh-add-build_bug_on_not_power_of_2-fix
+++ a/include/linux/kernel.h
@@ -703,7 +703,7 @@ static inline void ftrace_dump(void) { }
 struct sysinfo;
 extern int do_sysinfo(struct sysinfo *info);
 
-/* Force a compilation error if expression is not a power of 2 */
+/* Force a compilation error if a constant expression is not a power of 2 */
 #define BUILD_BUG_ON_NOT_POWER_OF_2(n)			\
 	BUILD_BUG_ON(((n) != 0 && (((n) & ((n) - 1)) == 0)))
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

percpu-avoid-calling-__pcpu_ptr_to_addrnull.patch
linux-next.patch
linux-next-fixup.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
kernelh-add-build_bug_on_not_power_of_2-fix.patch
drivers-gpu-drm-i915-i915_dmac-fix-unused-var.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
3x59x-fix-pci-resource-management.patch
net-netfilter-ipvs-ip_vs_wrrc-use-lib-gcdc.patch
fs-improve-remountro-vs-buffercache-coherency.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
undeprecate-pci_find_device.patch
notify_change-callers-must-hold-i_mutex.patch

