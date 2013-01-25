From: akpm@linux-foundation.org
Subject: [merged] lockstat-fix-a-typo.patch removed from -mm tree
Date: Fri, 25 Jan 2013 13:38:04 -0800
Message-ID: <20130125213804.A7DCC5A4241@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-yh0-f74.google.com ([209.85.213.74]:55844 "EHLO
	mail-yh0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753097Ab3AYViG (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 25 Jan 2013 16:38:06 -0500
Received: by mail-yh0-f74.google.com with SMTP id z6so72836yhz.3
        for <mm-commits@vger.kernel.org>; Fri, 25 Jan 2013 13:38:05 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: yuanhan.liu@linux.intel.com, mingo@redhat.com, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/lockstat.txt: fix a typo
has been removed from the -mm tree.  Its filename was
     lockstat-fix-a-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Subject: Documentation/lockstat.txt: fix a typo

It should be CONFIG_LOCK_STAT

Signed-off-by: Yuanhan Liu <yuanhan.liu@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/lockstat.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/lockstat.txt~lockstat-fix-a-typo Documentation/lockstat.txt
--- a/Documentation/lockstat.txt~lockstat-fix-a-typo
+++ a/Documentation/lockstat.txt
@@ -65,7 +65,7 @@ that had to wait on lock acquisition.
 
  - CONFIGURATION
 
-Lock statistics are enabled via CONFIG_LOCK_STATS.
+Lock statistics are enabled via CONFIG_LOCK_STAT.
 
  - USAGE
 
_

Patches currently in -mm which might be from yuanhan.liu@linux.intel.com are

mm-fix-wrong-comments-about-anon_vma-lock.patch
linux-next.patch
fs-execc-make-bprm_mm_init-static.patch
mutex-use-spin_lock-instead-of-arch_spin_lock.patch
mutex-use-spin_lock-instead-of-arch_spin_lock-fix.patch

