From: akpm@linux-foundation.org
Subject: [merged] remove-unnecessary-break-at-mem_cgroup_read-for-invalid-memfile_type.patch removed from -mm tree
Date: Thu, 22 Mar 2012 13:20:08 -0700
Message-ID: <20120322202008.50ED3A024E@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-vb0-f74.google.com ([209.85.212.74]:36997 "EHLO
	mail-vb0-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759235Ab2CVUUJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 22 Mar 2012 16:20:09 -0400
Received: by vbnl22 with SMTP id l22so200033vbn.1
        for <mm-commits@vger.kernel.org>; Thu, 22 Mar 2012 13:20:08 -0700 (PDT)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: jeff.liu@oracle.com, mm-commits@vger.kernel.org


The patch titled
     Subject: mm/memcontrol.c: remove unnecessary 'break' in mem_cgroup_read()
has been removed from the -mm tree.  Its filename was
     remove-unnecessary-break-at-mem_cgroup_read-for-invalid-memfile_type.patch

This patch was dropped because it was merged into mainline or a subsystem tree

The current -mm tree may be found at http://userweb.kernel.org/~akpm/mmotm/

------------------------------------------------------
From: Jeff Liu <jeff.liu@oracle.com>
Subject: mm/memcontrol.c: remove unnecessary 'break' in mem_cgroup_read()

Signed-off-by: Jie Liu <jeff.liu@oracle.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/memcontrol.c |    1 -
 1 file changed, 1 deletion(-)

diff -puN mm/memcontrol.c~remove-unnecessary-break-at-mem_cgroup_read-for-invalid-memfile_type mm/memcontrol.c
--- a/mm/memcontrol.c~remove-unnecessary-break-at-mem_cgroup_read-for-invalid-memfile_type
+++ a/mm/memcontrol.c
@@ -3902,7 +3902,6 @@ static u64 mem_cgroup_read(struct cgroup
 		break;
 	default:
 		BUG();
-		break;
 	}
 	return val;
 }
_

Patches currently in -mm which might be from jeff.liu@oracle.com are

origin.patch

