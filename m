From: akpm@linux-foundation.org
Subject: + drop-an-empty-isicomh-from-being-exported-to-user-space.patch added to -mm tree
Date: Mon, 04 Jun 2007 18:09:01 -0700
Message-ID: <200706050109.l5518xUR026662@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp2.linux-foundation.org ([207.189.120.14]:45111 "EHLO
	smtp2.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754866AbXFEBJI (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 4 Jun 2007 21:09:08 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: rpjday@mindspring.com, jirislaby@gmail.com


The patch titled
     Drop an empty isicom.h from being exported to user space.
has been added to the -mm tree.  Its filename is
     drop-an-empty-isicomh-from-being-exported-to-user-space.patch

*** Remember to use Documentation/SubmitChecklist when testing your code ***

See http://www.zip.com.au/~akpm/linux/patches/stuff/added-to-mm.txt to find
out what to do about this

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
@@ -246,7 +246,6 @@ unifdef-y += isdn.h
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
ppc-remove-dead-code-for-preventing-pread-and-pwrite-calls.patch
viotape-use-designated-initializers-for-fops-member.patch
git-ieee1394.patch
input-delete-useless-reference-to-dead-module_parm-macro.patch
git-kbuild.patch
git-kvm.patch
bluetooth-remove-the-redundant-non-seekable-llseek-method.patch
pcmcia-delete-obsolete-pcmcia_ioctl-feature.patch
git-s390.patch
git-scsi-misc.patch
remove-dead-references-to-module_parm-macro.patch
git-watchdog.patch
remove-the-deprecated-kmem_cache_t-typedef-from-slabh.patch
cris-replace-old-style-member-inits-with-designated-inits.patch
remove-unnecessary-includes-of-spinlockh-under-include-linux.patch
drop-an-empty-isicomh-from-being-exported-to-user-space.patch
