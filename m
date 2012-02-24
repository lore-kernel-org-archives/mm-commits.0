From: akpm@linux-foundation.org
Subject: + remove-unnecessary-break-at-mem_cgroup_read-for-invalid-memfile_type.patch added to -mm tree
Date: Fri, 24 Feb 2012 12:13:06 -0800
Message-ID: <20120224201306.A21D2A00B1@akpm.mtv.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-ey0-f202.google.com ([209.85.215.202]:45901 "EHLO
	mail-ey0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755195Ab2BXUNJ (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Fri, 24 Feb 2012 15:13:09 -0500
Received: by eaaf13 with SMTP id f13so91575eaa.1
        for <mm-commits@vger.kernel.org>; Fri, 24 Feb 2012 12:13:07 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: jeff.liu@oracle.com


The patch titled
     Subject: mm/memcontrol.c: remove unnecessary 'break' in mem_cgroup_read()
has been added to the -mm tree.  Its filename is
     remove-unnecessary-break-at-mem_cgroup_read-for-invalid-memfile_type.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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
@@ -3878,7 +3878,6 @@ static u64 mem_cgroup_read(struct cgroup
 		break;
 	default:
 		BUG();
-		break;
 	}
 	return val;
 }
_
Subject: Subject: mm/memcontrol.c: remove unnecessary 'break' in mem_cgroup_read()

Patches currently in -mm which might be from jeff.liu@oracle.com are

origin.patch
remove-unnecessary-break-at-mem_cgroup_read-for-invalid-memfile_type.patch

