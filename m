From: akpm@linux-foundation.org
Subject: + powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix.patch added to -mm tree
Date: Wed, 27 Mar 2013 12:40:21 -0700
Message-ID: <20130327194021.68A265A42FE@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f201.google.com ([209.85.161.201]:57768 "EHLO
	mail-gg0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753048Ab3C0TkW (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 27 Mar 2013 15:40:22 -0400
Received: by mail-gg0-f201.google.com with SMTP id q6so320065ggc.2
        for <mm-commits@vger.kernel.org>; Wed, 27 Mar 2013 12:40:21 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, cody@linux.vnet.ibm.com


The patch titled
     Subject: powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix
has been added to the -mm tree.  Its filename is
     powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Cody P Schafer <cody@linux.vnet.ibm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/powerpc/mm/numa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/powerpc/mm/numa.c~powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix arch/powerpc/mm/numa.c
--- a/arch/powerpc/mm/numa.c~powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix
+++ a/arch/powerpc/mm/numa.c
@@ -66,7 +66,7 @@ static void __init setup_node_to_cpumask
 
 	/* setup nr_node_ids if not done yet */
 	if (nr_node_ids == MAX_NUMNODES)
-		setup_nr_node_ids()
+		setup_nr_node_ids();
 
 	/* allocate the map */
 	for (node = 0; node < nr_node_ids; node++)
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

linux-next.patch
powerpc-mm-numa-use-setup_nr_node_ids-instead-of-opencoding-fix.patch
kconfig-consolidate-config_debug_strict_user_copy_checks.patch
kconfig-consolidate-config_debug_strict_user_copy_checks-fix.patch
kernel-forkc-export-kernel_thread-to-modules.patch

