From: akpm@linux-foundation.org
Subject: [folded] x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix-2.patch removed from -mm tree
Date: Wed, 08 Feb 2012 12:44:27 -0800
Message-ID: <20120208204427.F17A9A03DE@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:63480 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750956Ab2BHUoa (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 8 Feb 2012 15:44:30 -0500
Received: by eaaf13 with SMTP id f13so28898eaa.1
        for <mm-commits@vger.kernel.org>; Wed, 08 Feb 2012 12:44:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: sfr@canb.auug.org.au, alex.shi@intel.com, mm-commits@vger.kernel.org


The patch titled
     Subject: x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix-2
has been removed from the -mm tree.  Its filename was
     x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix-2.patch

This patch was dropped because it was folded into x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Stephen Rothwell <sfr@canb.auug.org.au>
Subject: x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix-2

arch/x86/include/asm/desc.h: fix smp_processor_id's need for this_cpu_read

Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Alex Shi <alex.shi@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/x86/include/asm/desc.h |    1 +
 1 file changed, 1 insertion(+)

diff -puN arch/x86/include/asm/desc.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix-2 arch/x86/include/asm/desc.h
--- a/arch/x86/include/asm/desc.h~x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix-2
+++ a/arch/x86/include/asm/desc.h
@@ -6,6 +6,7 @@
 #include <asm/mmu.h>
 
 #include <linux/smp.h>
+#include <linux/percpu.h>
 
 static inline void fill_ldt(struct desc_struct *desc, const struct user_desc *info)
 {
_

Patches currently in -mm which might be from sfr@canb.auug.org.au are

linux-next.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs.patch

