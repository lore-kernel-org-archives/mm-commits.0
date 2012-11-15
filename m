From: akpm@linux-foundation.org
Subject: + documentation-sysctl-kerneltxt-document-proc-sys-shmall.patch added to -mm tree
Date: Thu, 15 Nov 2012 13:38:21 -0800
Message-ID: <20121115213821.B31C91000FF@wpzn3.hot.corp.google.com>
Reply-To: linux-kernel@vger.kernel.org
Return-path: <mm-commits-owner@vger.kernel.org>
Received: from mail-gg0-f202.google.com ([209.85.161.202]:57410 "EHLO
	mail-gg0-f202.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906Ab2KOViX (ORCPT
	<rfc822;mm-commits@vger.kernel.org>); Thu, 15 Nov 2012 16:38:23 -0500
Received: by mail-gg0-f202.google.com with SMTP id i4so227419ggm.1
        for <mm-commits@vger.kernel.org>; Thu, 15 Nov 2012 13:38:22 -0800 (PST)
Sender: mm-commits-owner@vger.kernel.org
List-Id: mm-commits@vger.kernel.org
To: mm-commits@vger.kernel.org
Cc: clopez@igalia.com, Larry.Finger@lwfinger.net, mitsuo.hayasaka.hu@hitachi.com, nhorman@tuxdriver.com, rob@landley.net, tj@kernel.org


The patch titled
     Subject: Documentation/sysctl/kernel.txt: document /proc/sys/shmall
has been added to the -mm tree.  Its filename is
     documentation-sysctl-kerneltxt-document-proc-sys-shmall.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/SubmitChecklist when testing your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

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

documentation-sysctl-kerneltxt-document-proc-sys-shmall.patch

