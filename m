From: akpm@linux-foundation.org
Subject: + kmod-add-init-function-to-usermodehelper-fix.patch added to -mm tree
Date: Wed, 03 Feb 2010 17:13:50 -0800
Message-ID: <201002040139.o141dK44032186@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:34167 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932991Ab0BDBju (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 3 Feb 2010 20:39:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, nhorman@tuxdriver.com, oleg@redhat.com


The patch titled
     kmod-add-init-function-to-usermodehelper-fix
has been added to the -mm tree.  Its filename is
     kmod-add-init-function-to-usermodehelper-fix.patch

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
Subject: kmod-add-init-function-to-usermodehelper-fix
From: Andrew Morton <akpm@linux-foundation.org>

x86_64 allnoconfig:

In file included from include/linux/module.h:13,
                 from include/linux/crypto.h:21,
                 from arch/x86/kernel/asm-offsets_64.c:8,
                 from arch/x86/kernel/asm-offsets.c:4:
include/linux/kmod.h:55: error: field 'work' has incomplete type

Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/kmod.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN include/linux/kmod.h~kmod-add-init-function-to-usermodehelper-fix include/linux/kmod.h
--- a/include/linux/kmod.h~kmod-add-init-function-to-usermodehelper-fix
+++ a/include/linux/kmod.h
@@ -23,6 +23,7 @@
 #include <linux/stddef.h>
 #include <linux/errno.h>
 #include <linux/compiler.h>
+#include <linux/workqueue.h>
 
 #define KMOD_PATH_LEN 256
 
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
linux-next.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
pci-update-pci_set_vga_state-to-call-arch-functions.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-present.patch
drivers-gpu-drm-radeon-radeon_combiosc-fix-warning.patch
radio-add-the-saa7706h-car-radio-dsp-to-v4l2-chip-identh.patch
drivers-media-video-cx18-cx18-alsa-pcmc-fix-printk-warning.patch
drivers-media-dvb-frontends-stv090xc-fix-use-uninitialised.patch
drivers-media-dvb-frontends-stv090xc-fix-use-uninitlalised.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
ibmphp-read-the-length-of-ebda-and-map-entire-ebda-region-fix.patch
kernel-schedc-suppress-unused-var-warning.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patch
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issue-fix.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
resources-introduce-generic-page_is_ram-fix.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on-a-target-command-checkpatch-fixes.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

