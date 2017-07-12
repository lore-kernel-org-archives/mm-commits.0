From: akpm@linux-foundation.org
Subject: [patch 84/96] ia64: move inline before return type
Date: Wed, 12 Jul 2017 14:37:16 -0700
Message-ID: <20170712213716.qQQW1KyjW%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:55236 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752363AbdGLVhS (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 12 Jul 2017 17:37:18 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, fenghua.yu@intel.com, joe@perches.com, mm-commits@vger.kernel.org, tony.luck@intel.com, torvalds@linux-foundation.org

From: Joe Perches <joe@perches.com>
Subject: ia64: move inline before return type

Make the use of inline like the rest of the kernel.

Link: http://lkml.kernel.org/r/d47074493af80ce12590340294bc49618165c30d.1499284835.git.joe@perches.com
Signed-off-by: Joe Perches <joe@perches.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Fenghua Yu <fenghua.yu@intel.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 arch/ia64/kernel/mca.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN arch/ia64/kernel/mca.c~ia64-move-inline-before-return-type arch/ia64/kernel/mca.c
--- a/arch/ia64/kernel/mca.c~ia64-move-inline-before-return-type
+++ a/arch/ia64/kernel/mca.c
@@ -334,7 +334,7 @@ static void ia64_mlogbuf_dump_from_init(
 	ia64_mlogbuf_dump();
 }
 
-static void inline
+static inline void
 ia64_mca_spin(const char *func)
 {
 	if (monarch_cpu == smp_processor_id())
_
