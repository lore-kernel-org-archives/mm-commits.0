From: akpm@linux-foundation.org
Subject: +
 init-mainc-remove-unused-declaractions-of-mca_init-and-sbus_init.patch
 added to -mm tree
Date: Fri, 24 Jan 2014 12:32:27 -0800
Message-ID: <52e2cddb.WXZTvMUJXH3DBJER%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:44756 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751686AbaAXUc1 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Jan 2014 15:32:27 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hukangustc@gmail.com

Subject: + init-mainc-remove-unused-declaractions-of-mca_init-and-sbus_init.patch added to -mm tree
To: hukangustc@gmail.com
From: akpm@linux-foundation.org
Date: Fri, 24 Jan 2014 12:32:27 -0800


The patch titled
     Subject: init/main.c: remove unused declaractions of mca_init() and sbus_init()
has been added to the -mm tree.  Its filename is
     init-mainc-remove-unused-declaractions-of-mca_init-and-sbus_init.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/init-mainc-remove-unused-declaractions-of-mca_init-and-sbus_init.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/init-mainc-remove-unused-declaractions-of-mca_init-and-sbus_init.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Kang Hu <hukangustc@gmail.com>
Subject: init/main.c: remove unused declaractions of mca_init() and sbus_init()

mca_init() no longer exists.
sbus_init() is defined in arch/sparc/kernel/sbus.c and is a subsys_initcall.
both are not needed in main.c any more.

Signed-off-by: Kang Hu <hukangustc@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/main.c |    2 --
 1 file changed, 2 deletions(-)

diff -puN init/main.c~init-mainc-remove-unused-declaractions-of-mca_init-and-sbus_init init/main.c
--- a/init/main.c~init-mainc-remove-unused-declaractions-of-mca_init-and-sbus_init
+++ a/init/main.c
@@ -92,8 +92,6 @@ static int kernel_init(void *);
 
 extern void init_IRQ(void);
 extern void fork_init(unsigned long);
-extern void mca_init(void);
-extern void sbus_init(void);
 extern void radix_tree_init(void);
 #ifndef CONFIG_DEBUG_RODATA
 static inline void mark_rodata_ro(void) { }
_

Patches currently in -mm which might be from hukangustc@gmail.com are

init-mainc-remove-unused-declaractions-of-mca_init-and-sbus_init.patch

