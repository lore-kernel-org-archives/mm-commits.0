From: akpm@linux-foundation.org
Subject: - sound-remove-unreferenced-header-file-include-sound-wavefront_fxh.patch removed from -mm tree
Date: Sun, 08 Jul 2007 01:11:44 -0700
Message-ID: <200707080811.l688Bie7014791@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58834 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753102AbXGHILw (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Sun, 8 Jul 2007 04:11:52 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, mm-commits@vger.kernel.org


The patch titled
     SOUND: eemove unreferenced header file include/sound/wavefront_fx.h.
has been removed from the -mm tree.  Its filename was
     sound-remove-unreferenced-header-file-include-sound-wavefront_fxh.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: SOUND: eemove unreferenced header file include/sound/wavefront_fx.h.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/sound/wavefront_fx.h |    9 ---------
 1 files changed, 9 deletions(-)

diff -puN include/sound/wavefront_fx.h~sound-remove-unreferenced-header-file-include-sound-wavefront_fxh /dev/null
--- a/include/sound/wavefront_fx.h
+++ /dev/null
@@ -1,9 +0,0 @@
-#ifndef __SOUND_WAVEFRONT_FX_H
-#define __SOUND_WAVEFRONT_FX_H
-
-extern int  snd_wavefront_fx_detect (snd_wavefront_t *);
-extern void snd_wavefront_fx_ioctl  (snd_synth_t *sdev, 
-				     unsigned int cmd, 
-				     unsigned long arg);
-
-#endif  __SOUND_WAVEFRONT_FX_H
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
viotape-use-designated-initializers-for-fops-member.patch
git-dvb.patch
git-gfs2-nmw.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
git-kvm.patch
rpc-remove-makefile-reference-to-obsolete-rxrpc-config.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
git-sh.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
usb-remove-makefile-reference-to-obsolete-ohci_at91.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
mm-make-needlessly-global-hugetlb_no_page-static.patch
frv-be-self-consistent-and-use-config_gdb_console-everywhere.patch
frv-remove-some-dead-code.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
remove-apparently-useless-commented-apm_get_battery_status.patch
cobalt-remove-all-references-to-cobalt-nvram.patch
remove-final-two-references-to-__obsolete_setup-macro.patch
cdrom-replace-hard-coded-constants-by-kernelh-macro.patch
nls-remove-obsolete-makefile-entries.patch
