From: akpm@linux-foundation.org
Subject: + tools-vm-page-typesc-support-kpf_idle.patch added to -mm tree
Date: Wed, 11 Nov 2015 14:59:37 -0800
Message-ID: <5643c859.1A+DI688ck5ny3eb%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:57622 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587AbbKKW7h (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Wed, 11 Nov 2015 17:59:37 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page-types.c: support KPF_IDLE
has been added to the -mm tree.  Its filename is
     tools-vm-page-typesc-support-kpf_idle.patch

This patch should soon appear at
    http://ozlabs.org/~akpm/mmots/broken-out/tools-vm-page-typesc-support-kpf_idle.patch
and later at
    http://ozlabs.org/~akpm/mmotm/broken-out/tools-vm-page-typesc-support-kpf_idle.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Subject: tools/vm/page-types.c: support KPF_IDLE

PageIdle is exported in include/uapi/linux/kernel-page-flags.h, so let's
make page-types.c tool handle it.

Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 tools/vm/page-types.c |    1 +
 1 file changed, 1 insertion(+)

diff -puN tools/vm/page-types.c~tools-vm-page-typesc-support-kpf_idle tools/vm/page-types.c
--- a/tools/vm/page-types.c~tools-vm-page-typesc-support-kpf_idle
+++ a/tools/vm/page-types.c
@@ -128,6 +128,7 @@ static const char * const page_flag_name
 	[KPF_THP]		= "t:thp",
 	[KPF_BALLOON]		= "o:balloon",
 	[KPF_ZERO_PAGE]		= "z:zero_page",
+	[KPF_IDLE]              = "i:idle_page",
 
 	[KPF_RESERVED]		= "r:reserved",
 	[KPF_MLOCKED]		= "m:mlocked",
_

Patches currently in -mm which might be from n-horiguchi@ah.jp.nec.com are

tools-vm-page-typesc-support-kpf_idle.patch
mm-hwpoison-adjust-for-new-thp-refcounting.patch

