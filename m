From: akpm@linux-foundation.org
Subject: + input-delete-useless-reference-to-dead-module_parm-macro.patch added to -mm tree
Date: Tue, 29 May 2007 16:11:56 -0700
Message-ID: <200705292311.l4TNBulZ014030@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([207.189.120.13]:38628 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751515AbXE2XMC (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Tue, 29 May 2007 19:12:02 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, dtor@mail.ru


The patch titled
     input: delete useless reference to dead MODULE_PARM macro
has been added to the -mm tree.  Its filename is
     input-delete-useless-reference-to-dead-module_parm-macro.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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

git-arm-master.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
scsi-fix-obvious-typo-spin_lock_irqrestore-in-gdthc.patch
remove-dead-references-to-module_parm-macro.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
