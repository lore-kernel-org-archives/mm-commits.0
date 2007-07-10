From: akpm@linux-foundation.org
Subject: - input-delete-useless-reference-to-dead-module_parm-macro.patch removed from -mm tree
Date: Mon, 09 Jul 2007 22:05:46 -0700
Message-ID: <200707100505.l6A55lKn006853@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:40082 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751189AbXGJFG3 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 01:06:29 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, dtor@mail.ru, mm-commits@vger.kernel.org


The patch titled
     input: delete useless reference to dead MODULE_PARM macro
has been removed from the -mm tree.  Its filename was
     input-delete-useless-reference-to-dead-module_parm-macro.patch

This patch was dropped because it was nacked

------------------------------------------------------
Subject: input: delete useless reference to dead MODULE_PARM macro
From: "Robert P. J. Day" <rpjday@mindspring.com>

Remove a clearly useless reference to the obsolete MODULE_PARM macro.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Cc: Dmitry Torokhov <dtor@mail.ru>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/input/mouse/atarimouse.c |    3 ---
 1 files changed, 3 deletions(-)

diff -puN drivers/input/mouse/atarimouse.c~input-delete-useless-reference-to-dead-module_parm-macro drivers/input/mouse/atarimouse.c
--- a/drivers/input/mouse/atarimouse.c~input-delete-useless-reference-to-dead-module_parm-macro
+++ a/drivers/input/mouse/atarimouse.c
@@ -59,9 +59,6 @@ MODULE_LICENSE("GPL");
 
 static int mouse_threshold[2] = {2,2};
 
-#ifdef __MODULE__
-MODULE_PARM(mouse_threshold, "2i");
-#endif
 #ifdef FIXED_ATARI_JOYSTICK
 extern int atari_mouse_buttons;
 #endif
_

Patches currently in -mm which might be from rpjday@mindspring.com are

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
