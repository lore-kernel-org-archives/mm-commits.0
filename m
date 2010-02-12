From: akpm@linux-foundation.org
Subject: [merged] compat_ioctl-add-compat-handler-for-tiocgsid-ioctl.patch removed from -mm tree
Date: Fri, 12 Feb 2010 11:03:20 -0800
Message-ID: <201002121903.o1CJ3KIX021115@imap1.linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:41646 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757244Ab0BLTES (ORCPT
	<rfc822;mm-commits@vger.kernel.org>);
	Fri, 12 Feb 2010 14:04:18 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: schwab@linux-m68k.org, alan@lxorguk.ukuu.org.uk, arnd@arndb.de, mm-commits@vger.kernel.org


The patch titled
     compat_ioctl: add compat handler for TIOCGSID ioctl
has been removed from the -mm tree.  Its filename was
     compat_ioctl-add-compat-handler-for-tiocgsid-ioctl.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
Subject: compat_ioctl: add compat handler for TIOCGSID ioctl
From: Andreas Schwab <schwab@linux-m68k.org>

This is used by tcgetsid(3).

Signed-off-by: Andreas Schwab <schwab@linux-m68k.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/compat_ioctl.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN fs/compat_ioctl.c~compat_ioctl-add-compat-handler-for-tiocgsid-ioctl fs/compat_ioctl.c
--- a/fs/compat_ioctl.c~compat_ioctl-add-compat-handler-for-tiocgsid-ioctl
+++ a/fs/compat_ioctl.c
@@ -936,6 +936,7 @@ COMPATIBLE_IOCTL(TCSETSF)
 COMPATIBLE_IOCTL(TIOCLINUX)
 COMPATIBLE_IOCTL(TIOCSBRK)
 COMPATIBLE_IOCTL(TIOCCBRK)
+COMPATIBLE_IOCTL(TIOCGSID)
 COMPATIBLE_IOCTL(TIOCGICOUNT)
 /* Little t */
 COMPATIBLE_IOCTL(TIOCGETD)
_

Patches currently in -mm which might be from schwab@linux-m68k.org are

origin.patch
vfs-o_-bit-numbers-uniqueness-check.patch
add-generic-sys_old_select.patch
add-generic-sys_old_select-fix.patch
add-generic-sys_old_mmap.patch
add-generic-sys_ipc-wrapper.patch
add-generic-sys_ipc-wrapper-fix.patch
improve-sys_personality-for-compat-architectures.patch
improve-sys_newuname-for-compat-architectures.patch
add-generic-sys_olduname.patch

