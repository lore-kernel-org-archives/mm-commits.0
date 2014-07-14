From: akpm@linux-foundation.org
Subject: + update-roland-mcgraths-mail.patch added to -mm tree
Date: Mon, 14 Jul 2014 13:21:48 -0700
Message-ID: <53c43bdc.WiUAJYuhyddKSAlI%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-pa0-f73.google.com ([209.85.220.73]:50874 "EHLO
	mail-pa0-f73.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757367AbaGNUVt (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 14 Jul 2014 16:21:49 -0400
Received: by mail-pa0-f73.google.com with SMTP id kx10so810593pab.4
        for <mm-commits@vger.kernel.org>; Mon, 14 Jul 2014 13:21:48 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: richard@nod.at, roland@hack.frob.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Update Roland McGrath's mail
has been added to the -mm tree.  Its filename is
     update-roland-mcgraths-mail.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/update-roland-mcgraths-mail.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/update-roland-mcgraths-mail.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Richard Weinberger <richard@nod.at>
Subject: Update Roland McGrath's mail

roland@redhat.com bounces, change it to roland@hack.frob.com.

Signed-off-by: Richard Weinberger <richard@nod.at>
Cc: Roland McGrath <roland@hack.frob.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 MAINTAINERS |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN MAINTAINERS~update-roland-mcgraths-mail MAINTAINERS
--- a/MAINTAINERS~update-roland-mcgraths-mail
+++ a/MAINTAINERS
@@ -7160,7 +7160,7 @@ F:	drivers/ptp/*
 F:	include/linux/ptp_cl*
 
 PTRACE SUPPORT
-M:	Roland McGrath <roland@redhat.com>
+M:	Roland McGrath <roland@hack.frob.com>
 M:	Oleg Nesterov <oleg@redhat.com>
 S:	Maintained
 F:	include/asm-generic/syscall.h
_

Patches currently in -mm which might be from richard@nod.at are

update-roland-mcgraths-mail.patch
remove-cpu_subtype_sh7764.patch
lib-scatterlist-make-arch_has_sg_chain-an-actual-kconfig-fix-2.patch
scripts-checkstackpl-automatically-handle-32-bit-and-64-bit-mode-for-arch=x86.patch
linux-next.patch

