From: akpm@linux-foundation.org
Subject: + lockstat-fix-a-typo.patch added to -mm tree
Date: Thu, 24 Jan 2013 16:05:27 -0800
Message-ID: <20130125000527.8BF285A42DB@corp2gmr1-2.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vc0-f202.google.com ([209.85.220.202]:39372 "EHLO
	mail-vc0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754597Ab3AYAF2 (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 24 Jan 2013 19:05:28 -0500
Received: by mail-vc0-f202.google.com with SMTP id m8so970061vcd.1
        for <mm-commits@vger.kernel.org>; Thu, 24 Jan 2013 16:05:28 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: yuanhan.liu@linux.intel.com, mingo@redhat.com


The patch titled
     Subject: Documentation/lockstat.txt: fix a typo
has been added to the -mm tree.  Its filename is
     lockstat-fix-a-typo.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
lockstat-fix-a-typo.patch
fs-execc-make-bprm_mm_init-static.patch

