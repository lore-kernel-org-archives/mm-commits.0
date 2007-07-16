From: akpm@linux-foundation.org
Subject: - drop-an-empty-isicomh-from-being-exported-to-user-space.patch removed from -mm tree
Date: Mon, 16 Jul 2007 13:55:57 -0700
Message-ID: <200707162055.l6GKtvrq001981@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:59809 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756658AbXGPVNj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Mon, 16 Jul 2007 17:13:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: rpjday@mindspring.com, jirislaby@gmail.com, mm-commits@vger.kernel.org


The patch titled
     Drop an empty isicom.h from being exported to user space.
has been removed from the -mm tree.  Its filename was
     drop-an-empty-isicomh-from-being-exported-to-user-space.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
Subject: Drop an empty isicom.h from being exported to user space.
From: "Robert P. J. Day" <rpjday@mindspring.com>

Drop <linux/isicom.h> from being exported to user space since it would
be only an empty file.

Signed-off-by: Robert P. J. Day <rpjday@mindspring.com>
Acked-by: Jiri Slaby <jirislaby@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/Kbuild |    1 -
 1 file changed, 1 deletion(-)

diff -puN include/linux/Kbuild~drop-an-empty-isicomh-from-being-exported-to-user-space include/linux/Kbuild
--- a/include/linux/Kbuild~drop-an-empty-isicomh-from-being-exported-to-user-space
+++ a/include/linux/Kbuild
@@ -247,7 +247,6 @@ unifdef-y += isdn.h
 unifdef-y += isdnif.h
 unifdef-y += isdn_divertif.h
 unifdef-y += isdn_ppp.h
-unifdef-y += isicom.h
 unifdef-y += jbd.h
 unifdef-y += joystick.h
 unifdef-y += kdev_t.h
_

Patches currently in -mm which might be from rpjday@mindspring.com are

origin.patch
git-alsa.patch
git-powerpc.patch
git-dvb.patch
git-kbuild.patch
git-kvm.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
i386-uaccessh-replace-hard-coded-constant-with-appropriate-macro-from-kernelh.patch
i386-ioapic-remove-old-irq-balancing-debug-cruft.patch
i386-deactivate-the-test-for-the-dead-config_debug_page_type.patch
mm-make-needlessly-global-hugetlb_no_page-static.patch
