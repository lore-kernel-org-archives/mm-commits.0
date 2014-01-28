From: akpm@linux-foundation.org
Subject: [merged]
 init-mainc-remove-unused-declaractions-of-mca_init-and-sbus_init.patch
 removed from -mm tree
Date: Tue, 28 Jan 2014 11:09:21 -0800
Message-ID: <52e80061.5JB6D4sFUrz6wGng%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:45485 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755143AbaA1TJV (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Tue, 28 Jan 2014 14:09:21 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, hukangustc@gmail.com

Subject: [merged] init-mainc-remove-unused-declaractions-of-mca_init-and-sbus_init.patch removed from -mm tree
To: hukangustc@gmail.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Tue, 28 Jan 2014 11:09:21 -0800


The patch titled
     Subject: init/main.c: remove unused declaractions of mca_init() and sbus_init()
has been removed from the -mm tree.  Its filename was
     init-mainc-remove-unused-declaractions-of-mca_init-and-sbus_init.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

origin.patch

