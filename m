From: akpm@linux-foundation.org
Subject: - viotape-use-designated-initializers-for-fops-member.patch removed from -mm tree
Date: Tue, 10 Jul 2007 12:48:40 -0700
Message-ID: <200707101948.l6AJmerD026020@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:58908 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758379AbXGJTsy (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 10 Jul 2007 15:48:54 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, sfr@canb.auug.org.au, mm-commits@vger.kernel.org


The patch titled
     VIOTAPE: use designated initializers for fops member structures
has been removed from the -mm tree.  Its filename was
     viotape-use-designated-initializers-for-fops-member.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: VIOTAPE: use designated initializers for fops member structures
From: "Robert P. J. Day" <rpjday@mindspring.com>

Replace the old-style member initializers with the newer designated
initializers.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Stephen Rothwell <sfr@canb.auug.org.au>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/char/viotape.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff -puN drivers/char/viotape.c~viotape-use-designated-initializers-for-fops-member drivers/char/viotape.c
--- a/drivers/char/viotape.c~viotape-use-designated-initializers-for-fops-member
+++ a/drivers/char/viotape.c
@@ -873,12 +873,12 @@ free_op:
 }
 
 const struct file_operations viotap_fops = {
-	owner: THIS_MODULE,
-	read: viotap_read,
-	write: viotap_write,
-	ioctl: viotap_ioctl,
-	open: viotap_open,
-	release: viotap_release,
+	.owner =	THIS_MODULE,
+	.read =		viotap_read,
+	.write =	viotap_write,
+	.ioctl =	viotap_ioctl,
+	.open =		viotap_open,
+	.release =	viotap_release,
 };
 
 /* Handle interrupt events for tape */
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-gfs2-nmw.patch
git-input.patch
git-kbuild.patch
git-kvm.patch
git-net.patch
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
