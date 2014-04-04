From: akpm@linux-foundation.org
Subject: [merged] kernel-resourcec-make-reallocate_resource-static.patch
 removed from -mm tree
Date: Fri, 04 Apr 2014 12:32:42 -0700
Message-ID: <533f08da.SkpIzfkz6vV+TMaM%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:43189 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754111AbaDDTcn (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 4 Apr 2014 15:32:43 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org, rientjes@google.com, isimatu.yasuaki@jp.fujitsu.com, daeseok.youn@gmail.com

Subject: [merged] kernel-resourcec-make-reallocate_resource-static.patch removed from -mm tree
To: daeseok.youn@gmail.com,isimatu.yasuaki@jp.fujitsu.com,rientjes@google.com,mm-commits@vger.kernel.org
From: akpm@linux-foundation.org
Date: Fri, 04 Apr 2014 12:32:42 -0700


The patch titled
     Subject: kernel/resource.c: make reallocate_resource() static
has been removed from the -mm tree.  Its filename was
     kernel-resourcec-make-reallocate_resource-static.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Daeseok Youn <daeseok.youn@gmail.com>
Subject: kernel/resource.c: make reallocate_resource() static

sparse says:

kernel/resource.c:518:5: warning:
 symbol 'reallocate_resource' was not declared. Should it be static?

Signed-off-by: Daeseok Youn <daeseok.youn@gmail.com>
Reviewed-by: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Acked-by: David Rientjes <rientjes@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/resource.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/resource.c~kernel-resourcec-make-reallocate_resource-static kernel/resource.c
--- a/kernel/resource.c~kernel-resourcec-make-reallocate_resource-static
+++ a/kernel/resource.c
@@ -511,7 +511,7 @@ static int find_resource(struct resource
  * @newsize: new size of the resource descriptor
  * @constraint: the size and alignment constraints to be met.
  */
-int reallocate_resource(struct resource *root, struct resource *old,
+static int reallocate_resource(struct resource *root, struct resource *old,
 			resource_size_t newsize,
 			struct resource_constraint  *constraint)
 {
_

Patches currently in -mm which might be from daeseok.youn@gmail.com are

origin.patch
linux-next.patch

