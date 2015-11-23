From: akpm@linux-foundation.org
Subject: [merged] tools-vm-page-typesc-support-kpf_idle.patch removed from -mm tree
Date: Mon, 23 Nov 2015 12:15:01 -0800
Message-ID: <565373c5.GhbbBjKeTDO+qVMJ%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:53580 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752833AbbKWUPB (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 23 Nov 2015 15:15:01 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: n-horiguchi@ah.jp.nec.com, vdavydov@virtuozzo.com, mm-commits@vger.kernel.org


The patch titled
     Subject: tools/vm/page-types.c: support KPF_IDLE
has been removed from the -mm tree.  Its filename was
     tools-vm-page-typesc-support-kpf_idle.patch

This patch was dropped because it was merged into mainline or a subsystem tree

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

mm-hugetlb-fix-hugepage-memory-leak-caused-by-wrong-reserve-count.patch
rmap-add-argument-to-charge-compound-page-fix.patch
mm-hwpoison-adjust-for-new-thp-refcounting.patch

