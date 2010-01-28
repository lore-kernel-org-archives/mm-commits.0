From: akpm@linux-foundation.org
Subject: + zlib-make-new-optimized-inflate-endian-independent-checkpatch-fixes.patch added to -mm tree
Date: Wed, 27 Jan 2010 17:06:38 -0800
Message-ID: <201001280106.o0S16cVt011307@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:55791 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755621Ab0A1BGs (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 27 Jan 2010 20:06:48 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, Joakim.Tjernlund@transmode.se, benh@kernel.crashing.org, joakim.tjernlund@transmode.se


The patch titled
     zlib-make-new-optimized-inflate-endian-independent-checkpatch-fixes
has been added to the -mm tree.  Its filename is
     zlib-make-new-optimized-inflate-endian-independent-checkpatch-fixes.patch

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
Subject: zlib-make-new-optimized-inflate-endian-independent-checkpatch-fixes
From: Andrew Morton <akpm@linux-foundation.org>

ERROR: exactly one space required after that #ifdef
#87: FILE: lib/zlib_inflate/inffast.c:278:
+#ifdef  CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS

total: 1 errors, 0 warnings, 113 lines checked

./patches/zlib-make-new-optimized-inflate-endian-independent.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Joakim Tjernlund <Joakim.Tjernlund@transmode.se>
Cc: Joakim Tjernlund <joakim.tjernlund@transmode.se>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 lib/zlib_inflate/inffast.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN lib/zlib_inflate/inffast.c~zlib-make-new-optimized-inflate-endian-independent-checkpatch-fixes lib/zlib_inflate/inffast.c
--- a/lib/zlib_inflate/inffast.c~zlib-make-new-optimized-inflate-endian-independent-checkpatch-fixes
+++ a/lib/zlib_inflate/inffast.c
@@ -275,7 +275,7 @@ void inflate_fast(z_streamp strm, unsign
 			sfrom = (unsigned short *)(from - OFF);
 			loops = len >> 1;
 			do
-#ifdef  CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
+#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
 			    PUP(sout) = PUP(sfrom);
 #else
 			    PUP(sout) = UP_UNALIGNED(sfrom);
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
zlib-make-new-optimized-inflate-endian-independent-checkpatch-fixes.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
pci-update-pci_set_vga_state-to-call-arch-functions-fix.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present-checkpatch-fixes.patch
cpufreq-ondemand-independent-max-speed-for-nice-threads-with-nice_max_freq-fix.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
drivers-media-video-pmsc-needs-versionh.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
mm-add-lowmem-detection-logic-fix.patch
mm-count-lowmem-rss-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
resources-introduce-generic-page_is_ram-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-remove-simple_prepare_write-usage-checkpatch-fixes.patch
fs-reiser4-contextc-current_is_pdflush-got-removed.patch
reiser4-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

