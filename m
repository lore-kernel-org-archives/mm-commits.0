From: akpm@linux-foundation.org
Subject: + x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix-2.patch added to -mm tree
Date: Fri, 20 Jan 2012 12:16:01 -0800
Message-ID: <20120120201602.75EC21E005A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gy0-f202.google.com ([209.85.160.202]:53458 "EHLO
	mail-gy0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754913Ab2ATUQE (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 20 Jan 2012 15:16:04 -0500
Received: by ghbg20 with SMTP id g20so74405ghb.1
        for <mm-commits@vger.kernel.org>; Fri, 20 Jan 2012 12:16:02 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: sfr@canb.auug.org.au, alex.shi@intel.com


The patch titled
     Subject: x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix-2
has been added to the -mm tree.  Its filename is
     x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix-2.patch

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
Subject: Subject: x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix-2

Patches currently in -mm which might be from sfr@canb.auug.org.au are

linux-next.patch
x86-use-this_cpu_xxx-to-replace-percpu_xxx-funcs-fix-2.patch

