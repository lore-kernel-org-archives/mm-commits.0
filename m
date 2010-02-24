From: akpm@linux-foundation.org
Subject: + mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation-checkpatch-fixes.patch added to -mm tree
Date: Wed, 24 Feb 2010 14:03:26 -0800
Message-ID: <201002242203.o1OM3Qsw023044@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:59829 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758300Ab0BXWEQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Wed, 24 Feb 2010 17:04:16 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: akpm@linux-foundation.org, andre.goddard@gmail.com


The patch titled
     mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation-ch=
eckpatch-fixes
has been added to the -mm tree.  Its filename is
     mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation-ch=
eckpatch-fixes.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your cod=
e ***

See http://userweb.kernel.org/~akpm/stuff/added-to-mm.txt to find
out what to do about this

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mm=
otm/

------------------------------------------------------
Subject: mqueue-apply-mathematics-distributivity-on-mq_bytes-calculatio=
n-checkpatch-fixes
=46rom: Andrew Morton <akpm@linux-foundation.org>

ERROR: Invalid UTF-8, patch and commit message should be encoded in UTF=
-8
#1:=20
          ^

ERROR: Invalid UTF-8, patch and commit message should be encoded in UTF=
-8
#8:=20
Signed-off-by: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
                   ^

WARNING: space prohibited between function name and open parenthesis '(=
'
#41: FILE: ipc/mqueue.c:606:
+	    + sizeof (struct msg_msg *))) <

total: 2 errors, 1 warnings, 21 lines checked

=2E/patches/mqueue-apply-mathematics-distributivity-on-mq_bytes-calcula=
tion.patch has style problems, please review.  If any of these errors
are false positives report them to the maintainer, see
CHECKPATCH in MAINTAINERS.

Please run checkpatch prior to sending patches

Cc: Andr=E9 Goddard Rosa <andre.goddard@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 ipc/mqueue.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN ipc/mqueue.c~mqueue-apply-mathematics-distributivity-on-mq_by=
tes-calculation-checkpatch-fixes ipc/mqueue.c
--- a/ipc/mqueue.c~mqueue-apply-mathematics-distributivity-on-mq_bytes-=
calculation-checkpatch-fixes
+++ a/ipc/mqueue.c
@@ -603,7 +603,7 @@ static int mq_attr_ok(struct ipc_namespa
 	if (attr->mq_msgsize > ULONG_MAX/attr->mq_maxmsg)
 		return 0;
 	if ((unsigned long)(attr->mq_maxmsg * (attr->mq_msgsize
-	    + sizeof (struct msg_msg *))) <
+	    + sizeof(struct msg_msg *))) <
 	    (unsigned long)(attr->mq_maxmsg * attr->mq_msgsize))
 		return 0;
 	return 1;
_

Patches currently in -mm which might be from akpm@linux-foundation.org =
are

origin.patch
linux-next.patch
linux-next-git-rejects.patch
next-remove-localversion.patch
i-need-old-gcc.patch
revert-input-wistron_btns-switch-to-using-sparse-keymap-library.patch
drivers-media-video-cx23885-needs-kfifo-conversion.patch
bitops-rename-for_each_bit-to-for_each_set_bit.patch
bitops-rename-for_each_bit-to-for_each_set_bit-fix-fix-2.patch
arch-arm-include-asm-elfh-forward-declare-the-task-struct.patch
cpufreq-ondemand-dont-synchronize-sample-rate-unless-mulitple-cpus-pres=
ent.patch
fs-fscache-object-listc-fix-warning-on-32-bit.patch
timer-stats-fix-del_timer_sync-and-try_to_del_timer_sync.patch
mqueue-apply-mathematics-distributivity-on-mq_bytes-calculation-checkpa=
tch-fixes.patch
jffs2-avoid-using-c-keyword-new-in-userspace-visible-header.patch
3x59x-fix-pci-resource-management.patch
kernel-schedc-suppress-unused-var-warning.patch
usb-serial-ftdi-add-contec-vendor-and-product-id-fix.patch
mm-avoid-false-sharing-of-mm_counter-checkpatch-fixes.patch
mm-count-swap-usage-checkpatch-fixes.patch
vmscan-check-high-watermark-after-shrink-zone-fix.patch
mm-remove-function-free_hot_page-fix.patch
mm-restore-zone-all_unreclaimable-to-independence-word-fix.patch
memory-hotplug-create-sys-firmware-memmap-entry-for-new-memory-fix.patc=
h
include-linux-fsh-convert-fmode_-constants-to-hex.patch
mm-change-anon_vma-linking-to-fix-multi-process-server-scalability-issu=
e-fix.patch
mm-pm-force-gfp_noio-during-suspend-hibernation-and-resume.patch
frv-duplicate-output_buffer-of-e03-checkpatch-fixes.patch
uml-linec-avoid-null-pointer-dereference-simplify.patch
add-generic-sys_ipc-wrapper-fix.patch
lib-more-scalable-list_sort-fix.patch
fs-compat_ioctlc-suppress-two-warnings.patch
sdio-introduce-api-for-special-power-management-features-fix.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-checkpatch-fixes.patch
hwmon-driver-for-ti-tmp102-temperature-sensor-fix.patch
mm-pass-mm-flags-as-a-coredump-parameter-for-consistency-fix.patch
add-a-new-vt-mode-which-is-like-vt_process-but-doesnt-require-a-vt_reld=
isp-ioctl-call-checkpatch-fixes.patch
gpio-pca953xc-add-interrupt-handling-capability.patch
gpio-pca953xc-add-interrupt-handling-capability-fix.patch
of-gpio-implement-gpiolib-notifier-hooks-fix.patch
broadsheetfb-support-storing-waveform-fix.patch
drivers-char-memc-cleanups.patch
drivers-char-memc-cleanups-fix.patch
drivers-char-memc-cleanups-fix-fix.patch
memcg-move-charges-of-anonymous-page-cleanup.patch
memcg-implement-memory-thresholds-checkpatch-fixes.patch
sysctl-clean-up-vm-related-variable-declarations-fix.patch
kmod-add-init-function-to-usermodehelper-fix.patch
delay-accounting-re-implement-c-for-getdelaysc-to-report-information-on=
-a-target-command-checkpatch-fixes.patch
mn10300-remove-the-obsolete-and-unnecessary-dma-api-comments-fix.patch
reiser4-export-remove_from_page_cache-fix.patch
reiser4.patch
reiser4-writeback_inodes-implementation-fix.patch
slab-leaks3-default-y.patch
put_bh-debug.patch
getblk-handle-2tb-devices.patch
getblk-handle-2tb-devices-fix.patch
notify_change-callers-must-hold-i_mutex.patch

--
To unsubscribe from this list: send the line "unsubscribe mm-commits" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
