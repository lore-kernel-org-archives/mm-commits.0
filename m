From: akpm@linux-foundation.org
Subject: [merged] sections-fix-section-conflicts-in-drivers-net-wan.patch removed from -mm tree
Date: Fri, 05 Oct 2012 13:13:13 -0700
Message-ID: <20121005201314.228FE200057@hpza10.eem.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-la0-f74.google.com ([209.85.215.74]:60205 "EHLO
	mail-la0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932567Ab2JEUNQ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 5 Oct 2012 16:13:16 -0400
Received: by mail-la0-f74.google.com with SMTP id j13so98801lah.1
        for <mm-commits@vger.kernel.org>; Fri, 05 Oct 2012 13:13:15 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: ak@linux.intel.com, davem@davemloft.net, khc@pm.waw.pl, mm-commits@vger.kernel.org


The patch titled
     Subject: sections: fix section conflicts in drivers/net/wan
has been removed from the -mm tree.  Its filename was
     sections-fix-section-conflicts-in-drivers-net-wan.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Andi Kleen <ak@linux.intel.com>
Subject: sections: fix section conflicts in drivers/net/wan

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Cc: Krzysztof Halasa <khc@pm.waw.pl>
Cc: David Miller <davem@davemloft.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 drivers/net/wan/z85230.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN drivers/net/wan/z85230.c~sections-fix-section-conflicts-in-drivers-net-wan drivers/net/wan/z85230.c
--- a/drivers/net/wan/z85230.c~sections-fix-section-conflicts-in-drivers-net-wan
+++ a/drivers/net/wan/z85230.c
@@ -1775,7 +1775,7 @@ EXPORT_SYMBOL(z8530_queue_xmit);
 /*
  *	Module support
  */
-static const char banner[] __initdata =
+static const char banner[] __initconst =
 	KERN_INFO "Generic Z85C30/Z85230 interface driver v0.02\n";
 
 static int __init z85230_init_driver(void)
_

Patches currently in -mm which might be from ak@linux.intel.com are

origin.patch
linux-next.patch
thp-x86-introduce-have_arch_transparent_hugepage.patch
thp-remove-assumptions-on-pgtable_t-type.patch
thp-introduce-pmdp_invalidate.patch
thp-make-madv_hugepage-check-for-mm-def_flags.patch
thp-s390-thp-splitting-backend-for-s390.patch
thp-s390-thp-pagetable-pre-allocation-for-s390.patch
thp-s390-disable-thp-for-kvm-host-on-s390.patch
thp-s390-architecture-backend-for-thp-on-s390.patch

