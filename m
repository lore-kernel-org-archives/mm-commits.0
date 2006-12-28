From: akpm@osdl.org
Subject: + add-gitignore-file-for-relocs-in-arch-i386-fix.patch added to -mm tree
Date: Thu, 28 Dec 2006 15:21:31 -0800
Message-ID: <200612282321.kBSNLVuJ015964@shell0.pdx.osdl.net>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.25]:40991 "EHLO smtp.osdl.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753846AbWL1XVu (ORCPT <rfc822;mm-commits@vger.kernel.org>);
	Thu, 28 Dec 2006 18:21:50 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jirislaby@gmail.com, thomas@m3y3r.de


The patch titled
     Arch: add gitignore file for relocs in arch i386 fix
has been added to the -mm tree.  Its filename is
     add-gitignore-file-for-relocs-in-arch-i386-fix.patch

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

------------------------------------------------------
Subject: Arch: add gitignore file for relocs in arch i386 fix
From: Jiri Slaby <jirislaby@gmail.com>

add gitignore file for relocs in arch i386 fix

The .gitigonre was intended to be in arch/ subtree.

Signed-off-by: Jiri Slaby <jirislaby@gmail.com>
Cc: Thomas Meyer <thomas@m3y3r.de>
Signed-off-by: Andrew Morton <akpm@osdl.org>
---

 arch/i386/boot/compressed/.gitignore |    1 +
 i386/boot/compressed/.gitignore      |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

diff -puN /dev/null arch/i386/boot/compressed/.gitignore
--- /dev/null
+++ a/arch/i386/boot/compressed/.gitignore
@@ -0,0 +1 @@
+relocs
diff -puN i386/boot/compressed/.gitignore~add-gitignore-file-for-relocs-in-arch-i386-fix /dev/null
--- a/i386/boot/compressed/.gitignore
+++ /dev/null
@@ -1 +0,0 @@
-relocs
_

Patches currently in -mm which might be from jirislaby@gmail.com are

add-gitignore-file-for-relocs-in-arch-i386-fix.patch
char-mxser-fix-oops-when-removing-opened.patch
char-isicom-eliminate-spinlock-recursion.patch
git-input.patch
char-tty-delete-wake_up_interruptible-after-tty_wakeup.patch
char-isicom-remove-tty_hangwakeup-bottomhalves.patch
mxser-remove-ambiguous-redefinition-of-init_work.patch
make-drivers-char-mxser_newcmxser_hangup-static.patch
char-isicom-fix-locking-in-isr.patch
char-isicom-augment-card_reset.patch
char-isicom-check-card-state-in-isr.patch
char-isicom-support-higher-rates.patch
char-isicom-correct-probing-removing.patch
char-tty_wakeup-cleanup.patch
char-mxser_new-mark-init-functions.patch
char-mxser_new-remove-useless-spinlock.patch
char-serial167-cleanup.patch
char-n_r3964-cleanup.patch
shrink_slab-handle-bad-shrinkers.patch

