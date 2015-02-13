From: akpm@linux-foundation.org
Subject: [folded-merged]
 kasan-enable-instrumentation-of-global-variables-fix-2-fix.patch removed
 from -mm tree
Date: Fri, 13 Feb 2015 14:30:10 -0800
Message-ID: <54de7af2.IIA5leTo8Gm/Bvow%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:51206 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752758AbbBMWaL (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 13 Feb 2015 17:30:11 -0500
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: akpm@linux-foundation.org, a.ryabinin@samsung.com, mm-commits@vger.kernel.org


The patch titled
     Subject: kasan-enable-instrumentation-of-global-variables-fix-2-fix
has been removed from the -mm tree.  Its filename was
     kasan-enable-instrumentation-of-global-variables-fix-2-fix.patch

This patch was dropped because it was folded into kasan-enable-instrumentation-of-global-variables.patch

------------------------------------------------------
From: Andrew Morton <akpm@linux-foundation.org>
Subject: kasan-enable-instrumentation-of-global-variables-fix-2-fix

update kasan.txt

Cc: Andrey Ryabinin <a.ryabinin@samsung.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/kasan.txt |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN Documentation/kasan.txt~kasan-enable-instrumentation-of-global-variables-fix-2-fix Documentation/kasan.txt
--- a/Documentation/kasan.txt~kasan-enable-instrumentation-of-global-variables-fix-2-fix
+++ a/Documentation/kasan.txt
@@ -9,7 +9,7 @@ a fast and comprehensive solution for fi
 bugs.
 
 KASan uses compile-time instrumentation for checking every memory access,
-therefore you will need a certain version of GCC >= 4.9.2
+therefore you will need a certain version of GCC > 4.9.2
 
 Currently KASan is supported only for x86_64 architecture and requires that the
 kernel be built with the SLUB allocator.
_

Patches currently in -mm which might be from akpm@linux-foundation.org are

origin.patch
mm-slab-convert-cache-name-allocations-to-kstrdup_const.patch
module_device_table-fix-some-callsites.patch
kasan-enable-instrumentation-of-global-variables.patch
rtc-rk808-fix-the-rtc-time-reading-issue-fix.patch

