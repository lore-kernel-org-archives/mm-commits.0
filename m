From: akpm@linux-foundation.org
Subject: [merged] kcmp-drop-branch-leftover-typo.patch removed from
 -mm tree
Date: Wed, 04 Oct 2017 12:41:55 -0700
Message-ID: <20171004194155.PcQcbmIEN%akpm@linux-foundation.org>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail.linuxfoundation.org ([140.211.169.12]:33718 "EHLO
        mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751132AbdJDTl4 (ORCPT
        <rfc822;mm-commits@vger.kernel.org>); Wed, 4 Oct 2017 15:41:56 -0400
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: avagin@virtuozzo.com, esyr@redhat.com, gorcunov@gmail.com, gorcunov@openvz.org, mm-commits@vger.kernel.org, xemul@virtuozzo.com


The patch titled
     Subject: kernel/kcmp.c: drop branch leftover typo
has been removed from the -mm tree.  Its filename was
     kcmp-drop-branch-leftover-typo.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Cyrill Gorcunov <gorcunov@gmail.com>
Subject: kernel/kcmp.c: drop branch leftover typo

The else branch been left over and escaped the source code refresh.  Not a
problem but better clean it up.

Fixes: 0791e3644e5e ("kcmp: add KCMP_EPOLL_TFD mode to compare epoll target files")
Link: http://lkml.kernel.org/r/20170917165838.GA1887@uranus.lan
Reported-by: Eugene Syromiatnikov <esyr@redhat.com>
Signed-off-by: Cyrill Gorcunov <gorcunov@openvz.org>
Acked-by: Andrei Vagin <avagin@virtuozzo.com>
Cc: Pavel Emelyanov <xemul@virtuozzo.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 kernel/kcmp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -puN kernel/kcmp.c~kcmp-drop-branch-leftover-typo kernel/kcmp.c
--- a/kernel/kcmp.c~kcmp-drop-branch-leftover-typo
+++ a/kernel/kcmp.c
@@ -131,7 +131,7 @@ static int kcmp_epoll_target(struct task
 	if (filp_epoll) {
 		filp_tgt = get_epoll_tfile_raw_ptr(filp_epoll, slot.tfd, slot.toff);
 		fput(filp_epoll);
-	} else
+	}
 
 	if (IS_ERR(filp_tgt))
 		return PTR_ERR(filp_tgt);
_

Patches currently in -mm which might be from gorcunov@gmail.com are


