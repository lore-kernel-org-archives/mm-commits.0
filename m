From: akpm@linux-foundation.org
Subject: [merged] documentation-sysctl-kerneltxt-document-proc-sys-shmall.patch removed from -mm tree
Date: Mon, 07 Jan 2013 11:25:36 -0800
Message-ID: <20130107192536.9EF8882004A@wpzn4.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gh0-f201.google.com ([209.85.160.201]:44683 "EHLO
	mail-gh0-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755207Ab3AGTZh (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Mon, 7 Jan 2013 14:25:37 -0500
Received: by mail-gh0-f201.google.com with SMTP id z19so1802565ghb.4
        for <mm-commits@vger.kernel.org>; Mon, 07 Jan 2013 11:25:37 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: clopez@igalia.com, Larry.Finger@lwfinger.net, mitsuo.hayasaka.hu@hitachi.com, nhorman@tuxdriver.com, rob@landley.net, tj@kernel.org, mm-commits@vger.kernel.org


The patch titled
     Subject: Documentation/sysctl/kernel.txt: document /proc/sys/shmall
has been removed from the -mm tree.  Its filename was
     documentation-sysctl-kerneltxt-document-proc-sys-shmall.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Carlos Alberto Lopez Perez <clopez@igalia.com>
Subject: Documentation/sysctl/kernel.txt: document /proc/sys/shmall

Signed-off-by: Carlos Alberto Lopez Perez <clopez@igalia.com>
Cc: Rob Landley <rob@landley.net>
Cc: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Neil Horman <nhorman@tuxdriver.com>
Cc: Mitsuo Hayasaka <mitsuo.hayasaka.hu@hitachi.com>
Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 Documentation/sysctl/kernel.txt |   13 +++++++++++++
 1 file changed, 13 insertions(+)

diff -puN Documentation/sysctl/kernel.txt~documentation-sysctl-kerneltxt-document-proc-sys-shmall Documentation/sysctl/kernel.txt
--- a/Documentation/sysctl/kernel.txt~documentation-sysctl-kerneltxt-document-proc-sys-shmall
+++ a/Documentation/sysctl/kernel.txt
@@ -561,6 +561,19 @@ are doing anyway :)
 
 ==============================================================
 
+shmall:
+
+This parameter sets the total amount of shared memory pages that
+can be used system wide. Hence, SHMALL should always be at least
+ceil(shmmax/PAGE_SIZE).
+
+If you are not sure what the default PAGE_SIZE is on your Linux
+system, you can run the following command:
+
+# getconf PAGE_SIZE
+
+==============================================================
+
 shmmax:
 
 This value can be used to query and set the run time limit
_

Patches currently in -mm which might be from clopez@igalia.com are

origin.patch

