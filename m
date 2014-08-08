From: akpm@linux-foundation.org
Subject: [folded-merged] proc-remove-proc_tty_ldisc-variable-fix.patch
 removed from -mm tree
Date: Fri, 08 Aug 2014 13:57:46 -0700
Message-ID: <53e539ca.0xlG0c7IjKdTYCQv%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f74.google.com ([209.85.220.74]:46336 "EHLO
	mail-pa0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932766AbaHHU5r (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 8 Aug 2014 16:57:47 -0400
Received: by mail-pa0-f74.google.com with SMTP id lj1so1561116pab.5
        for <mm-commits@vger.kernel.org>; Fri, 08 Aug 2014 13:57:47 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, adobriyan@gmail.com, viro@zeniv.linux.org.uk, mm-commits@vger.kernel.org


The patch titled
     Subject: proc-remove-proc_tty_ldisc-variable-fix
has been removed from the -mm tree.  Its filename was
     proc-remove-proc_tty_ldisc-variable-fix.patch

This patch was dropped because it was folded into proc-remove-proc_tty_ldisc-variable.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: proc-remove-proc_tty_ldisc-variable-fix

add comment

Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Alexey Dobriyan <adobriyan@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 fs/proc/proc_tty.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN fs/proc/proc_tty.c~proc-remove-proc_tty_ldisc-variable-fix fs/proc/proc_tty.c
--- a/fs/proc/proc_tty.c~proc-remove-proc_tty_ldisc-variable-fix
+++ a/fs/proc/proc_tty.c
@@ -176,7 +176,7 @@ void __init proc_tty_init(void)
 {
 	if (!proc_mkdir("tty", NULL))
 		return;
-	proc_mkdir("tty/ldisc", NULL);
+	proc_mkdir("tty/ldisc", NULL);	/* Preserved: it's userspace visible */
 	/*
 	 * /proc/tty/driver/serial reveals the exact character counts for
 	 * serial links which is just too easy to abuse for inferring
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
rtc-add-pcf85063-support.patch
proc-remove-proc_tty_ldisc-variable.patch
mmap_vmcore-skip-non-ram-pages-reported-by-hypervisors-v4-fix-fix.patch
panic-add-taint_softlockup-fix.patch
kexec-implementation-of-new-syscall-kexec_file_load-checkpatch-fixes.patch
kexec-support-kexec-kdump-on-efi-systems-fix.patch

