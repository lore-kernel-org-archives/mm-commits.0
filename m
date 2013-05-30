From: akpm@linux-foundation.org
Subject: + memcg-kconfig-info-update.patch added to -mm tree
Date: Thu, 30 May 2013 15:51:38 -0700
Message-ID: <51a7d7fa.U00VdX2qmBGZ8hyl%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60829 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3E3Wvj (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 30 May 2013 18:51:39 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, mhocko@suse.cz, kosaki.motohiro@jp.fujitsu.com, hannes@cmpxchg.org, dserrg@gmail.com

Subject: + memcg-kconfig-info-update.patch added to -mm tree
To: dserrg@gmail.com,hannes@cmpxchg.org,kosaki.motohiro@jp.fujitsu.com,mhocko@suse.cz
From: akpm@linux-foundation.org
Date: Thu, 30 May 2013 15:51:38 -0700


The patch titled
     Subject: memcg: Kconfig info update
has been added to the -mm tree.  Its filename is
     memcg-kconfig-info-update.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Sergey Dyasly <dserrg@gmail.com>
Subject: memcg: Kconfig info update

Now there are only 2 members in struct page_cgroup.  Update config MEMCG
description accordingly.

Signed-off-by: Sergey Dyasly <dserrg@gmail.com>
Acked-by: Michal Hocko <mhocko@suse.cz>
Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 init/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN init/Kconfig~memcg-kconfig-info-update init/Kconfig
--- a/init/Kconfig~memcg-kconfig-info-update
+++ a/init/Kconfig
@@ -885,7 +885,7 @@ config MEMCG
 
 	  Note that setting this option increases fixed memory overhead
 	  associated with each page of memory in the system. By this,
-	  20(40)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
+	  8(16)bytes/PAGE_SIZE on 32(64)bit system will be occupied by memory
 	  usage tracking struct at boot. Total amount of this is printed out
 	  at boot.
 
_

Patches currently in -mm which might be from dserrg@gmail.com are

linux-next.patch
memcg-kconfig-info-update.patch

