From: akpm@linux-foundation.org
Subject: [folded-merged]
 kmemleak-change-some-global-variables-to-int-v4.patch removed from -mm tree
Date: Thu, 03 Apr 2014 14:01:52 -0700
Message-ID: <533dcc40.5Erai6oo+wqeQt69%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:60661 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753737AbaDCVBx (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 3 Apr 2014 17:01:53 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, catalin.marinas@arm.com, lizefan@huawei.com

Subject: [folded-merged] kmemleak-change-some-global-variables-to-int-v4.patch removed from -mm tree
To: lizefan@huawei.com,catalin.marinas@arm.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Thu, 03 Apr 2014 14:01:52 -0700


The patch titled
     Subject: kmemleak-change-some-global-variables-to-int-v4
has been removed from the -mm tree.  Its filename was
     kmemleak-change-some-global-variables-to-int-v4.patch

This patch was dropped because it was folded into kmemleak-change-some-global-variables-to-int.patch

------------------------------------------------------
From: Li Zefan <lizefan@huawei.com>
Subject: kmemleak-change-some-global-variables-to-int-v4

Signed-off-by: Li Zefan <lizefan@huawei.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/kmemleak.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN mm/kmemleak.c~kmemleak-change-some-global-variables-to-int-v4 mm/kmemleak.c
--- a/mm/kmemleak.c~kmemleak-change-some-global-variables-to-int-v4
+++ a/mm/kmemleak.c
@@ -1630,7 +1630,7 @@ static ssize_t kmemleak_write(struct fil
 		return ret;
 
 	if (strncmp(buf, "clear", 5) == 0) {
-		if (atomic_read(&kmemleak_enabled))
+		if (kmemleak_enabled)
 			kmemleak_clear();
 		else
 			__kmemleak_do_cleanup();
_

Patches currently in -mm which might be from lizefan@huawei.com are

origin.patch
kmemleak-free-internal-objects-only-if-therere-no-leaks-to-be-reported.patch
kmemleak-allow-freeing-internal-objects-after-kmemleak-was-disabled.patch
kmemleak-remove-redundant-code.patch
kmemleak-change-some-global-variables-to-int.patch

